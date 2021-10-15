#ifndef SMARTHOMECLIENT_H
#define SMARTHOMECLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QHostAddress>

#define BLOCK_SIZE 1024
class SmartHomeClient : public QObject
{
    Q_OBJECT

public:
    void connectToServer(QString id, QString pw);
    explicit SmartHomeClient(QString ip, int port, QObject *parent = nullptr);
    ~SmartHomeClient();

signals:
    void signalSocketRecv(QString);
    void signalDeviceTryConnect(QString);

public slots:
    void slotClosedByServer();
    void slotSocketSendData(QString);

private slots:
    void slotSocketReadData();
    void slotSocketError();
    void slotConnectServer();

private:
    QTcpSocket *socket;
    QString IP;
    int PORT;
    QString ID;
    QString PW;

};

#endif // SMARTHOMECLIENT_H
