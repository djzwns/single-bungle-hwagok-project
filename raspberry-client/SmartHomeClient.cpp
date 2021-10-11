#include "SmartHomeClient.h"
#include <time.h>
#include <iostream>

void SmartHomeClient::init(string ip, string port)
{
    sock = socket(PF_INET, SOCK_STREAM, 0);
    if (sock < 0)
        errorHandling("socket() error");
        
    memset(&serverAddress, 0, sizeof(serverAddress));
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(ip.c_str());
    serverAddress.sin_port = htons(atoi(port.c_str()));
}

void SmartHomeClient::login(string id, string pw)
{
    this->id = id;
    this->passwd = pw;

    int result = connect(sock, (struct sockaddr *)&serverAddress, sizeof(serverAddress));
    if (result < 0)
        errorHandling("connect() error");

    string msg = "[";
    msg += id + ":" + pw + "]\n";
    write(sock, msg.c_str(), msg.length());

    thread send(&SmartHomeClient::sendMessage, this, sock);
    thread recv(&SmartHomeClient::recvMessage, this, sock);

    recv.detach();
    send.join();

    close(sock);
}

void SmartHomeClient::sendMessage(int socket)
{
    string message;
    char msg[BUF_SIZE];
    int result;
    fd_set initset, newset;
    struct timeval tv;

    FD_ZERO(&initset);
    FD_SET(STDIN_FILENO, &initset);

	fputs("Input a message! [ID]msg (Default ID:ALLMSG)\n",stdout);
    while (1) 
    {
        memset(msg, 0, sizeof(msg));
        tv.tv_sec = 1;
        tv.tv_usec = 0;
        newset = initset;
        result = select(STDIN_FILENO + 1, &newset, NULL, NULL, &tv);
        if (result < 0) {
            errorHandling("select() error");
        }
        
        if (FD_ISSET(STDIN_FILENO, &newset)) {

            fgets(msg, BUF_SIZE, stdin);
            if ( !strncmp(msg, "quit\n", 5) ) {
                
                return;
            }

            message.clear();
            if (msg[0] != '[') 
                message.append("[ALLMSG]");

            message.append(msg);
            //message.pop_back(); // '\n' remove
            //message.append("\n");
            result = write(socket, message.c_str(), message.length());
            if (result <= 0) 
                errorHandling("write() error");     
        }
    }
}

void SmartHomeClient::recvMessage(int socket)
{
    char *token;
    char *command[ARR_CNT];
    int msgLength;
    string message;
    char msg[BUF_SIZE + 20];

    while (1)
    {
        message.clear();
        memset(msg, 0, sizeof(msg));
        msgLength = read(socket, msg, sizeof(msg) - 1);
        if (msgLength <= 0)
            return;

        message.append(msg);
        fputs(message.c_str(), stdout);
    }
}

void SmartHomeClient::errorHandling(string msg)
{
    perror(msg.c_str());
    exit(1);
}

SmartHomeClient::SmartHomeClient() {}
SmartHomeClient::~SmartHomeClient() {}