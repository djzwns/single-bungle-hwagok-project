import QtQuick 2.0

Item {
    id: pickerRoot
    width: 350
    height: width

    signal colorChanged(var newColor)

    property int circleWidth: 40
    property color currentColor: ""

    Rectangle {
        id: control
        anchors.fill: pickerRoot
        anchors.margins: 10
        color: "transparent"
        border.width: 1
        border.color: "black"

        // pi * 2 / 5
        readonly property real degree_1: Math.PI * 0.4  // 0~71
        readonly property real degree_2: Math.PI * 0.8  // 72~143
        readonly property real degree_3: Math.PI * 1.2  // 144~215
        readonly property real degree_4: Math.PI * 1.6  // 216~287, 288~359
        readonly property real deg2rad: Math.PI / 180

        readonly property real circleRadius: circleWidth * 0.5

        function getAngleColor(angle) {
            let color, d;

            // hsv to rgb
            if (angle < degree_1) {
                d = 255 / degree_1 * angle;
                color = "255," + Math.round(d) + ",0";

            } else if (angle < degree_2) {
                d = 255 / degree_1 * (angle - degree_1);
                color = (255 - Math.round(d) + ",255,0");

            } else if (angle < degree_3) {
                d = 255 / degree_1 * (angle - degree_2);
                color = "0,255" + Math.round(d);

            } else if (angle < degree_4) {
                d = 255 / degree_1 * (angle - degree_3);
                color = "0," + (255 - Math.round(d)) + ",255";

            } else {
                d = 255 / degree_1 * (angle - degree_4);
                color = Math.round(d) + ",0" + (255 - Math.round(d));
            }
            return color;
        }

        function getRotateAngle(mouseX, mouseY) {
            let yPosOffset = mouseY - control.width * 0.5;
            let xPosOffset = mouseX - control.height * 0.5;
            let radian = 0, angle = 0;

            if (xPosOffset !== 0 && yPosOffset !== 0)
                radian = Math.atan(Math.abs(yPosOffset / xPosOffset));

            // 2d 스크린이라 y 축 방향 주의
            if (xPosOffset === 0 && yPosOffset === 0)   // 0
                return 0;
            else if (xPosOffset < 0 && yPosOffset < 0)  // 2사분면
                return radian * 180 / Math.PI;
            else if (xPosOffset === 0 && yPosOffset < 0)// 90
                return 90;
            else if (xPosOffset > 0 && yPosOffset < 0)  // 1사분면
                return 180 - radian * 180 / Math.PI;
            else if (xPosOffset > 0 && yPosOffset === 0)// 180
                return 180;
            else if (xPosOffset > 0 && yPosOffset > 0)  // 4사분면
                return 180 + radian * 180 / Math.PI;
            else if (xPosOffset === 0 && yPosOffset > 0)// 270
                return 270;
            else if (xPosOffset < 0 && yPosOffset > 0)  // 3사분면
                return 360 - radian * 180 / Math.PI;
            else
                return angle;
        }

        function updateCanvasByMousePos(x, y) {
            let currentAngle = control.getRotateAngle(x, y);
            console.log(x, y, currentAngle);
            updateCanvasByAngle(currentAngle);
        }

        function updateCanvasByAngle(angle) {
            let newX = control.width * 0.5 + -Math.cos(angle * deg2rad) * (control.width * 0.5 - pickerRoot.circleRadius - 2 * control.anchors.margins);
            let newY = control.height * 0.5 - Math.sin(angle * deg2rad) * (control.height * 0.5 - pickerRoot.circleRadius - 2 * control.anchors.margins);

            console.log("new: ", newX, newY, "\ncurrent color is: " + pickerRoot.currentColor);
            handle.xDrawPos = newX;
            handle.yDrawPos = newY;
            handle.requestPaint();

            pickerRoot.currentColor = getAngleColor(((angle + 180) % 360) / 180 * Math.PI);
            pickerRoot.colorChanged(pickerRoot.currentColor);
        }

        Canvas {
            id: handle
            width: parent.width;
            height: width

            property int xDrawPos: 0
            property int yDrawPos: 0

            onPaint: {
                let ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.beginPath();
                ctx.arc(xDrawPos, yDrawPos, pickerRoot.circleRadius + 10, 0, 2 * Math.PI);
            }
        }
    }
}
