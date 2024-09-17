module sade::shapes;
import sade;
import std;

macro Vec2f[*] RectAA.vertices(&self) {
    return {
        {self.left, self.top},
        {self.left, self.bottom},
        {self.right, self.top},
        {self.right, self.bottom},
    };
}

macro uint[*] RectAA.indices(&self) {
    return {
        0, 1, 2,
        1, 2, 3
    };
}
