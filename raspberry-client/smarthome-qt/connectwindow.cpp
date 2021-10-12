#include "connectwindow.h"

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


    //emit signalDeviceConnect("TEST:Device ID");
}
