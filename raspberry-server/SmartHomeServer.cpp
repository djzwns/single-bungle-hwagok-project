/*
    SmartHomeServer.cpp
*/

#include "SmartHomeServer.h"
#include <stdlib.h>
#include <algorithm>
#include <unistd.h>     // low level read write 함수 사용
#include <arpa/inet.h>  // host 주소 변환


void SmartHomeServer::init(string port)
{
    cout << "Smart Home Server Start" << endl;

    // server socket & address init
    serverSocket = socket(PF_INET, SOCK_STREAM, 0);
    memset(&serverAddress, 0, sizeof(serverAddress));
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = htonl(INADDR_ANY);
    serverAddress.sin_port = htons(atoi(port.c_str()));

    int result;
    setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, (void*)&socketOption, sizeof(socketOption));
    result = bind(serverSocket, (struct sockaddr *)&serverAddress, sizeof(serverAddress));
    if (result == -1)
        errorHandling("bind() error");

    result = listen(serverSocket, 5);
    if (result == -1)
        errorHandling("listen() error");
}

void SmartHomeServer::run()
{
    while (1) 
    {
        // 접속 요청 대기
        clientAddressSize = sizeof(clientAddress);
        clientSocket = accept(serverSocket, (struct sockaddr *)&clientAddress, (socklen_t *)&clientAddressSize);
        if (clientSocket < 0) {
            perror("accept()");
            continue;
        }

        // 접속 성공 시 데이터 읽기
        messageLength = read(clientSocket, idpass, sizeof(idpass));
        idpass[messageLength] = '\0';
        if (messageLength <= 0) 
            shutdown(clientSocket, SHUT_WR);

        // 데이터 파싱
        char* token = strtok(idpass, "[:]");
        char* command[ARR_CNT];
        int cmd_cnt = 0;
        while (token != NULL) 
        {
            command[cmd_cnt] = token;
            if (cmd_cnt++ >= ARR_CNT)
                break;
            token = strtok(NULL, "[:]");
        }
        char* id = command[0];
        char* pw = command[1];

        // account check
        bool valid = dbManager.accountCheck(id, pw);
        if (valid) {

            // valid id, try connect
#if DEBUG
            cout << id << ": account exist." << endl;
#endif
            bool is_already_connected = false;
            for(auto client = clients.begin(); client != clients.end(); ++client)
            {
                // conneceted id
                if (client->id.compare(id) == 0) {
                    is_already_connected = true;
                    break;
                }
            }

            if (is_already_connected) {
                shutdown(clientSocket, SHUT_WR);
                continue;
            }

        }
        
        string ip = inet_ntoa(clientAddress.sin_addr);
        string msg = ""; 
        if (valid) {
            msg.append("[").append(id).append("]")
            .append("New connected! (ip:").append(ip)
            .append(", fd: ").append(to_string(clientSocket)).append(")\n");

        } else {            
            msg.append("Requesting to create an account. (id:").append(id)
            .append(", password: ").append(pw).append(")\n");

            msg_info info;
            info.fd = clientSocket;
            info.from = id;
            info.to = "admin";
            info.msg.append("[").append(id).append("]ACCOUNT@").append(pw).append("\n");
            info.len = info.msg.length();
            sendMessage(info);
        }

        write(clientSocket, msg.c_str(), msg.length());

        client_info client;
        client.fd = clientSocket;
        client.id = id;
        client.pw = pw;
        client.ip = ip;
        client.valid = valid;
        connectClient(client);

        // pthread 대체.. c++ 에서 사용할 쓰레드 객체
        thread t(&SmartHomeServer::clientThread, this, client);
        t.detach();

#if DEBUG
        cout << msg << endl;
#endif
    }
}

void SmartHomeServer::clientThread(client_info client)
{
    int str_len = 0;
    char msg[BUF_SIZE];
    string to_msg;
    char *token;
    char *command[ARR_CNT];
    const char *format = "[:]";
    int cmd_cnt = 0;

    msg_info info;

    while (1) 
    {
        memset(msg, 0, sizeof(msg));
        str_len = read(client.fd, msg, sizeof(msg) - 1);
        if (str_len <= 0)
            break;

        msg[str_len] = '\0';
        token = strtok(msg, format);
        cmd_cnt = 0;
        while (token != NULL) 
        {
            command[cmd_cnt] = token;
            if (cmd_cnt++ >= ARR_CNT)
                break;
            token = strtok(NULL, format);
        }

        // create message info
        info.fd = client.fd;
        info.from = client.id;
        info.to = command[0];
        to_msg.clear();
        to_msg += "[" + info.from + "]" + command[1];
        info.msg = to_msg;
        info.len = to_msg.length();
        sendMessage(info);
    }

    close(client.fd);
    disconnectClient(client.fd, client.valid);
}

void SmartHomeServer::sendMessage(const msg_info& msg_info)
{
#if DEBUG
        cout << "to: " << msg_info.to << ", from: " << msg_info.from << ", msg: " << msg_info.msg << endl;
#endif
    if ( !msg_info.from.compare("admin") ) {
        // admin 계정용 메세지 처리
        sendWhisper(msg_info, false);
    }

    if ( !msg_info.to.compare("ALLMSG") ) {
        sendMessageAll(msg_info);

    } else if ( !msg_info.to.compare("IDLIST") ) {
        string msg;
        msg.append(msg_info.msg).pop_back();
        msg.append(getClientList()).append("\n");
        write(msg_info.fd, msg.c_str(), msg.length());

    } else {    // whisper
        sendWhisper(msg_info);
    }
}

void SmartHomeServer::sendMessageAll(const msg_info& msg_info)
{
    for_each(clients.begin(), clients.end(), 
        [&msg_info](const client_info& client)
        {
            write(client.fd, msg_info.msg.c_str(), msg_info.len);
        }
    );
}

void SmartHomeServer::sendWhisper(const msg_info& msg_info, bool valid)
{
    // 유효하지 않을 수 있는 계정 체크용
    if (!valid) {
        for (auto client = tempClients.begin(); client != tempClients.end(); ++client) 
        {
            // 유효하지 않은 계정에게 보내는 메시지 처리
            if ( !client->id.compare(msg_info.to) )  {
                write(client->fd, msg_info.msg.c_str(), msg_info.len);

                char *token;
                char *command[ARR_CNT];
                int cmd_cnt = 0;
                char msg[BUF_SIZE] = { 0 };
                strcpy(msg, msg_info.msg.c_str());
                token = strtok(msg, "[:]");
                while (token != NULL) 
                {
                    command[cmd_cnt] = token;
                    if (cmd_cnt++ >= ARR_CNT)
                        break;
                    token = strtok(NULL, "[:]");
                }

                // 임시 접속 큐에서 제거
                disconnectClient(client->fd, false);

                // 기기 등록 수락
                cout << "command: " << command[1] << endl;
                if ( !strncmp(command[1], "ACCOUNTOK", 9) ) {    
                    // db 등록  
                    dbManager.insert(TBUSER, client->id, client->pw);
                    client->valid = true;

                    // 임시 접속-> 정상 접속으로 전환
                    connectMutex.lock();
                    clients.push_back(*client);
                    connectMutex.unlock();

                } else { 
                    // 기기 등록 거절시 접속 해제
                    close(client->fd);
                }
                return;
            }
        }
    }

    // 유효한 계정 귓속말
    for (auto client = clients.begin(); client != clients.end(); ++client) 
    {
        if ( !client->id.compare(msg_info.to) ) 
            write(client->fd, msg_info.msg.c_str(), msg_info.len);
    }
}

void SmartHomeServer::errorHandling(string msg)
{
    perror(msg.c_str());
    exit(1);
}

void SmartHomeServer::connectClient(client_info client)
{    
    connectMutex.lock();
    if (client.valid) 
        clients.push_back(client);
    else
        tempClients.push_back(client);
    connectMutex.unlock();    
}

void SmartHomeServer::disconnectClient(int fd, bool valid)
{
    connectMutex.lock();
    if (valid) 
        eraseClients(fd, &clients);
    else
        eraseClients(fd, &tempClients);
    connectMutex.unlock();
}

void SmartHomeServer::eraseClients(int fd, vector<client_info> *v)
{
    int index = 0;
    for (auto client = v->begin(); client != v->end(); ++client)
    {
        if (client->fd == fd) {
            v->erase(v->begin() + index);
            break;
        }
        index++;
    }
}

string SmartHomeServer::getClientList()
{
    string clientList;
    for_each(clients.begin(), clients.end(), 
        [&clientList](client_info& client) 
        {
            clientList.append(client.id).append(" ");
        }
    );
    return clientList;
}

SmartHomeServer::SmartHomeServer()
{

}

SmartHomeServer::~SmartHomeServer()
{

}