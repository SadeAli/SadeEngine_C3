module sade::shapes;
import sade;
import std;

fn void unit_test() {
    RectAA a = {1, 2, 3, 4};
    Vec2f[] ptr;
    @pool() {
        ptr = a.vertices();
        io::printn(ptr);
    };


    abort("test string");
}

macro Vec2f[] RectAA.vertices(self) {
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

macro uint[] RectAA.indices(&self) {
    uint[] indices = {
        0, 1, 2,
        1, 2, 3
    };

    uint[] index_array = mem::temp_new_array(uint, indices.len);
    index_array[..] = indices;

    return index_array;
}
