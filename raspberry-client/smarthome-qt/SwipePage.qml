import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {

    SwipeView {
        id: swipeView

        currentIndex: tabBar.currentIndex
        anchors.fill: parent

        // my pages add..
        Item {

            HomeTabPage {
                id: homeTab
                primaryColor: "white"//Style.airconLightColor
            }
        }
        Item {
            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "green"
            }
        }
        Item {
            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "yellow"
            }
        }
        Item {
            Text {
                width: 200
                height: 100
                text: HomeProperty.currentTemperature
            }

            Rectangle {
                implicitHeight: 50
                implicitWidth: 50
                color: "lightblue"
            }
        }
        Item {

            SecureTabPage {
                id: secureTab
            }
        }
    }

    TabBar {
        id: tabBar

        readonly property color iconColor: "#8fe5e5e5"//Style.backgroundColor(getTabType(), Style.light)
        readonly property color iconPressedColor: Style.startColor//Style.backgroundColor(getTabType(), Style.normal)
        readonly property string fontType: "Courier"

        width: parent.width
        height: parent.height * 0.07
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex
        background: Rectangle {
            color: "transparent"//tabBar.bgColor
            radius: Math.min(parent.width, parent.heigth) * 0.5
        }
        Layout.alignment: Qt.AlignVCenter

        TabButton {
            id: home
            font {
                family: tabBar.fontType
                weight: Font.bold
            }

            display: AbstractButton.TextUnderIcon
            onClicked: {
                homeTab.animRestart();
            }
            icon {
                name: "Home"
                source: "qrc:/images/home.png"
                color: tabBar.currentIndex === 0 ? "white" : tabBar.iconColor
            }
            background: Rectangle {
                color: "transparent"//tabBar.bgColor
                radius: Math.min(parent.width, parent.heigth) * 0.5
            }
        }

        TabButton {
            id: led
            font {
                family: tabBar.fontType
                weight: Font.bold
            }
            display: AbstractButton.TextUnderIcon
            onClicked: {
            }
            icon {
                name: "LED"
                source: "qrc:/images/light.png"
                color: tabBar.currentIndex === 1 ? "white" : tabBar.iconColor
            }
            background: Rectangle {
                color: "transparent"//tabBar.bgColor
                radius: Math.min(parent.width, parent.heigth) * 0.5
            }
        }

        TabButton {
            id: air
            font {
                family: tabBar.fontType
                weight: Font.bold
            }
            display: AbstractButton.TextUnderIcon
            onClicked: {
            }
            icon {
                name: "Air"
                source: "qrc:/images/aircon.png"
                color: tabBar.currentIndex === 2 ? "white" : tabBar.iconColor
            }
            background: Rectangle {
                color: "transparent"//tabBar.bgColor
                radius: Math.min(parent.width, parent.heigth) * 0.5
            }
        }

        TabButton {
            id: stats
            font {
                family: tabBar.fontType
                weight: Font.bold
            }
            display: AbstractButton.TextUnderIcon
            onClicked: {
                secureTab.videoUpdate()
            }
            icon {
                name: "Stats"
                source: "qrc:/images/chart.png"
                color: tabBar.currentIndex === 3 ? "white" : tabBar.iconColor
            }
            background: Rectangle {
                color: "transparent"//tabBar.bgColor
                radius: Math.min(parent.width, parent.heigth) * 0.5
            }
        }

        TabButton {
            id: secure
            font {
                family: tabBar.fontType
                weight: Font.bold
            }
            display: AbstractButton.TextUnderIcon
            onClicked: {
                secureTab.videoUpdate()
            }
            icon {
                name: "Secure"
                source: "qrc:/images/secure.png"
                color: tabBar.currentIndex === 4 ? "white" : tabBar.iconColor
            }
            background: Rectangle {
                color: "transparent"//tabBar.bgColor
                radius: Math.min(parent.width, parent.heigth) * 0.5
            }
        }
    }

    function setTemp(temp) {
        homeTab.setTemp(temp)
    }

    function getTabType() {
        console.log(tabBar.currentIndex)
        if (HomeProperty.warning) {
            return "warning";
        }
        return "aircon";
//        switch (tabBar.currentIndex)
//        {
//        case 0:
//            return "home";
//        case 1:
//            return "led";
//        case 2:
//            return "aircon";
//        case 3:
//            return "chart";
//        case 4:
//            return "secure";
//        default:
//            return "";
//        }
    }
}
