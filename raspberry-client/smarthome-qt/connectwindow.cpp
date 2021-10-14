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

    connect(this, SIGNAL(signalRecvTemperature(QVariant)), mainView, SLOT(slotSetTemperature(QVariant)));
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
    QStringList dataList = data.split(QRegExp("[^A-Za-z0-9-]"), QString::SkipEmptyParts);
    if (dataList[1].compare("ACCOUNT") == 0) {
        emit signalDeviceConnect(dataList[0]);
    } else if (dataList[1].compare("TEMP") == 0) {
        bool ok = false;
        int temp = dataList[2].toInt(&ok);
        if (ok)
            emit signalRecvTemperature(temp);
    }
}
