module c3_craft;
import std;
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

import sade::physics::server;
fn int main() {
    Window window = window::init();
    defer window.destroy();
    window::swapInterval(1);

    float[<4>] fgColor = {0.6, 0.8, 0.9, 1};

    Shader fs = shader::compileFromSource(VS_2D, gl::GL_VERTEX_SHADER);
    Shader vs = shader::compileFromSource(FS_FLAT, gl::GL_FRAGMENT_SHADER);
    ShaderProgram shader = shader::linkShaders({fs, vs});
    defer shader.delete();

    Vec2f position;
    Vec2f size = {200, 200};

    PhysicsServer2D ps = server::init();
    defer ps.free();

    ps.addCircle(position, 20);
    ps.addCircle(position + {50, 00}, 20);
    ps.addCircle(position - {50, 00}, 20);

    window::clearColor({56, 85, 103, 255});
    while (!window.shouldClose()) {
        gl::clear(gl::GL_COLOR_BUFFER_BIT);

        float movementSpeed = 10;
        Vec2f inputDirection = {
            (float)window.isKeyDown(key::RIGHT) - (float)window.isKeyDown(key::LEFT),
            (float)window.isKeyDown(key::UP) - (float)window.isKeyDown(key::DOWN),
        };

        if (position.isInsideWindow(window)) {
            position += inputDirection * movementSpeed;
        }
        if (!position.isInsideWindow(window)) {
            position -= inputDirection * movementSpeed;
        }

        ps.applyGravity({0, 10}, window.frameTime);
        io::printn(ps.objects[0].rectAA.top);

        gl::useProgram(shader);
        ps.draw(fgColor);

        window.swapBuffers();
        input::pollEvents();
    }

    return 0;
}
