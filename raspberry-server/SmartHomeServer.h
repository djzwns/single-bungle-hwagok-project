/*
    SmartHomeServer.h
*/

#ifndef _SMARTHOME_SERVER_
#define _SMARTHOME_SERVER_

#include <vector>
#include <string.h>
#include <sys/socket.h> // socket≈ÎΩ≈
#include <netinet/in.h> // ipv4 
#include <thread>
#include <mutex>

#include "SmartHomeDB.h"
#include "SocketData.h"

#define DEBUG 1

#define BUF_SIZE 100
#define MAX_CLNT 32
#define ID_SIZE 10
#define ARR_CNT 5

class SmartHomeServer
{
public:
    void init(string port);
    void run();
    SmartHomeServer();
    ~SmartHomeServer();

private:
    void clientThread(client_info client);

    void sendMessage(const msg_info& msg_info);
    void sendMessageAll(const msg_info& msg_info);
    void sendWhisper(const msg_info& msg_info, bool valid = true);

    void errorHandling(string msg);

    void connectClient(client_info client);
    void disconnectClient(int fd, bool valid = true);
    void eraseClients(int fd, vector<client_info> *v);

    string getClientList();

private:
    DBManager dbManager;
    int serverSocket;
    int clientSocket;

    int messageLength;

    struct sockaddr_in serverAddress;
    struct sockaddr_in clientAddress;

    int clientAddressSize;
    int socketOption;

    mutex connectMutex;

    vector<client_info> clients;    // connected clients.
    vector<client_info> tempClients;

    char idpass[100];
};

#endif//_SMARTHOME_SERVER_