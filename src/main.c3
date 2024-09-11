module c3_craft;
import window;
import glfw;
import shader;
import std::io;
import std::math;
import std::math::vector;
import std::math::matrix;
import opengl::gl;

const char[] VS_PROJECTION = (
	"#version 330 core\n"
	"layout (location = 0) in vec3 aPos;"

	"uniform mat4 uModel = mat4(1);"
	"uniform mat4 uView = mat4(1);"
	"uniform mat4 uProjection = mat4(1);"

	"void main(){"
	"    gl_Position = uProjection * uView * uModel * vec4(aPos, 1.0);"
	"}"
);

const char[] FS_BASIC = (
	"#version 330 core\n"
	"out vec4 FragColor;"

	"void main(){"
	"    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);"
	"}"
);

const Vec3f[] CUBE_VERTICES = {
	{-0.5f,  0.5f,  0.5f},
	{ 0.5f,  0.5f,  0.5f},
	{-0.5f, -0.5f,  0.5f},
	{ 0.5f, -0.5f,  0.5f},
	{-0.5f,  0.5f, -0.5f},
	{ 0.5f,  0.5f, -0.5f},
	{-0.5f, -0.5f, -0.5f},
	{ 0.5f, -0.5f, -0.5f},
};

const uint[] CUBE_INDICES = {
	4, 5, 1,
	4, 1, 0,
	0, 1, 3,
	0, 3, 2,
	2, 3, 7,
	2, 7, 6,
	6, 7, 5,
	6, 5, 4,
	4, 0, 2,
	4, 2, 6,
	1, 5, 7,
	1, 7, 3,
};

fn uint genVao(Vec3f[] vertices, uint[] indices) {
	uint vao, vbo, ebo;
	gl::genVertexArrays(1, &vao);
	gl::genBuffers(1, &vbo);
	gl::genBuffers(1, &ebo);
	// defer {
	// 	gl::deleteBuffers(1, &vbo);
	// 	gl::deleteBuffers(1, &ebo);
	// }

	gl::bindVertexArray(vao);
	gl::bindBuffer(gl::GL_ARRAY_BUFFER, vbo);
	gl::bindBuffer(gl::GL_ELEMENT_ARRAY_BUFFER, ebo);

	gl::bufferData(gl::GL_ARRAY_BUFFER, Vec3f.sizeof*vertices.len, vertices.ptr, gl::GL_STATIC_DRAW);
	gl::bufferData(gl::GL_ELEMENT_ARRAY_BUFFER, uint.sizeof*indices.len, indices.ptr, gl::GL_STATIC_DRAW);

	gl::vertexAttribPointer(0, 3, gl::GL_FLOAT, false, Vec3f.sizeof, (void*)0);
	gl::enableVertexAttribArray(0);  

	gl::bindVertexArray(0);

	gl::deleteBuffers(1, &vbo);
	gl::deleteBuffers(1, &ebo);

	return vao;
}

fn void setUpShaderProjection(ShaderProgram s) {
	gl::useProgram(s);
	Matrix4f projection = matrix::perspective(<float>)(90, 16.0/10.0, 0.1, 1000);
	Matrix4f view = matrix::look_at(<float>)({1, 1, -1},{0,0,0},{0,1,0});
	Matrix4f model = matrix::IDENTITY4(<float>);
	
	// move data to shader
	int uProjection = gl::getUniformLocation(s, "uProjection");
	int uView = gl::getUniformLocation(s, "uView");
	int uModel = gl::getUniformLocation(s, "uModel");

	gl::uniformMatrix4fv(uView, 1, true, (float*)&view);
	gl::uniformMatrix4fv(uProjection, 1, true, (float*)&projection);
	gl::uniformMatrix4fv(uModel, 1, true, (float*)&model);
}

fn int main(String[] args)
{
	defer io::printn("Good Bye!");
	io::printn("Welcome");

	Window window = window::init();
	defer window::destroy(window);

	Color bgColor = {0.2,0.25,0.32,1};
	window::clearColor(bgColor);
	
	uint cubeVao = genVao(CUBE_VERTICES, CUBE_INDICES);
	defer (gl::deleteVertexArrays(1, &cubeVao));

	Shader fs = shader::compileFromSource(FS_BASIC, gl::GL_FRAGMENT_SHADER);
	Shader vs = shader::compileFromSource(VS_PROJECTION, gl::GL_VERTEX_SHADER);
	ShaderProgram shader = shader::linkShaders({fs, vs});

	setUpShaderProjection(shader);

	while (!glfw::windowShouldClose(window)) {
		gl::clear(gl::GL_COLOR_BUFFER_BIT | gl::GL_DEPTH_BUFFER_BIT);

		gl::bindVertexArray(cubeVao);
		gl::useProgram(shader);
		gl::drawElements(gl::GL_TRIANGLES, 36, gl::GL_UNSIGNED_INT, (void*)0);

		glfw::swapBuffers(window);
		glfw::pollEvents(window);
	}

	return 0;
}

