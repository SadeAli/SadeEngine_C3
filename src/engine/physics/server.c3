module sade::physics::server;
import sade::physics;

import std::collections::list;
import std::math::vector;
import sade::draw::naive;

struct PhysicsObject2D {
    typeid shape;
    Vec2f velocity;
    RectAA rectAA;
}

def PhysicsObjectList2D = List(<PhysicsObject2D>);
struct PhysicsServer2D {
    PhysicsObjectList2D objects;
}

fn PhysicsServer2D init() {
    PhysicsServer2D s;
    s.objects.new_init();

    return s;
}


fn void PhysicsServer2D.step(self, float deltaTime, bool negative = false) {
    int multiplayer = negative ? -1 : 1;
    foreach (&object : self.objects) {
        object.rectAA.bottom += object.velocity.y * deltaTime * multiplayer;
        object.rectAA.top += object.velocity.y * deltaTime * multiplayer;
        object.rectAA.left += object.velocity.x * deltaTime * multiplayer;
        object.rectAA.right += object.velocity.x * deltaTime * multiplayer;
    }
}

fn void PhysicsServer2D.applyGravity(self, Vec2f gravity, float deltaTime) {
    foreach (&object : self.objects) {
        object.velocity += gravity * deltaTime;
    }
}

fn void PhysicsServer2D.addCircle(&self, Vec2f position, float radius) {
    self.objects.push(
        PhysicsObject2D{
            .shape = Circle.typeid,
            .rectAA = {
                .top = radius + position.y,
                .bottom = -radius + position.y,
                .left = -radius + position.x,
                .right = radius + position.x
            }
        }
    );
}

fn void PhysicsServer2D.draw(&self, float[4] color) {
    foreach (object:self.objects) {
        object.rectAA.draw(color);
    }
}

fn void PhysicsServer2D.free(&self) {
    self.objects.free();
}
