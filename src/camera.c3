module std::math::matrix::extended(<Real>);

/*
fn void glm_rotate_make(mat4 m, float angle, vec3 axis) {
  CGLM_ALIGN(8) vec3 axisn, v, vs;
  float c;

  c = cosf(angle);

  glm_vec3_normalize_to(axis, axisn);
  glm_vec3_scale(axisn, 1.0f - c, v);
  glm_vec3_scale(axisn, sinf(angle), vs);

  glm_vec3_scale(axisn, v[0], m[0]);
  glm_vec3_scale(axisn, v[1], m[1]);
  glm_vec3_scale(axisn, v[2], m[2]);

  m[0][0] += c;       m[1][0] -= vs[2];   m[2][0] += vs[1];
  m[0][1] += vs[2];   m[1][1] += c;       m[2][1] -= vs[0];
  m[0][2] -= vs[1];   m[1][2] += vs[0];   m[2][2] += c;

  m[0][3] = m[1][3] = m[2][3] = m[3][0] = m[3][1] = m[3][2] = 0.0f;
  m[3][3] = 1.0f;
}

fn void glm_mul_rot(mat4 m1, mat4 m2, mat4 dest) {
  float a00 = m1[0][0], a01 = m1[0][1], a02 = m1[0][2], a03 = m1[0][3],
        a10 = m1[1][0], a11 = m1[1][1], a12 = m1[1][2], a13 = m1[1][3],
        a20 = m1[2][0], a21 = m1[2][1], a22 = m1[2][2], a23 = m1[2][3],
        a30 = m1[3][0], a31 = m1[3][1], a32 = m1[3][2], a33 = m1[3][3],

        b00 = m2[0][0], b01 = m2[0][1], b02 = m2[0][2],
        b10 = m2[1][0], b11 = m2[1][1], b12 = m2[1][2],
        b20 = m2[2][0], b21 = m2[2][1], b22 = m2[2][2];

  dest[0][0] = a00 * b00 + a10 * b01 + a20 * b02;
  dest[0][1] = a01 * b00 + a11 * b01 + a21 * b02;
  dest[0][2] = a02 * b00 + a12 * b01 + a22 * b02;
  dest[0][3] = a03 * b00 + a13 * b01 + a23 * b02;

  dest[1][0] = a00 * b10 + a10 * b11 + a20 * b12;
  dest[1][1] = a01 * b10 + a11 * b11 + a21 * b12;
  dest[1][2] = a02 * b10 + a12 * b11 + a22 * b12;
  dest[1][3] = a03 * b10 + a13 * b11 + a23 * b12;

  dest[2][0] = a00 * b20 + a10 * b21 + a20 * b22;
  dest[2][1] = a01 * b20 + a11 * b21 + a21 * b22;
  dest[2][2] = a02 * b20 + a12 * b21 + a22 * b22;
  dest[2][3] = a03 * b20 + a13 * b21 + a23 * b22;

  dest[3][0] = a30;
  dest[3][1] = a31;
  dest[3][2] = a32;
  dest[3][3] = a33;
}
*/

module std::math::matrix(<Real>);
fn Matrix4x4 Matrix4x4.rotate_at(&self, Real[<3>] center, float rad, Real[<3>] axis) {
	return *self;
}

module std::math::matrix(<Real>);
import std::math::matrix::extended;

module camera;
import std::math;

struct Camera {
	Vec3f position;
	Matrix4f view;
}

macro Vec3f Camera.up(&self) {
	return {0, 1, 0};
}
macro Vec3f Camera.right(&self) {
	return {1, 0, 0};
}

fn void Camera.move(&self, Vec3f amount) {
        self.position += amount;
}

fn void Camera.rotateFP(&self, float yaw, float pitch) {
    Vec3f right = self.right();
	
    self.view = self.view.rotate_at(self.position, (float)math::deg_to_rad(pitch), self.right());
    self.view = self.view.rotate_at(self.position, (float)math::deg_to_rad(yaw), self.up());
}
