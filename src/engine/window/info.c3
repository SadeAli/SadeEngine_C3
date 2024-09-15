module sade::window;
import glfw::window;
import std::math;

def Vec2i = int[<2>];

fn Vec2i Window.getSize(self) {
    Vec2i size @noinit;
    self.handle.getSize(&size.x, &size.y);
    return size;
}

fn Vec2 Window.getCursorPos(self) {
    Vec2 pos;
    self.handle.getCursorPosition(&pos.x, &pos.y);
    return pos;
}
