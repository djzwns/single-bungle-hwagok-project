/*
    SmartHomeClient.h
*/

#ifndef _SMART_HOME_CLIENT_
#define _SMART_HOME_CLIENT_


#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <thread>

#define BUF_SIZE 100
#define ARR_CNT 5

using namespace std;

class SmartHomeClient
{
public:
    void init(string ip, string port);
    void login(string id, string pw);

    SmartHomeClient();
    ~SmartHomeClient();

private:
    void sendMessage(int socket);
    void recvMessage(int socket);
    void errorHandling(string msg);

private:
    string id;
    string passwd;
    int sock;
    struct sockaddr_in serverAddress;
};

#endif//_SMART_HOME_CLIENT_
