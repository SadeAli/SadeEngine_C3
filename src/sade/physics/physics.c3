module sade::physics;
import sade::window;
import std::math::vector;

fn bool isRectInsideAA(BorderAA b, Vec2f pos, Vec2f size) {
    return pos.isInsideBorderAA(b) && (pos + size).isInsideBorderAA(b);
}

fn bool Vec2f.isInsideWindow(pos, Window window) {
    Vec2f halfBorder = (Vec2f)window.getSize() / 2;

    if (pos.x > -halfBorder.x && pos.x < halfBorder.x &&
        pos.y > -halfBorder.y && pos.y < halfBorder.y) {
        return true;
    }

    return false;
}

struct BorderAA {
    float top, bottom, left, right;
}

struct Circle {
    Vec2f position;
    float radius;
}

fn bool Vec2f.isInsideBorderAA(point, BorderAA b) {
    if (point.x > b.left && point.x < b.right &&
        point.y > b.bottom && point.y < b.top) {
        return true;
    }

    return false;

}
