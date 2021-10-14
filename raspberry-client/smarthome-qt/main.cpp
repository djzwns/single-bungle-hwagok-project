#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "connectwindow.h"
#include "smarthomeclient.h"

int main(int argc, char *argv[])
{
//    if(argc != 5) {
//        printf("Usage : %s <ip> <port> <id> <password>\n",argv[0]);
//        exit(1);
//    }

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QObject *root = engine.rootObjects()[0];
    ConnectWindow *window = new ConnectWindow();

    QString ip = "192.168.10.88";//argv[1];
    QString port = "5000";//argv[2];
    QString id = "admin";//argv[3];
    QString pw = "admin";//argv[4];
    SmartHomeClient client(ip, port.toInt());
    client.connectToServer(id, pw);

    window->init(qobject_cast<QQuickWindow *>(root), &client);

    return app.exec();
}
