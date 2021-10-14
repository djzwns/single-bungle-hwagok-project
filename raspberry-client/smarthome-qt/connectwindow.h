#ifndef CONNECTWINDOW_H
#define CONNECTWINDOW_H

#include <QObject>
#include <QQuickView>
#include <QQuickItem>
#include "smarthomeclient.h"

class ConnectWindow : public QObject
{
    Q_OBJECT
public:
    explicit ConnectWindow(QObject *parent = nullptr);
    ~ConnectWindow();

    void init(QQuickWindow *window, SmartHomeClient *client);

signals:
    void signalDeviceConnect(QVariant);

private slots:
    void slotRecvData(QVariant);
    void slotRecvData(QString);

private:
    void setWindow(QQuickWindow *window);
    void setClient(SmartHomeClient *client);
    void connectSignalSlot();

    QQuickWindow *mainView;
    SmartHomeClient *client;

};

#endif // CONNECTWINDOW_H
