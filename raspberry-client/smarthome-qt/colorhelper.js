function colorToInt(colorStr) {
    let a1 = parseInt(Number("0x" + colorStr[1] + colorStr[2]), 10);
    let r1 = parseInt(Number("0x" + colorStr[3] + colorStr[4]), 10);
    let g1 = parseInt(Number("0x" + colorStr[5] + colorStr[6]), 10);
    let b1 = parseInt(Number("0x" + colorStr[7] + colorStr[8]), 10);

    return { a: a1, r: r1, g: g1, b: b1, };
}

function intToColor(r, g, b, a) {
    let color = "#"
    color += a.toString(16).padStart(2, '0')
            + r.toString(16).padStart(2, '0')
            + g.toString(16).padStart(2, '0')
            + b.toString(16).padStart(2, '0');
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

function hsvToRGB(_h, _s, _v) {
    let r = 0;
    let g = 0;
    let b = 0;
    let l = _v / 100;
    let s = _s / 100;
    let h = _h / 360;

    if (s === 0) {
        r = g = b = _v;
    }
    else {
        let temp1 = l < 0.5 ? l * (1 + s) : l + s - (l * s);
        let temp2 = 2 * l - temp1;
        let temp3 = 0;
        for (let i = 0; i < 3; ++i) {
            if (i === 0) { // red
                temp3 = h + 0.33333;
                if (temp3 > 1)
                    temp3 -= 1;
                r = hslToRGB_Sub(r, temp1, temp2, temp3);
            } else if (i === 1) { // green
                temp3 = h;
                g = hslToRGB_Sub(g, temp1, temp2, temp3);
            } else { // blue
                temp3 = h - 0.33333;
                if (temp3 < 0)
                    temp3 += 1;
                b = hslToRGB_Sub(b, temp1, temp2, temp3);
            }
        }
    }

    return { r: (r / 100) * 255, g: (g / 100) * 255, b: (b / 100) * 255, };
}

function hslToRGB_Sub(c, t1, t2, t3) {
    if ((t3 * 6) < 1) {
        c = (t2 + (t1 - t2) * 6 * t3) * 100;
    }
    else {
        if ((t3 * 2) < 1) {
            c = t1 * 100;
        }
        else {
            c = (t3 * 3) < 2 ? (t2 + (t1 - t2) * (0.66666 - t3) * 6) * 100
                             : t2 * 100;
        }
    }

    return c;
}
