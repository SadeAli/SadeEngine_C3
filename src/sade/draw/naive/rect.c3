module sade::draw::naive;

import sade;
import std::math;

macro void drawRectAA(Vec2f a, Vec2f b, float[4] color) {
    Vec2f[] vertices = {
        a,
        {a.x, b.y},
        {b.x, a.y},
        b,
    };

    var $indices = {
        0, 1, 2,
        1, 2, 3
    };

    drawColored(vertices, $indices, color);
}


