#include "connectwindow.h"
#include <QDebug>

ConnectWindow::ConnectWindow(QObject *parent) : QObject(parent)
{
}

ConnectWindow::~ConnectWindow()
{
    if (client != nullptr)
        delete client;
    client = nullptr;
}

void ConnectWindow::init(QQuickWindow *window, SmartHomeClient *client)
{
    setWindow(window);
    setClient(client);
    connectSignalSlot();
}

void ConnectWindow::setWindow(QQuickWindow *window)
{
    mainView = window;
}

void ConnectWindow::setClient(SmartHomeClient *client)
{
    this->client = client;
}

void ConnectWindow::connectSignalSlot()
{
    connect(this, SIGNAL(signalDeviceConnect(QVariant)), mainView, SLOT(slotDeviceConnect(QVariant)));
    connect(mainView, SIGNAL(sendData(QVariant)), this, SLOT(slotRecvData(QVariant)));
    connect(client, SIGNAL(signalSocketRecv(QString)), this, SLOT(slotRecvData(QString)));

    //emit signalDeviceConnect("TEST:Device ID");
}

void ConnectWindow::slotRecvData(QVariant data)
{
    QString string = data.toString();
    qDebug() << string;
    client->slotSocketSendData(string);
}

void ConnectWindow::slotRecvData(QString data)
{
    qDebug() << data;
    QStringList dataList = data.split(QRegExp("\\W+"), QString::SkipEmptyParts);
    if (dataList[1].compare("ACCOUNT") == 0) {
        emit signalDeviceConnect(dataList[0]);
    }
}
