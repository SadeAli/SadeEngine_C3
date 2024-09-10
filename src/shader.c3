module shader;
import opengl::gl;
import std::io;

def Shader = uint;
def ShaderProgram = uint;
def ShaderType = GLenum;

fn Shader compileFromSource(char[] source, ShaderType type) {
    // compile individual shaders
    Shader shader = gl::createShader(type);
    if (shader == 0) {
        return 0;
    }

    // compile
	int lenght = source.len;
    gl::shaderSource(shader, 1, (char **)&source, &lenght);
    gl::compileShader(shader);

    // check for errors
    int success = 0;
    gl::getShaderiv(shader, gl::GL_COMPILE_STATUS, &success);
    if (!success) {
        // print error log
        char *infoLog = malloc(gl::GL_INFO_LOG_LENGTH * char.sizeof);
        free(infoLog);

        gl::getShaderInfoLog(shader, 512, null, infoLog);
        io::printfn("shader(%d) compilation failed:\n"
				   "    %s\n", shader, infoLog);

        // clear shader
        gl::deleteShader(shader);
    }

    return shader;
}

fn ShaderProgram linkShaders(Shader[] shaders) {
    // create shader
    ShaderProgram shaderProgram = gl::createProgram();
    if (shaderProgram == 0) {
        return 0;
    }

	foreach (shader : shaders)
	{
        gl::attachShader(shaderProgram, shader);
    }

    gl::linkProgram(shaderProgram);

    int success = 0;
    gl::getProgramiv(shaderProgram, gl::GL_LINK_STATUS, &success);
    if (!success) {
        // print error log
        char *infoLog = malloc(gl::GL_INFO_LOG_LENGTH * char.sizeof);
        free(infoLog);

        gl::getShaderInfoLog(shaderProgram, 512, null, infoLog);
        io::printfn(	"shader(%d) compilation failed:\n"
			"    %s\n", shaderProgram, infoLog);

        // clear shader
        gl::deleteProgram(shaderProgram);
    }

    return shaderProgram;
}
