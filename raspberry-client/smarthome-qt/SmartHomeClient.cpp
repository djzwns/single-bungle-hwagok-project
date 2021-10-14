#include "smarthomeclient.h"
#include <QDebug>

SmartHomeClient::SmartHomeClient(QString ip, int port, QObject *parent) : QObject(parent)
{
    socket = new QTcpSocket();
    IP = ip;
    PORT = port;

    connect(socket, SIGNAL(connected()), this, SLOT(slotConnectServer()));
    connect(socket, SIGNAL(disconnected()), this, SLOT(slotClosedByServer()));
    connect(socket, SIGNAL(readyRead()), this, SLOT(slotSocketReadData()));
    connect(socket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(slotSocketError()));
}

void SmartHomeClient::slotConnectServer()
{
    QString str = "[" + ID + ":" + PW + "]";
    QByteArray byteStr = str.toLocal8Bit();
    socket->write(byteStr);
}

void SmartHomeClient::connectToServer(QString id, QString pw)
{
    ID = id;
    PW = pw;
    socket->connectToHost(IP, PORT);
}

void SmartHomeClient::slotClosedByServer()
{
    socket->close();
}

void SmartHomeClient::slotSocketReadData()
{
    QString recvData;
    QByteArray recvArray;

    if (socket->bytesAvailable() > BLOCK_SIZE)
        return;

    recvArray = socket->read(BLOCK_SIZE);
    recvData = QString::fromUtf8(recvArray);
    recvData.chop(1);
    emit signalSocketRecv(recvData);
}

void SmartHomeClient::slotSocketError()
{
    QString str = socket->errorString();
    qDebug() << str;
}

void SmartHomeClient::slotSocketSendData(QString send)
{
    if (send.isEmpty())
        return;

    send = send + "\n";
    QByteArray sendbyte = send.toLocal8Bit();
    socket->write(sendbyte);
}

SmartHomeClient::~SmartHomeClient()
{
    socket->close();
}
