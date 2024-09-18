module shader;
import opengl::gl;
import std::math;
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

    // if fails print error log
    if (!success) {
        // allocate info buffer
        int infoLength;
        gl::getShaderiv(shader, gl::GL_INFO_LOG_LENGTH, &infoLength);
        char* infoLog = libc::malloc(infoLength * char.sizeof);
        defer free(infoLog);

        // get infolog and print it
        gl::getShaderInfoLog(shader, infoLength, null, infoLog);
        libc::printf("shader(%d) compilation failed:\n"
                       "%s\n", shader, infoLog);

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
        char *infoLog = libc::malloc(infoLenght * char.sizeof);
        defer free(infoLog);

        gl::getShaderInfoLog(shaderProgram, infoLenght, null, infoLog);
        libc::printf("shader(%d) compilation failed:\n"
                    "%s\n", shaderProgram, *infoLog);

        // clear shader
        gl::deleteProgram(shaderProgram);
        return 0;
    }

    return shaderProgram;
}

macro ShaderProgram.setUniform(self, char *name, data) {
        int location = gl::getUniformLocation(self, name);
	$switch ($typeof(data))
		$case Matrix4f:
			gl::uniformMatrix4fv(location, 1, true, (float*)&data);
		$default:
			unreachable("uniform type is not defined");
        $endswitch
}

macro ShaderProgram.delete(self) {
    gl::deleteProgram(self);
}

macro Shader.delete(self) {
    gl::deleteShader(self);
}
