#include "SmartHomeClient.h"

int main(int argc, char* argv[])
{
	if(argc != 5) {
		printf("Usage : %s <ip> <port> <id> <password>\n",argv[0]);
		exit(1);
	}
    SmartHomeClient client;
    string ip = argv[1];
    string port = argv[2];
    string id = argv[3];
    string pw = argv[4];

    client.init(ip, port);
    client.login(id, pw);

    return 0;
}