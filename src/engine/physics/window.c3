module sade::physics::window;
import sade;

fn RectAA Window.getRectAA(&window) {
    Vec2i size = window.getSize() / 2;
    return RectAA{
        .top = (float)size.y,
        .bottom = (float)-size.y,
        .right = (float)size.x,
        .left = (float)-size.x
    };
}
