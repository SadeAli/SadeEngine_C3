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

// FIX: add vertices and indices
fn void RenderBatch2D.render(&self, float[4] color) {
    // count vertices
    uint vertCount;
    foreach (vertArray: self.vertices) {
        vertCount = vertArray.len;
    }
    io::printn(vertCount);

    uint indCount;
    foreach (indArray: self.indices) {
        indCount = indArray.len;
    }
    io::printn(indCount);

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
    gl::bufferData(gl::GL_ARRAY_BUFFER, (Vec2f.sizeof*vertCount) + float[4].sizeof, null, gl::GL_STREAM_DRAW);
    gl::bufferSubData(gl::GL_ARRAY_BUFFER, 0, float[4].sizeof, &color);
    foreach (vertArray: self.vertices) {
        // TODO: implement
    }
    gl::bufferData(gl::GL_ELEMENT_ARRAY_BUFFER, uint.sizeof*indCount, null, gl::GL_STREAM_DRAW);
    foreach (indArray: self.indices) {
        // TODO: implement
    }

    // enable data
    gl::vertexAttribDivisor(0, 1000000); 

    // draw
    gl::drawElements(gl::GL_TRIANGLES, indCount, gl::GL_UNSIGNED_INT, (void*)0);
}

fn void RenderBatch2D.drawRect(&self, Vec2f pos = {0,0}, Vec2f size = {200,200}) {
    self.vertices.push(&&shapes::rectVertices(pos, size));
    self.indices.push(&&shapes::rectIndices());
}

fn void RenderBatch2D.drawRectAA(&self, RectAA *rectAA) {
    self.vertices.push(&&rectAA.vertices());
    self.indices.push(&&rectAA.indices());
}
