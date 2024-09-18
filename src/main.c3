module c3_craft;
import std::math;
import sade;
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

fn int main() {
    Window window = window::init();
    defer window.destroy();
    window::swapInterval(1);

    float[<4>] fgColor = {0.6, 0.8, 0.9, 1};

    Shader fs = shader::compileFromSource(VS_2D, gl::GL_VERTEX_SHADER);
    Shader vs = shader::compileFromSource(FS_FLAT, gl::GL_FRAGMENT_SHADER);
    ShaderProgram shader = shader::linkShaders({fs, vs});
    defer fs.delete();
    defer vs.delete();
    defer shader.delete();

    Vec2f position;
    Vec2f size = {200, 200};

    RectAA windowRectAA = window.getRectAA();
    PhysicsServer2D ps = server::init(border: windowRectAA);
    defer ps.free();

    for (int i = 0; i < 60; i++) {
        position = {(float)(rand(1500) - 750), (float)(rand(900) - 450)};
        ps.addCircle(position, 20);
    }

    window::clearColor({56, 85, 103, 255});
    while (!window.shouldClose()) {

        float movementSpeed = 10;
        Vec2f inputDirection = {
            window.getAxis(key::RIGHT, key::RIGHT),
            window.getAxis(key::UP, key::DOWN),
        };

        ps.applyGravity({0, -1000}, window.frameTime);
        ps.step(window.frameTime);

        gl::clear(gl::GL_COLOR_BUFFER_BIT);

        gl::useProgram(shader);
        ps.draw(fgColor);

        window.swapBuffers();
        input::pollEvents();
    }

    return 0;
}
