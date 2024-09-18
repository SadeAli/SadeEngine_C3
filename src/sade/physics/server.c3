module sade::physics::server;
import sade::physics;

import std::collections::list;
import std::math::vector;
import sade::draw::batched;

def PhysicsObjectList2D = List(<PhysicsObject2D>);
struct PhysicsServer2D {
    PhysicsObjectList2D physicsObjects;
    bool useBorder;
    RectAA border;
}

fn PhysicsServer2D init(RectAA border = {0,0,0,0}) {
    PhysicsServer2D s;
    s.physicsObjects.new_init();

    s.border = border;
    if (border.not_equals(RectAA{0,0,0,0})) {
        s.useBorder = true;
    }

    return s;
}

fn void PhysicsServer2D.step(self, float deltaTime) {
    foreach (&object : self.physicsObjects) {
        object.step(deltaTime);

        bool isColliding = false;
        foreach(&object2 : self.physicsObjects) {
            if (object == object2) continue;

            if (!object.rectAA.isOutsideRectAA(object2.rectAA)) {
                isColliding = true;
            }
        }

        if ((self.useBorder &&
            !object.rectAA.isInsideRectAA(self.border)) ||
            isColliding) {
            object.stepNegative(deltaTime);
            object.velocity = {0,0};
        }
    }
}
fn void PhysicsServer2D.stepNegative(self, float deltaTime) => self.step(-deltaTime);

fn void PhysicsServer2D.applyGravity(self, Vec2f gravity, float deltaTime) {
    foreach (index, &object : self.physicsObjects) {
        object.velocity += gravity * deltaTime;
    }
}

fn void PhysicsServer2D.addCircle(&self, Vec2f position, float radius) {
    self.physicsObjects.push(
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

import std::io;
fn void PhysicsServer2D.draw(&self, float[4] color) {
    batched::@drawBatch(color; RenderBatch2D *batch) {
        foreach (object:self.physicsObjects) {
            batch.drawRectAA(&object.rectAA);
        }
    };
    /*
    foreach (index, object:self.physicsObjects) {
        object.rectAA.draw(color);
    }
    */
}

fn void PhysicsServer2D.free(&self) {
    self.physicsObjects.free();
}

