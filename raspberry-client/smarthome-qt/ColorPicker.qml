import QtQuick 2.0
import QtGraphicalEffects 1.0
import "colorhelper.js" as ColorHelper

Item {
    id: pickerRoot
    width: 320
    height: 500

    signal colorChanged(var newColor)

    property int circleWidth: 90
    property int handleWidth: 14
    property var currentColor: undefined

    Rectangle {
        id: control
        y: 40
        width: parent.width
        height: parent.height
        radius: width * 0.02
        color: "white"

        // pi * 2 / 5
        readonly property real degree_1: Math.PI * 0.4  // 0~71
        readonly property real degree_2: Math.PI * 0.8  // 72~143
        readonly property real degree_3: Math.PI * 1.2  // 144~215
        readonly property real degree_4: Math.PI * 1.6  // 216~287, 288~359
        readonly property real deg2rad: Math.PI / 180

        property real saturate: 0

        function getAngleColor(h, s, v) {
            let c = ColorHelper.hsvToRGB(h, s, v);
            let r = parseInt(c.r).toString();
            let g = parseInt(c.g).toString();
            let b = parseInt(c.b).toString();

            return r + "," + g + "," + b;
        }

        function getRotateAngle(mouseX, mouseY) {
            let yPosOffset = mouseY - canvas.width * 0.5;
            let xPosOffset = mouseX - canvas.height * 0.5;
            let radian = 0, angle = 0;

            if (xPosOffset !== 0 && yPosOffset !== 0)
                radian = Math.atan(Math.abs(yPosOffset / xPosOffset));

            // 2d 스크린이라 y 축 방향 주의
            if (xPosOffset === 0 && yPosOffset === 0)   // 0
                angle = 0;
            else if (xPosOffset < 0 && yPosOffset < 0)  // 2사분면
                angle = radian * 180 / Math.PI;
            else if (xPosOffset === 0 && yPosOffset < 0)// 90
                angle = 90;
            else if (xPosOffset > 0 && yPosOffset < 0)  // 1사분면
                angle = 180 - radian * 180 / Math.PI;
            else if (xPosOffset > 0 && yPosOffset === 0)// 180
                angle = 180;
            else if (xPosOffset > 0 && yPosOffset > 0)  // 4사분면
                angle = 180 + radian * 180 / Math.PI;
            else if (xPosOffset === 0 && yPosOffset > 0)// 270
                angle = 270;
            else if (xPosOffset < 0 && yPosOffset > 0)  // 3사분면
                angle = 360 - radian * 180 / Math.PI;

            return angle;
        }

        function updateCanvasByMousePos(x, y) {
            let currentAngle = control.getRotateAngle(x, y);
            //console.log(x, y, currentAngle);
            updateCanvasByAngle(currentAngle);

            handle.x = x - handle.width + canvas.width * 0.25
            handle.y = y - handle.radius + (canvas.height + canvas.y * 2) * 0.25
        }

        function updateCanvasByAngle(angle) {

            pickerRoot.currentColor = 'rgb('+getAngleColor(angle, control.saturate, 1)+')';
            pickerRoot.colorChanged(pickerRoot.currentColor);
//            console.log("currentColor: ", pickerRoot.currentColor);
        }

        Rectangle {
            id: centerPoint
            anchors.centerIn: canvas
            width: parent.width * 0.2
            height: width
            radius: width * 0.5
            color: ColorHelper.rgbToHexColor(pickerRoot.currentColor)//control.color
            z: 5

            layer {
                enabled: true
                effect: DropShadow {
                    radius: 16
                    samples: 24
                    source: centerPoint
                    color: Qt.rgba(0.2, 0.2, 0.2, 0.5)
                    transparentBorder: true
                }
            }
        }
        Rectangle {
            id: handle
            width: pickerRoot.handleWidth
            height: width
            radius: width * 0.5
            color: "transparent"
            border.color: "white"
            border.width: 2
            x: 0
            y: 0
            z: 4

            layer {
                enabled: true
                effect: DropShadow {
                    radius: 8
                    samples: 16
                    source: handle
                    color: Style.shadowColor
                    transparentBorder: true
                }
            }
        }

//        Canvas {
//            id: handle
//            width: parent.width * 0.6;
//            height: width
//            anchors.centerIn: canvas

//            property int xDrawPos: 0
//            property int yDrawPos: 0

//            onPaint: {
//                let ctx = getContext("2d");
//                ctx.clearRect(0, 0, width, height);
//                ctx.beginPath();
//                // x, y 를 중심점으로 시계 방향 0~360도 호 그리기
//                ctx.arc(xDrawPos, yDrawPos, 15, 0, 2 * Math.PI);
//                ctx.fillStyle = "ligheBlue";
//                ctx.fill();
//                ctx.strokeStyle = "transparent";
//                ctx.stroke();
//                ctx.closePath();

//                ctx.beginPath();
//                ctx.arc(xDrawPos, yDrawPos, 13, 0, 2 * Math.PI);
//                ctx.fillStyle = pickerRoot.currentColor;
//                ctx.fill();
//                ctx.strokeStyle = "transparent";
//                ctx.stroke();
//                ctx.closePath();
//            }
//            z: 1000
//        }

        Canvas {
            id: canvas
            width: parent.width * 0.7
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            y: 30

            onPaint: {
                let ctx = getContext("2d");
                let iSectors = 360;
                let iSectorAngle = (360/iSectors)/180 * Math.PI;
                ctx.translate(width * 0.5, height * 0.5);
                for (let i = 0; i < iSectors; ++i) {
                    let startAngle = 180 * Math.PI / 180;
                    let endAngle = startAngle + iSectorAngle;
                    let radius = width * 0.5 - 1;
                    let color = control.getAngleColor(i, 1, 1);
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.arc(0, 0, radius, startAngle, endAngle);
                    ctx.closePath();
                    let gradient = ctx.createLinearGradient(0, 0, radius, 0)
                    gradient.addColorStop(0.0, "white");
                    gradient.addColorStop(1.0, 'rgb(' + color + ')');
                    ctx.strokeStyle = gradient;//'rgb(' + color + ')';
                    ctx.stroke();
                    ctx.fillStyle = gradient;//'rgb(' + color + ')';
                    ctx.fill();
                    ctx.rotate(iSectorAngle);
                }
                ctx.restore();

                ctx.save();
                ctx.translate(0, 0);
                ctx.beginPath();
                ctx.arc(0, 0, width * 0.5 - pickerRoot.circleWidth, 0, 2 * Math.PI);
                ctx.fillStyle = "white";
                ctx.fill();
                ctx.strokeStyle = "transparent";
                ctx.stroke();
                ctx.restore();
            }

            MouseArea {
                id: colorPickerMouseArea
                anchors.fill: parent;
                onMouseXChanged: {
                    let radius = canvas.width * 0.5
                    let x = mouseX - radius;
                    let y = mouseY - radius;
                    control.saturate = Math.max(0, Math.min(1, Math.sqrt(x * x + y * y) / radius));
                    control.updateCanvasByMousePos(mouseX, mouseY);
                    swipeView.interactive = mouseX < -5 || mouseX > width + 5;
                }
            }

            Component.onCompleted: {
                control.updateCanvasByAngle(0);
            }
        }

//        Rectangle {
//            id: brightness

//            anchors {
//                top: canvas.bottom
//                left: control.left
//                right: control.right
//                leftMargin: 12
//                rightMargin: 12
//                topMargin: 25
//            }
//            radius: width * 0.05
//            clip: true

//            height: 20

//            LinearGradient {
//                anchors.fill: parent
//                start: Qt.point(0, 0)
//                end: Qt.point(width, 0)
//                GradientStop { position: 0.0; color: "black" }
//                GradientStop { position: 1.0; color: ColorHelper.rgbToHexColor(pickerRoot.currentColor) }
//            }
//        }
    }


    layer {
        enabled: true
        effect: DropShadow {
            radius: 8
            samples: radius * 2
            source: control
            color: Qt.rgba(0.2, 0.2, 0.2, 0.5)
            transparentBorder: true
        }
    }
}
