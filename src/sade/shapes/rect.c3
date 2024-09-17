module sade::shapes;
import std::math;

macro Vec2f[*] rectVertices(Vec2f pos, Vec2f size) {
    return Vec2f[*]{
        {pos.x + size.x, pos.y + size.y},
        {pos.x + size.x, pos.y - size.y},
        {pos.x - size.x, pos.y + size.y},
        {pos.x - size.x, pos.y - size.y},
    };
}

macro uint[*] rectIndices() {
    return {
        0, 1, 2,
        1, 2, 3
    };
}

const uint[6] RECT_INDICES = {
                                0, 1, 2,
                                1, 2, 3
                            };
