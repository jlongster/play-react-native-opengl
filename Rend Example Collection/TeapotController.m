//
//  TeapotController.m
//  Rend Example Collection
//
//  Created by Anton Holmquist on 6/26/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import "TeapotController.h"
#import "RCTExport.h"

@interface TeapotController ()

@end

@implementation TeapotController
CC3Vector velocity;
CC3Vector acceleration;

- (void)viewDidLoad {
    [super viewDidLoad];

    velocity = CC3VectorMake(0, 0, 0);
    acceleration = CC3VectorMake(0, 0, 0);

    RELight *light = [REDirectionalLight light];
    [self.world addLight:light];

    REWavefrontMesh *teapotMesh = [REMeshCache meshNamed:@"cone.obj"];

    [REMeshCache meshNamed:@"box.obj"];
    [REMeshCache meshNamed:@"cow-parts.obj"];
    [REMeshCache meshNamed:@"cow.obj"];
    [REMeshCache meshNamed:@"mass.obj"];
    [REMeshCache meshNamed:@"jlongster.obj"];

    teapotNode_ = [[[TeapotNode alloc] initWithDefaultMesh:teapotMesh] retain];
    teapotNode_.rotationAxis = CC3VectorMake(0.1, 1, 0.3);
    teapotNode_.material.ambient = CC3Vector4Make(0.4, 0.4, 0.4, 1.0);
    teapotNode_.material.diffuse = [self randomColor];
    teapotNode_.material.specular = CC3Vector4Make(0.5, 0.6, 0.5, 1.0);
    teapotNode_.material.shininess = 24;
    [teapotNode_ setSizeX:75];
    [self.world addChild:teapotNode_];
}

- (void)loadMesh:(NSString *)path {
    RCT_EXPORT();

    dispatch_async(dispatch_get_main_queue(), ^{
        teapotNode_.material.diffuse = [self randomColor];
        teapotNode_.wavefrontMeshA = [REMeshCache meshNamed:path];
        [self reset];
    });
}

- (CC3Vector4)randomColor {
    float low_bound = .2;
    float high_bound = .6;
    float red = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    float green = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    float blue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    return CC3Vector4Make(red, green, blue, 1.0);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    teapotNode_ = nil;
}

- (NSDictionary *)constantsToExport {
  NSArray *objPaths =
      [NSBundle pathsForResourcesOfType:@"obj"
                            inDirectory:[[NSBundle mainBundle] bundlePath]];

  NSMutableDictionary *allJSConstants = [@{
      @"objPaths": objPaths
  } mutableCopy];

  return allJSConstants;
}

- (void)update:(float)dt {
    static float angle = 0;

    angle += 3;
    teapotNode_.rotationAngle = angle;

    CC3Vector pos = teapotNode_.position;
    [teapotNode_ setPosition:CC3VectorAdd(pos, velocity)];

    velocity = CC3VectorAdd(velocity, CC3VectorScaleUniform(acceleration, 2));
}

- (void)fly {
    RCT_EXPORT();
    acceleration = CC3VectorMake(0, 5, 0);
}

- (void)reset {
    RCT_EXPORT();
    acceleration = CC3VectorMake(0, 0, 0);
    velocity = CC3VectorMake(0, 0, 0);
    [teapotNode_ setPosition:CC3VectorMake(0, 0, 0)];
    camera_.lookDirection = CC3VectorMake(0, 0, -1);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    tapIsValid_ = YES;
    CGPoint point = [[touches anyObject] locationInView:glView_];
    touchStartPoint_ = point;

    lastDragPoints_[0] = point;
    lastDragPoints_[1] = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:glView_];
    CGPoint diff = CGPointMake(point.x - touchStartPoint_.x, point.y - touchStartPoint_.y);
    // float distance = sqrtf(diff.x * diff.x + diff.y * diff.y);
    // if(distance > 10) {
    //     tapIsValid_ = NO;
    // }

    lastDragPoints_[0] = lastDragPoints_[1];
    lastDragPoints_[1] = point;
    CGPoint delta = CGPointMake(lastDragPoints_[1].x - lastDragPoints_[0].x, lastDragPoints_[1].y - lastDragPoints_[0].y);

    CC3Vector lookDir = camera_.lookDirection;
    CC3Vector axisX = { 1.0, 0.0, 0.0 };
    CC3Vector axisY = { 0.0, 1.0, 0.0 };
    // lookDir = CC3VectorRotateVectorAroundAxisVector(lookDir, axisY, -delta.x * .01);
    // lookDir = CC3VectorRotateVectorAroundAxisVector(lookDir, axisX, -delta.y * .01);
    //camera_.lookDirection = lookDir;
    //[self rotateSphere:CC3VectorMake(delta.y * 0.8f, delta.x * 0.8f, 0)];
}

@end
