module sade::draw::naive;

import std::math::vector;

fn void drawPoint(Vec2f pos, float radius = 20, uint segmentCount = 3, float[4] color = {1,1,1,1}) {
    if (segmentCount < 3) {
        segmentCount = 3;
    }
    
    uint vertexCount = (uint)(segmentCount + 1);
    uint indexCount = 3 * segmentCount;

    Vec2f* vertices = (Vec2f*)malloc(Vec2f.sizeof * vertexCount);
    uint* indices = (uint*)malloc(uint.sizeof * indexCount);
    defer free(vertices);
    defer free(indices);
    
    vertices[0] = pos;

    float angularStep = 360f / segmentCount;

    for (int i = 1; i <= segmentCount; i++) {
        float angle = (float)math::deg_to_rad(angularStep * i);
        Vec2f point = Vec2f{math::sin(angle), math::cos(angle)} * radius + pos;
        vertices[i] = point;
    }

    for (int i = 0; i < segmentCount; i++) {
        indices[3*i] = 0;
        indices[3*i + 1] = i + 1;
        indices[3*i + 2] = i + 2;
    }
    indices[indexCount - 1] = 1;

    drawColored(vertices[0:vertexCount], indices[0:indexCount], color);
}
