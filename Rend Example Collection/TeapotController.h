//
//  TeapotController.h
//  Rend Example Collection
//
//  Created by Anton Holmquist on 6/26/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import "GLViewController.h"
#import "TeapotNode.h"
#import "RENode.h"
#import "RCTExport.h"

@interface TeapotController : GLViewController<RCTNativeModule> {
    TeapotNode *teapotNode_;
    BOOL tapIsValid_;
    CGPoint lastDragPoints_[2];
    CGPoint touchStartPoint_;
}

@end
