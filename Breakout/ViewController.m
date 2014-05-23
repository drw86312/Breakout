//
//  ViewController.m
//  Breakout
//
//  Created by David Warner on 5/22/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *dynamicItemBehaviorBall;
@property UIDynamicItemBehavior *dynamicItemBehaviorPaddle;
@property UIDynamicItemBehavior *dynamicItemBehaviorBlock;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reset];

}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSString *currentbound = (NSString *)identifier;

    if ([currentbound isEqualToString:@"lower bound"]) {
        self.ballView.center = self.view.center;
        [self reset];
    }
    else
    {

    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    UIView *firstItem = (UIView *)item1;
    UIView *secondItem = (UIView *)item2;
    if (firstItem.tag == 1)
        {
            firstItem.hidden = YES;
            [self removeBlockAfterCollision:item1];
    }

    if (secondItem.tag == 1)
    {
        secondItem.hidden = YES;
    }
}


-(IBAction)dragPaddle:(UIPanGestureRecognizer *)pan
{
    self.paddleView.center = CGPointMake([pan locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)reset

{
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ballView, self.paddleView, self.blockView]];


    self.pushBehavior.active = YES;
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    self.pushBehavior.magnitude = .1;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    [self.collisionBehavior addBoundaryWithIdentifier:@"lower bound" fromPoint:CGPointMake(0.0, 568.0) toPoint:CGPointMake(320.0, 568.0)];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    self.dynamicItemBehaviorBall = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.dynamicItemBehaviorBall.allowsRotation = NO;
    self.dynamicItemBehaviorBall.elasticity = 1.0;
    self.dynamicItemBehaviorBall.friction = 0.0;
    self.dynamicItemBehaviorBall.resistance = 0.0;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBall];

    self.dynamicItemBehaviorPaddle = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.dynamicItemBehaviorPaddle.allowsRotation = NO;
    self.dynamicItemBehaviorPaddle.density = 1000;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorPaddle];

    self.dynamicItemBehaviorBlock = [[UIDynamicItemBehavior alloc] initWithItems:@[self.blockView]];
    self.dynamicItemBehaviorBlock.allowsRotation = NO;
    self.dynamicItemBehaviorBlock.density = 1000;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
}

-(void)removeBlockAfterCollision:(id<UIDynamicItem>)block
{
    [self.dynamicAnimator removeBehavior:self.collisionBehavior];
    [self.collisionBehavior removeItem:block];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

}



@end
