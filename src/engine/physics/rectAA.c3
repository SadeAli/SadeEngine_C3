module sade::physics;
import std;
import sade;

struct RectAA {
    float top, bottom;
    float left, right;
}

fn void RectAA.draw(self, float[4] color) {
    Vec2f[] vertices = {
        {self.left, self.top},
        {self.left, self.bottom},
        {self.right, self.top},
        {self.right, self.bottom},
    };

    var $indices = {
        0, 1, 2,
        1, 2, 3
    };

    naive::drawColored(vertices, $indices, color);
}

fn bool RectAA.isOutsideRectAA(&self, RectAA rect) {
    return (
        (self.top < rect.bottom) ||
        (self.bottom > rect.top) ||
        (self.right < rect.left) ||
        (self.left > rect.right)
    );
}

fn bool RectAA.isInsideRectAA(&self, RectAA rect) {
    return (
        (self.bottom > rect.bottom) &&
        (self.top < rect.top) &&
        (self.left > rect.left) &&
        (self.right < rect.right)
    );
}
