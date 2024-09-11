module shader;
import opengl::gl;
import std::io;
import libc;

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
        int infoLength;
        gl::getShaderiv(shader, gl::GL_INFO_LOG_LENGTH, &infoLength);
        char* infoLog = malloc(infoLength * char.sizeof);
        free(infoLog);

        gl::getShaderInfoLog(shader, infoLength, null, infoLog);
        libc::printf("shader(%d) compilation failed:\n"
				   "    %s\n", shader, infoLog);

        // clear shader
        gl::deleteShader(shader);
        return 0;
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
        int infoLenght;
        gl::getShaderiv(shaderProgram, gl::GL_INFO_LOG_LENGTH, &infoLenght);
        char *infoLog = malloc(infoLenght * char.sizeof);
        free(infoLog);

        gl::getShaderInfoLog(shaderProgram, infoLenght, null, infoLog);
        libc::printf(	"shader(%d) compilation failed:\n"
			"    %s\n", shaderProgram, *infoLog);

        // clear shader
        gl::deleteProgram(shaderProgram);
        return 0;
    }

    return shaderProgram;
}
