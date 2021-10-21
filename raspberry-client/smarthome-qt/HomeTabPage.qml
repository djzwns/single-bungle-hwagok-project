import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import "colorhelper.js" as ColorHelper

Item {
    id: homeTabRoot
    anchors.fill: parent
    QtObject {
        id: temperature
        property real value: 0
        property real startValue: 0
        property real endValue: 22
        property real duration: 500

//        SequentialAnimation on value {
//            loops: Animation.Infinite
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//            NumberAnimation { to: radial.maxValue; duration: 2000 }
//            NumberAnimation { to: radial.minValue; duration: 2000 }
//        }
        NumberAnimation on value {
            id: anim
            from: temperature.startValue
            to: temperature.endValue
            duration: temperature.duration
        }
    }

    property color primaryColor: "green"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 5

        Text {
            id: title
            text: "Home"
            font.bold: true
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        }

        RadialBar {
            id: radial
            Layout.minimumWidth: 100
            Layout.minimumHeight: 100
            Layout.maximumWidth: 250
            Layout.maximumHeight: 250
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.column: 1

            value: temperature.value
            minValue: -20
            maxValue: 40
            progressColor: homeTabRoot.primaryColor//ColorHelper.tempColorLerp(valueRate)
        }

        RowLayout {
            id: cardGrid
            spacing: 20
            Layout.alignment: Qt.AlignHCenter

            Card {
                id: aircon

                bgColor: homeTabRoot.primaryColor
                text: "Humidity "
                value: "20%"
                type: "aircon"
            }

            Card {
                id: airfresh

                bgColor: homeTabRoot.primaryColor
                text: "Air Fresh "
                value: "37㎍/m³"
                type: "airfresh"
                pointView: true
            }
        }

        RowLayout {
            id: cardGrid2
            spacing: 20
            anchors.top: cardGrid.bottom
            anchors.topMargin: 20
            Layout.alignment: Qt.AlignHCenter

            Card {
                id: secure

                bgColor: homeTabRoot.primaryColor
                text: "Secure "
                type: "secure"
            }

            Card {
                id: curtain

                bgColor: homeTabRoot.primaryColor
                text: "Window "
                type: "window"
            }
        }
    }



    function setTemp(temp) {
        temperature.startValue = temperature.value;
        temperature.endValue = temp;
        HomeProperty.currentTemperature = temp

        let duration = Math.abs(temperature.endValue - temperature.startValue);
        duration = duration < 10 ? 200 : 500;
        temperature.duration = duration;
        anim.restart();
    }

    function setHumi(humi) {
        aircon.value = humi + "%";
    }

    function setAir(air) {
        airfresh.value = air + "㎍/m³";
    }

    function animRestart() {
        temperature.startValue = 0;
        temperature.duration = temperature.endValue < 10 ? 200 : 500;
        anim.restart();
    }
}
