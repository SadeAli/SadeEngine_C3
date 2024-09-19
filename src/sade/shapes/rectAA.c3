module sade::shapes;
import sade;
import std;

macro Vec2f[] RectAA.vertices(self) {
    Vec2f[4] verts = {
        {self.left, self.top},
        {self.left, self.bottom},
        {self.right, self.top},
        {self.right, self.bottom},
    };

    Vec2f[] vert_array = mem::new_array(Vec2f, 4);
    vert_array[..] = verts;

    return vert_array;
}

macro uint[] RectAA.indices(&self) {
    uint[] indices = {
        0, 1, 2,
        1, 2, 3
    };

    uint[] index_array = mem::new_array(uint, 6);
    index_array[..] = indices;

    return index_array;
}

macro Vec2f[] RectAA.temp_vertices(self) {
    Vec2f[4] verts = {
        {self.left, self.top},
        {self.left, self.bottom},
        {self.right, self.top},
        {self.right, self.bottom},
    };

    Vec2f[] vert_array = mem::temp_new_array(Vec2f, 4);
    vert_array[..] = verts;

    return vert_array;
}

macro uint[] RectAA.temp_indices(&self) {
    uint[] indices = {
        0, 1, 2,
        1, 2, 3
    };

    uint[] index_array = mem::temp_new_array(uint, indices.len);
    index_array[..] = indices;

    return index_array;
}
