import QtQuick 2.0
import QtQuick.Controls 2.0
//import QtMultimedia 5.0
//import QtWebEngine 1.0
//import QtWebKit 3.0

Item {
    signal videoCaptureButtonClicked();
/*
    property bool secureOn: false
    property string snapshotUrl: "http://192.168.10.93:8090/?action=snapshot"
    property string streamUrl: "http://192.168.10.93:8090/?action=stream"

    MediaPlayer {
        id: mediaPlayer
        source: "https://www.youtube.com/embed/INGzE4QBGDA?autoplay=1"
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaPlayer
    }

    Button {
        Rectangle {
            anchors.fill: parent
            color: "orange"
        }

        onClicked: videoCaptureButtonClicked()
    }

    function update() {
        //mediaPlayer.source = secureOn ? streamUrl : snapshotUrl;
        mediaPlayer.play();
    }
*/
//    width: parent.width
//    height: width * 0.75
//    WebView {
//        id: webview
//        anchors.fill: parent
//        opacity: 0
//        url: "https://google.com"

//        Behavior on opacity {
//            NumberAnimation { duration: 200 }
//        }

//        onLoadingChanged: {
//            switch (loadRequest.status)
//            {
//            case WebView.LoadSucceededStatus:
//                opacity = 1;
//                break;
//            default:
//                opacity = 0;
//                break;
//            }
//        }

//        onNavigationRequested: {
//            request.action = WebView.AcceptRequest;
//        }
//    }
}
