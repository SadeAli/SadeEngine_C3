module c3_craft;
import std;
import sade;
import libc;
import opengl;
import shader;
import glfw::keyboard::key;

const char[] VS_2D = (`
    #version 330 core

    layout (location=0) in vec2 aPos;
    layout (location=1) in vec4 color;

    out vec4 vertColor;

    uniform ivec2 windowSize = ivec2(1920, 1080);

    void main() {
        vertColor = color;
        gl_Position = vec4(2 * aPos.x / windowSize.x, 2 * aPos.y / windowSize.y, 0, 1.0);
    }
`);

const char[] FS_FLAT = (`
    #version 330 core
    out vec4 FragColor;

    in vec4 vertColor;

    void main(){
        FragColor = vertColor;
    }
`);


def RectAAList = List(<RectAA>);
fn int main() {
    Window window = window::init();
    defer window.destroy();

    float[<4>] fgColor = {0.6, 0.8, 0.9, 1};

    Shader fs = shader::compileFromSource(VS_2D, gl::GL_VERTEX_SHADER);
    Shader vs = shader::compileFromSource(FS_FLAT, gl::GL_FRAGMENT_SHADER);
    ShaderProgram shader = shader::linkShaders({fs, vs});
    defer shader.delete();

    Vec2f position;
    Vec2f size = {20, 20};
    RectAAList rects;
    rects.new_init();
    defer rects.free();

    window::clearColor({56, 85, 103, 255});
    while (!window.shouldClose()) {

        float movementSpeed = 10;
        Vec2f inputDirection = {
            window.getAxis(key::RIGHT, key::LEFT),
            window.getAxis(key::UP, key::DOWN)
        };

        position += movementSpeed * inputDirection;
        rects.push(rect_aa::from_position(position, size));

        gl::clear(gl::GL_COLOR_BUFFER_BIT);

        gl::useProgram(shader);
        batched::@draw(fgColor; RenderBatch2D *batch) {
            foreach(rect:rects) {
                batch.drawRectAA(rect);
            }
        };

        window.swapBuffers();
        input::pollEvents();
    }

    return 0;
}
