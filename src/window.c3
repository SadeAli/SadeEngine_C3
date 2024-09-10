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

module window;
import glfw;
import opengl::gl;

def Color = float[<4>];

fn void clearColor(float [4] color) {
	gl::clearColor(color[0], color[1], color[2], color[3]);
}

fn Window init() {
	glfw::init();

	// set window hints
	foreach (hint : int[2][4]{
		{glfw::CONTEXT_VERSION_MAJOR, 4},
		{glfw::CONTEXT_VERSION_MINOR, 6},
		{glfw::RESIZABLE, 0},
		{glfw::OPENGL_PROFILE, glfw::OPENGL_CORE_PROFILE}})
	{
		glfw::windowHint(hint[0], hint[1]);
	}

	glfw::Window window = glfw::createWindow(1920, 1080, "c3 window", null, null);
	glfw::makeContextCurrent(window);

	gl::viewport(0,0,1920,1080);

	gl::enable(gl::GL_DEPTH_TEST);

	return window;
}

fn void destroy(Window window) {
	glfw::destroyWindow(window);
	glfw::terminate();
}
