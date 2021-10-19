import socket
from threading import Thread


class Client:

    def __init__(self, host, port):
        self.address = (host, port)
        self.secureMode = False

    def __del__(self):
        self.sock.close()

    def init(self, id, pw):
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.connect(self.address)
            self.sock.send(f"[{id}:{pw}]".encode())

    def run(self):        
        self.recvThread = Thread(target=self.recvMsg, daemon=True)
        self.sendThread = Thread(target=self.sendMsg, daemon=True)

        self.recvThread.start()
        self.sendThread.start()

    def isAlive(self):
        return self.sendThread.is_alive() and self.recvThread.is_alive()

    def recvMsg(self):
        while True:
            try:
                data = self.sock.recv(1024)
                if not data:
                    break
                msg = data.decode()
                print(msg)
                if msg == "[admin]SECURE@ON\n":
                    self.secureMode = True
                elif msg == "[admin]SECURE@OFF\n":
                    self.secureMode = False
            except:
                pass

    def sendMsg(self):
        while True:
            msg = input()
            if msg == "quit\n":
                break
            if msg[0] != '[':
                msg = "[ALLMSG]" + msg + "\n"

            self.sock.send(msg.encode())

    def send(self, msg:str):
        if msg[0] != '[':
            msg = '[ALLMSG]' + msg
        self.sock.send(msg.encode())