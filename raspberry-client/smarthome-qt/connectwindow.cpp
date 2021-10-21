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
    connect(mainView, SIGNAL(cardToggled(QVariant, QVariant)), this, SLOT(slotCardToggled(QVariant, QVariant)));
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

    // command check
    if (dataList[1].compare("ACCOUNT") == 0) {
        emit signalDeviceConnect(dataList[0]);

    } else if (dataList[1].compare("TEMP") == 0) {        
        bool ok = false;
        int temp = dataList[2].toInt(&ok);
        if (ok)
            emit signalRecvData(temp, dataList[1]);

    } else if (dataList[1].compare("HUMI") == 0) {
        bool ok = false;
        int humi = dataList[2].toInt(&ok);
        if (ok)
            emit signalRecvData(humi, dataList[1]);

    } else if (dataList[1].compare("AIR") == 0) {
        bool ok = false;
        int humi = dataList[2].toInt(&ok);
        if (ok)
            emit signalRecvData(humi, dataList[1]);

    }
}

void ConnectWindow::slotCardToggled(QVariant checked, QVariant type)
{
    bool check = checked.toBool();
    QString cardType = type.toString();
    QString checkString = check ? "ON\n" : "OFF\n";
    checkString.push_front("[" + cardType + "]" + cardType + "@");
    qDebug() << checkString;
    client->slotSocketSendData(checkString);
}
