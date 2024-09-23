module sade::window::glfw::callback;
import libc;
import sade::window::input @public;
import glfw::window;
import glfw::input;
import glfw::keyboard;

fn void keyCallback(glfw::window::Window window, glfw::keyboard::Key key, Scancode scancode, Action action, Modifiers modifiers) @private {
    if (key < 0 || key >= input::MAX_KEYS) {
        libc::fprintf(libc::stderr(), "Invalid key: %d\n", key);
        return;  // Invalid key
    }

    if (action == Action.PRESS || action == Action.RELEASE) {
        input::keyState[(int)key] = action;
    }
}
