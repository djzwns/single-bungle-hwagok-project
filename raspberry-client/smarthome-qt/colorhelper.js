function colorToInt(colorStr) {
    let a1 = parseInt(Number("0x" + colorStr[1] + colorStr[2]), 10);
    let r1 = parseInt(Number("0x" + colorStr[3] + colorStr[4]), 10);
    let g1 = parseInt(Number("0x" + colorStr[5] + colorStr[6]), 10);
    let b1 = parseInt(Number("0x" + colorStr[7] + colorStr[8]), 10);

    return { a: a1, r: r1, g: g1, b: b1, };
}

function rgbToHexColor(colorStr) {
    let colorsplit = colorStr.split(/[^0-9]/g);
    let r = hexPadStart(Number(colorsplit[4]), 2, '0');
    let g = hexPadStart(Number(colorsplit[5]), 2, '0');
    let b = hexPadStart(Number(colorsplit[6]), 2, '0');
    let color = "#ff" + r + g + b;
    return color;
}

function rgbToNumber(colorStr) {
    let colorsplit = colorStr.split(/[^0-9]/g);
    return colorsplit[4] + "," + colorsplit[5] + "," + colorsplit[6];
}

function hexPadStart(num, pad, sep) {
    let str = num.toString(16);
    let padLen = pad - str.length;
    if (padLen <= 0)
        return str;

    let padStr = "";
//    for (let i = 0; i < padLen; ++i)
    let i = 0;
    while (i < padLen) {
        padStr = padStr + sep;
        i += 1;
    }

    return (padStr + str);
}

function intToColor(r, g, b, a) {
    let color = "#";
//    color += a.toString(16).padStart(2, '0')
//            + r.toString(16).padStart(2, '0')
//            + g.toString(16).padStart(2, '0')
//            + b.toString(16).padStart(2, '0');
    color += hexPadStart(a, 2, '0')
            + hexPadStart(r, 2, '0')
            + hexPadStart(g, 2, '0')
            + hexPadStart(b, 2, '0');
    return color;
}

function lerp(a, b, t) {
    //return parseInt(a * (1 - t) + b * t);
    return parseInt((b - a) * t + a);
}

function colorStringHSVLerp(color1, color2, t) {
    let c1 = colorToInt(color1);
    let c2 = colorToInt(color2);

    t = Math.max(0, Math.min(1, t));
    let a = lerp(c1.a, c2.a, t);
    let r = lerp(c1.r, c2.r, t);
    let g = lerp(c1.g, c2.g, t);
    let b = lerp(c1.b, c2.b, t);

    let color = intToColor(r, g, b, a);

//    let c1 = colorToInt(color1);
//    let c2 = colorToInt(color2);

//    t = Math.max(0, Math.min(1, t));
//    let a = lerp(c1.a, c2.a, t);

//    let hsv1 = rgbToHSV(c1.r, c1.g, c1.b);
//    let hsv2 = rgbToHSV(c2.r, c2.g, c2.b);
//    let hsv3 = {h: lerp(hsv1.h, hsv2.h, t), s: lerp(hsv1.s, hsv2.s, t), v: lerp(hsv1.v, hsv2.v, t), };

//    let hsv2rgb = hsvToRGB(hsv3.h, hsv3.s, hsv3.v);

//    let color = intToColor(hsv2rgb.r, hsv2rgb.g, hsv2rgb.b, a);
    return color
}

function tempColorLerp(t) {
    let h = 240;
    let s = 1;
    let v = 1;

    t = Math.max(0, Math.min(1, t));
    let h_lerp = lerp(0, h, t);
    let rgb = hsvToRGB(h - h_lerp, s, v);

    let color = intToColor(parseInt(rgb.r), parseInt(rgb.g), parseInt(rgb.b), 255);

    return color
}

function rgbToHSV(r, g, b) {
    let r_p = r / 255;
    let g_p = g / 255;
    let b_p = b / 255;
    let max_color = Math.max(r, Math.max(g, b));
    let min_color = Math.min(r, Math.min(g, b));
    let h = 0;
    let s = 0;
    let v = 0;
    let l = (max_color + min_color) * 0.5;

    if (max_color !== min_color) {
        s = l < 0.5 ? (max_color - min_color) / (max_color + min_color)
                    : (max_color - min_color) / (2 - max_color - min_color);

        if (max_color === r_p)
            h = (g_p - b_p) / (max_color - min_color);
        if (max_color === g_p)
            h = 2 + (b_p - r_p) / (max_color - min_color);
        if (max_color === b_p)
            h = 4 + (r_p - g_p) / (max_color - min_color);
    }

    h *= 60;
    if (h < 0) h += 360;

    return { h: h, s: s * 100, v: l * 100, };
}

function hsvToRGB(h, s, v) {
    let r = 0;
    let g = 0;
    let b = 0;
    let c = v * s;
    let x = c * (1 - Math.abs(((h / 60) % 2) - 1));
    let m = v - c;
    if (0 <= h && h < 60) {
        r = c;
        g = x;
        b = 0;
    } else if (60 <= h && h < 120) {
        r = x;
        g = c;
        b = 0;
    } else if (120 <= h && h < 180) {
        r = 0;
        g = c;
        b = x;
    } else if (180 <= h && h < 240) {
        r = 0;
        g = x;
        b = c;
    } else if (240 <= h && h < 300) {
        r = x;
        g = 0;
        b = c;
    } else if (300 <= h && h < 360) {
        r = c;
        g = 0;
        b = x;
    }

    return { r: (r + m) * 255, g: (g + m) * 255, b: (b + m) * 255, };

//    let l = _v / 100.0;
//    let s = _s / 100.0;
//    let h = _h / 360.0;

//    if (s === 0) {
//        r = g = b = _v;
//    }
//    else {
//        let temp1 = l < 0.5 ? l * (1 + s) : l + s - (l * s);
//        let temp2 = 2 * l - temp1;
//        let temp3 = 0;
//        for (let i = 0; i < 3; ++i) {
//            if (i === 0) { // red
//                temp3 = h + 0.33333;
//                if (temp3 > 1)
//                    temp3 -= 1;
//                r = hslToRGB_Sub(temp1, temp2, temp3);
//            } else if (i === 1) { // green
//                temp3 = h;
//                g = hslToRGB_Sub(temp1, temp2, temp3);
//            } else { // blue
//                temp3 = h - 0.33333;
//                if (temp3 < 0)
//                    temp3 += 1;
//                b = hslToRGB_Sub(temp1, temp2, temp3);
//            }
//        }

//        console.log(r, g, b);
//    }
//    return { r: (r / 100) * 255, g: (g / 100) * 255, b: (b / 100) * 255, };
}

//function hslToRGB_Sub(t1, t2, t3) {
//    let c = 0;
//    if ((t3 * 6) < 1) {
//        c = (t2 + (t1 - t2) * 6 * t3) * 100;
//    }
//    else {
//        if ((t3 * 2) < 1) {
//            c = t1 * 100;
//        }
//        else {
//            c = (t3 * 3) < 2 ? (t2 + (t1 - t2) * (0.66666 - t3) * 6) * 100
//                             : t2 * 100;
//        }
//    }

//    return c;
//}
