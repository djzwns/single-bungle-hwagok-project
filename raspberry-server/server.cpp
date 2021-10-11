#include "SmartHomeServer.h"

int main(int argc, char* argv[])
{
	if(argc != 2) {
		printf("Usage : %s <port>\n",argv[0]);
		exit(1);
	}

    SmartHomeServer server;

    string port = argv[1];
    server.init(port);
    server.run();

    return 0;
}