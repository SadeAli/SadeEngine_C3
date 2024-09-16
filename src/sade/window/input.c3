module sade::window::input;
import glfw::keyboard;
import glfw::input;

const uint MAX_KEYS = 512;
Action[MAX_KEYS] keyState @private;
Action[MAX_KEYS] keyStatePrev @private;

fn float Window.getAxis(window, Key positive, Key negative) {
    return (float)window.isKeyDown(positive) - (float)window.isKeyDown(negative);
}

fn bool Window.isKeyPressed(self, Key key) {
    int index = (int)key;
    return (keyState[index] != keyStatePrev[index]) && (keyState[index] == Action.PRESS);
}

fn bool Window.isKeyRepeat(self, Key key) {
    if (keyState[(int)key] == Action.REPEAT) {
        return true;
    }

    return false;
}

fn bool Window.isKeyDown(window, Key key) {
    return (keyState[(int)key] == Action.PRESS);
}

fn void pollEvents() {
    keyStatePrev = keyState; 
    glfw::pollEvents();
}
