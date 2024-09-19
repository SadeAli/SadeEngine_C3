/*
module glfw;

distinct Window = void*;
distinct Monitor = void*;

const int CONTEXT_VERSION_MAJOR = 0x00022002;
const int CONTEXT_VERSION_MINOR = 0x00022003;
const int RESIZABLE             = 0x00020003;
const int OPENGL_PROFILE        = 0x00022008;
const int OPENGL_CORE_PROFILE   = 0x00032001;

extern fn void init() @extern("glfwInit");
extern fn void terminate() @extern("glfwTerminate");
extern fn Window createWindow(int width, int height, char *title, Monitor, Window) @extern("glfwCreateWindow");
extern fn Window destroyWindow(Window window) @extern("glfwDestroyWindow");
extern fn bool windowShouldClose(Window window) @extern("glfwWindowShouldClose");
extern fn void pollEvents(Window window) @extern("glfwPollEvents");
extern fn void swapBuffers(Window window) @extern("glfwSwapBuffers");
extern fn void makeContextCurrent(Window window) @extern("glfwMakeContextCurrent");
extern fn void getProcAddress(char*) @extern("glfwGetProcAddress");
extern fn void windowHint(uint, uint) @extern("glfwWindowHint");
*/
module sade::window;
import glfw;
import libc;
import opengl::gl;
import sade::window::callback @public;
import std;

struct Window {
    glfw::window::Window handle;
    float lastBufferSwap;
    float frameTime;
}

def Color = char[<4>];

fn void clearColor(char[4] color) {
	gl::clearColor(color[0]/255f, color[1]/255f, color[2]/255f, color[3]/255f);
}

fn void initialize() @init(1023) {
	glfw::init();
}
fn void terminate() @finalizer {
	// glfw::terminate();
}
fn Window init() {
    // set window hints
    foreach (hint : HintValuePair[]{
	    {hint::CONTEXT_VERSION_MAJOR, 4},
	    {hint::CONTEXT_VERSION_MINOR, 5},
	    {hint::RESIZABLE, 0},
	    {hint::OPENGL_PROFILE, hint::OPENGL_CORE_PROFILE}})
    {
        glfw::windowHint(hint.hint, hint.value);
    }

    glfw::window::Window window = glfw::window::create(1920, 1080, "c3 window");
    window.makeContextCurrent();
    swapInterval(1);

    window.setKeyCallback(&callback::keyCallback);

    gl::viewport(0,0,1920,1080);

    return Window{
       .handle = window
    };
}

fn float Window.getFrameTime(&self) {
    return self.frameTime;
}

fn void swapInterval(int interval) {
    glfw::opengl::swapInterval(interval);
}

struct HintValuePair @private {
    Hint hint;
    int value;
}

macro bool Window.shouldClose(self) {
    return (bool)self.handle.shouldClose();
}

macro Window.destroy(self) {
    self.handle.destroy();
}

macro Window.swapBuffers(&self) {
    float currentTime = (float)glfw::getTime();
    self.frameTime = currentTime - self.lastBufferSwap;
    self.lastBufferSwap = currentTime;
    self.handle.swapBuffers();
}
