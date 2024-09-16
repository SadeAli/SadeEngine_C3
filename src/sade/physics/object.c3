module sade::physics;
import std::math::vector;

struct BorderRectAA {
    typeid type;
}

struct StaticObject2D {
    typeid shape;
    RectAA rectAA;
}

struct PhysicsObject2D {
    typeid shape;
    Vec2f velocity;
    RectAA rectAA;
}

fn void PhysicsObject2D.step(&object, float deltaTime) {
    object.rectAA.bottom += object.velocity.y * deltaTime;
    object.rectAA.top += object.velocity.y * deltaTime;
    object.rectAA.left += object.velocity.x * deltaTime;
    object.rectAA.right += object.velocity.x * deltaTime;
}

fn void PhysicsObject2D.stepNegative(&object, float deltaTime) => object.step(-deltaTime);

// FIX: collision algorithm
fn void PhysicsObject2D.collide(&self, PhysicsObject2D *other) {
    Vec2f v1, v2;
    v1 = self.velocity;
    v2 = other.velocity;

    if (other.velocity == {0,0}) {
        self.velocity = {0,0};
    }
}
