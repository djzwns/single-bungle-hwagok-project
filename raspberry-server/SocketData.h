#ifndef _SOCKET_DATA_
#define _SOCKET_DATA_

#include <string>

using namespace std;

typedef struct {
    char fd;
    string from;
    string to;
    string msg;
    int len;
} msg_info;

typedef struct
{
    int fd;
    string ip;
    string id;
    string pw;
    bool valid;
} client_info;

#endif//_SOCKET_DATA_