import QtQuick 2.0
import QtQuick.Controls 2.0
import QtMultimedia 5.0

Item {
    signal videoCaptureButtonClicked();

    property bool secureOn: false
    property string snapshotUrl: "http://192.168.10.93:8090/?action=snapshot"
    property string streamUrl: "http://192.168.10.93:8090/?action=stream"

    MediaPlayer {
        id: mediaPlayer
        source: snapshotUrl
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
        mediaPlayer.source = secureOn ? streamUrl : snapshotUrl;
        mediaPlayer.play();
    }

}
