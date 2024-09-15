module sade::draw::naive;
import std::math::vector;
import opengl::gl;

macro void drawColored(Vec2f[] vertices, uint[] indices, float[4] color) {
    uint vao, vbo, ebo;
    gl::genVertexArrays(1, &vao);
    gl::genBuffers(1, &vbo);
    gl::genBuffers(1, &ebo);

    defer gl::deleteVertexArrays(1, &vao);
    defer gl::deleteBuffers(1, &vbo);
    defer gl::deleteBuffers(1, &ebo);

    // bind
    gl::bindVertexArray(vao);
    gl::bindBuffer(gl::GL_ARRAY_BUFFER, vbo);
    gl::bindBuffer(gl::GL_ELEMENT_ARRAY_BUFFER, ebo);

    // set up data
    gl::bufferData(gl::GL_ARRAY_BUFFER, (Vec2f.sizeof*vertices.len) + float[4].sizeof, null, gl::GL_STREAM_DRAW);
    gl::bufferSubData(gl::GL_ARRAY_BUFFER, 0, Vec2f.sizeof*vertices.len, vertices.ptr);
    gl::bufferSubData(gl::GL_ARRAY_BUFFER, Vec2f.sizeof*vertices.len, float[4].sizeof, &color);
    gl::bufferData(gl::GL_ELEMENT_ARRAY_BUFFER, uint.sizeof*indices.len, indices.ptr, gl::GL_STREAM_DRAW);

    // enable data
    gl::vertexAttribPointer(0, vertices[0].len, gl::GL_FLOAT, false, $sizeof(vertices[0]), (void*)0);
    gl::vertexAttribPointer(1, 4, gl::GL_FLOAT, false, $sizeof(color), (void*)(Vec2f.sizeof*vertices.len));
    gl::enableVertexAttribArray(0);  
    gl::enableVertexAttribArray(1);  
    gl::vertexAttribDivisor(1, 1000000); 

    // draw
    gl::drawElements(gl::GL_TRIANGLES, indices.len, gl::GL_UNSIGNED_INT, (void*)0);
}
