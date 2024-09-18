module sade::draw::batched;
import sade;
import std;
import opengl;

struct RenderBatch2D {
    List(<Vec2f[]>) vertices;
    List(<uint[]>) indices;
}

macro @drawBatch(;@body(renderBatch)) {
    @pool() {
        RenderBatch2D batch = init();
        @body(&batch);
        batch.render({1,1,1,1});
    };
}

fn RenderBatch2D init() {
    RenderBatch2D rb;

    rb.vertices.temp_init();
    rb.indices.temp_init();

    return rb;
}

fn void RenderBatch2D.render(&self, float[4] color) {
    // count vertices and indices
    uint vertexCount;
    foreach (index, array: self.vertices) {
        vertexCount += array.len;
        // io::printfn("%s%s%s", index, ": ", array);
    }

    uint indexCount;
    foreach (array: self.indices) {
        indexCount += array.len;
    }

    // set gpu buffers
    uint vao, vbo, ebo;
    gl::genVertexArrays(1, &vao);
    gl::genBuffers(1, &vbo);
    gl::genBuffers(1, &ebo);

    defer gl::deleteVertexArrays(1, &vao);
    defer gl::deleteBuffers(1, &vbo);
    defer gl::deleteBuffers(1, &ebo);

    gl::bindVertexArray(vao);
    gl::bindBuffer(gl::GL_ARRAY_BUFFER, vbo);
    gl::bindBuffer(gl::GL_ELEMENT_ARRAY_BUFFER, ebo);

    // allocate gpu buffers
    gl::bufferData(gl::GL_ARRAY_BUFFER, (Vec2f.sizeof*vertexCount) + float[4].sizeof, null, gl::GL_STREAM_DRAW);
    gl::bufferData(gl::GL_ELEMENT_ARRAY_BUFFER, uint.sizeof*indexCount, null, gl::GL_STREAM_DRAW);

    // color
    gl::bufferSubData(gl::GL_ARRAY_BUFFER, 0, float[4].sizeof, &color);
    // vertices
    uint vboOffset = float[4].sizeof;
    foreach (array: self.vertices) {
        uint dataSize = array.len * $sizeof(array[0]);
        gl::bufferSubData(gl::GL_ARRAY_BUFFER, vboOffset, dataSize, array.ptr);
        vboOffset += dataSize;
    }
    // indices
    uint vertexOffset = 0;
    uint eboOffset = 0;
    foreach (index, &array: self.indices) {
        foreach (&num: *array) {
            (*num) += vertexOffset;
        }

        uint dataSize = array.len * uint.sizeof;
        gl::bufferSubData(gl::GL_ELEMENT_ARRAY_BUFFER, eboOffset, dataSize, array.ptr);
        eboOffset += dataSize;
        vertexOffset += self.vertices[index].len;
    }

    // enable data
    gl::vertexAttribPointer(0, 2, gl::GL_FLOAT, false, Vec2f.sizeof, (void*)$sizeof(color));
    gl::vertexAttribPointer(1, 4, gl::GL_FLOAT, false, $sizeof(color), (void*)0);
    gl::enableVertexAttribArray(0);  
    gl::enableVertexAttribArray(1);  
    gl::vertexAttribDivisor(1, 1000000); 

    // draw
    gl::drawElements(gl::GL_TRIANGLES, indexCount, gl::GL_UNSIGNED_INT, (void*)0);
    // gl::drawArrays(gl::GL_TRIANGLES, 0, vertexOffset);
}

fn void RenderBatch2D.drawRect(&batch, Vec2f pos = {0,0}, Vec2f size = {200,200}) {
    batch.vertices.push(&&shapes::rectVertices(pos, size));
    batch.indices.push(&&shapes::rectIndices());
}

fn void RenderBatch2D.drawRectAA(&self, RectAA *rectAA) {
    Vec2f[] vertices = rectAA.vertices();
    uint[] indices = rectAA.indices();

    self.vertices.push(vertices);
    self.indices.push(indices);
}
