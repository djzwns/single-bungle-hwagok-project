#include "connectwindow.h"
#include <QDebug>

ConnectWindow::ConnectWindow(QObject *parent) : QObject(parent)
{

}

ConnectWindow::~ConnectWindow()
{

}


void ConnectWindow::setWindow(QQuickWindow *window)
{
    mainView = window;
    connectSignalSlot();
}

void ConnectWindow::connectSignalSlot()
{
    connect(this, SIGNAL(signalDeviceConnect(QVariant)), mainView, SLOT(slotDeviceConnect(QVariant)));
    connect(mainView, SIGNAL(sendData(QVariant)), this, SLOT(slotRecvData(QVariant)));


    //emit signalDeviceConnect("TEST:Device ID");
}

void ConnectWindow::slotRecvData(QVariant data)
{
    QString string = data.toString();
    qDebug() << string;
}
