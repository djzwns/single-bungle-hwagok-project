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
    connect(this, SIGNAL(signalWarning(QVariant)), mainView, SLOT(slotWarning(QVariant)));
    connect(this, SIGNAL(signalDetection(QVariant)), mainView, SLOT(slotDetection(QVariant)));
    connect(this, SIGNAL(signalRecvData(QVariant, QVariant)), mainView, SLOT(slotSetData(QVariant, QVariant)));

    connect(mainView, SIGNAL(cardToggled(QVariant, QVariant)), this, SLOT(slotCardToggled(QVariant, QVariant)));
    connect(mainView, SIGNAL(sendData(QVariant)), this, SLOT(slotRecvData(QVariant)));
    connect(mainView, SIGNAL(colorChanged(QVariant)), this, SLOT(slotRecvData(QVariant)));

    connect(client, SIGNAL(signalSocketRecv(QString)), this, SLOT(slotRecvData(QString)));
}

// qml 하고 통신용
void ConnectWindow::slotRecvData(QVariant data)
{
    QString string = data.toString();
    qDebug() << string;
    client->slotSocketSendData(string);
}

// 서버랑 통신용
void ConnectWindow::slotRecvData(QString data)
{
    qDebug() << data;
    QStringList dataList = data.split(QRegExp("[^A-Za-z0-9-]"), QString::SkipEmptyParts);

    // command check
    if (dataList[1].compare("ACCOUNT") == 0) {
        emit signalDeviceConnect(dataList[0]);

    } else if (dataList[1].compare("warning") == 0) {
        emit signalWarning(dataList[0]);

    } else if (dataList[1].compare("detection") == 0) {
        emit signalDetection(dataList[0]);

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

    } else if (dataList[1].compare("LIGHT") == 0) {
        bool ok = false;
    }
}

void ConnectWindow::slotCardToggled(QVariant checked, QVariant type)
{
    bool check = checked.toBool();
    QString cardType = type.toString();
    QString checkString = check ? "ON\n" : "OFF\n";
    if (cardType == "airfresh")
        checkString.push_front("[aircon]" + cardType + "@");
    else
        checkString.push_front("[" + cardType + "]" + cardType + "@");
    qDebug() << checkString;
    client->slotSocketSendData(checkString);
}

void ConnectWindow::slotColorChanged(QVariant color)
{
    QString colorString = color.toString();
    qDebug() << colorString;
    client->slotSocketSendData(colorString);
}
