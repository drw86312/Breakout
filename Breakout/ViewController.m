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
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UICollisionBehaviorDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (strong, nonatomic) BallView *ballView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *dynamicItemBehaviorBall;
@property UIDynamicItemBehavior *dynamicItemBehaviorPaddle;
@property UIDynamicItemBehavior *dynamicItemBehaviorBlock;
@property BOOL startButtonPressed;
@property (strong, nonatomic) NSMutableArray *blocksArray;
@property NSInteger level;
@property (strong, nonatomic) UIAlertView *lossAlert;
@property (strong, nonatomic) UIAlertView *winAlert;
@property (strong, nonatomic) UIAlertView *beatGameAlert;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView]];

    self.dynamicItemBehaviorPaddle = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.dynamicItemBehaviorPaddle.density = 1000;
    self.dynamicItemBehaviorPaddle.allowsRotation = NO;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorPaddle];

    self.dynamicItemBehaviorBlock = [[UIDynamicItemBehavior alloc] init];
    self.dynamicItemBehaviorBlock.density = 1000;
    self.dynamicItemBehaviorBlock.allowsRotation = NO;

    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    [self.collisionBehavior addBoundaryWithIdentifier:@"lower bound" fromPoint:CGPointMake(0.0, 568.0) toPoint:CGPointMake(320.0, 568.0)];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    self.startButtonPressed = NO;
    self.level = 1;
    self.blocksArray = [[NSMutableArray alloc] init];
    self.ballView.alpha = 0.0;

}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSString *currentbound = (NSString *)identifier;

    if ([currentbound isEqualToString:@"lower bound"]) {
        [self playerLossAlert];
    }
    else
    {

    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[BallView class]] && [item2 isKindOfClass:[BlockView class]])
    {
        BlockView *collidedBlock = (BlockView *)item2;
        [self.blocksArray removeObject:collidedBlock];
        [collidedBlock removeFromSuperview];
        [self.collisionBehavior removeItem:collidedBlock];

            if ([self.blocksArray objectAtIndex:0] == nil)
            {
                [self playerWinAlert];
            }
    }
    else if ([item1 isKindOfClass:[BlockView class]] && [item2 isKindOfClass:[BallView class]]) {
        BlockView *collidedBlock = (BlockView *)item1;
        [self.blocksArray removeObject:collidedBlock];
        [collidedBlock removeFromSuperview];
        [self.collisionBehavior removeItem:collidedBlock];
        }
            if ([self.blocksArray objectAtIndex:0] == nil) {
                [self playerWinAlert];
        }
}


-(IBAction)dragPaddle:(UIPanGestureRecognizer *)pan
{
    self.paddleView.center = CGPointMake([pan locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)reset

{
    [self createBlocksForLevel];
    [self createBall];
}


- (IBAction)onStartButtonPressed:(UIButton *)startbutton
{
    self.startButtonPressed = !self.startButtonPressed;
    if (self.startButtonPressed) {
        [self reset];
        self.startButton.alpha = 0.0;
    }
}


#pragma  mark - Helper methods

// Creates the correct number of blocks for each respective level using a switch statement.

-(void)createBlocksForLevel
{
    switch (self.level) {
        case 1:
            [self createBlocks1];
            break;
        case 2:
            [self createBlocks2];
            break;
        case 3:
            [self createBlocks3];
            break;
        case 4:
            [self createBlocks4];
            break;
        case 5:
            [self createBlocks5];
            break;
        case 6:
            [self createBlocks6];
            break;
        case 7:
            [self createBlocks7];
            break;
        case 8:
            [self createBlocks8];
            break;
        case 9:
            [self createBlocks9];
            break;
        case 10:
            [self createBlocks10];
            break;

        default:
            break;
    }

}

// These methods are for creating blocks for each level.
-(void)createBlocks1
{
    NSInteger blocks = 10;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = 5;

    while (x < blocks) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];

        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks2
{
    NSInteger blocks = 20;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks3
{
    NSInteger blocks = 30;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks4
{
NSInteger blocks = 40;
NSInteger blocksPerRow = blocks / self.level;
CGFloat margin = 5;
CGFloat x = 0;
CGFloat height = 20;
CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
CGFloat lateralOffset = margin;
CGFloat verticalOffset = margin;

while (x < 10) {

    // Create a block
    BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
    blockView.backgroundColor = [UIColor greenColor];
    blockView.tag = 1;

    [self.view addSubview:blockView];
    [self.collisionBehavior addItem:blockView];
    [self.dynamicItemBehaviorBlock addItem:blockView];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
    [self.blocksArray addObject:blockView];
    lateralOffset = lateralOffset + width + margin;
    x = x + 1;
}
lateralOffset = margin;
verticalOffset = verticalOffset + margin + height;
while (x < 20) {

    // Create a block
    BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
    blockView.backgroundColor = [UIColor greenColor];
    blockView.tag = 1;

    [self.view addSubview:blockView];
    [self.collisionBehavior addItem:blockView];
    [self.dynamicItemBehaviorBlock addItem:blockView];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
    [self.blocksArray addObject:blockView];
    lateralOffset = lateralOffset + width + margin;
    x = x + 1;
}
lateralOffset = margin;
verticalOffset = verticalOffset + margin + height;
while (x < 30)
{
    BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
    blockView.backgroundColor = [UIColor greenColor];
    blockView.tag = 1;

    [self.view addSubview:blockView];
    [self.collisionBehavior addItem:blockView];
    [self.dynamicItemBehaviorBlock addItem:blockView];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
    [self.blocksArray addObject:blockView];
    lateralOffset = lateralOffset + width + margin;
    x = x + 1;
    }
lateralOffset = margin;
verticalOffset = verticalOffset + margin + height;
while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks5
{
    NSInteger blocks = 50;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks6
{
    NSInteger blocks = 60;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 60) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks7
{
    NSInteger blocks = 70;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 60) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 70) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks8
{
    NSInteger blocks = 80;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 60) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 70) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 80) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks9
{
    NSInteger blocks = 90;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 60) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 70) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 80) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 90) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}

-(void)createBlocks10
{
    NSInteger blocks = 100;
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (320 - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 20) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 30)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 40) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 50) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 60) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 70) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 80) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 90) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x < 100) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        blockView.backgroundColor = [UIColor greenColor];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x = x + 1;
    }
}


// Sets the rounded look of the ballView.
-(void)setRoundedView:(BallView *)roundedView toDiameter:(float)newSize
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

// Method called when player loses. Displays an alertview, removes any remaining blocks on the screen, and makes the start button visible.
-(void)playerLossAlert
{
    self.lossAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!" message:@"You Lost" delegate:self cancelButtonTitle:@"Play Again" otherButtonTitles:nil, nil];
    [self.lossAlert show];
    [self removeAllBlocks];

    self.pushBehavior.active = NO;
    self.ballView.alpha = 0.0;
    self.startButton.alpha = 1.0;
}

// Enables 'start' button when player dismisses the alert view.
-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.startButtonPressed = !self.startButtonPressed;
    }
}

// Displays an alert showing the player beat the level and increments the level integer by 1.
-(void)playerWinAlert
{

    self.winAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You Won" delegate:self cancelButtonTitle:@"Next Level" otherButtonTitles:nil, nil];

    [self.winAlert show];

    [self removeAllBlocks];
    [self.pushBehavior removeItem:self.ballView];
    [self.dynamicAnimator removeBehavior:self.dynamicItemBehaviorBall];

    self.pushBehavior.active = NO;
    self.ballView.alpha = 0.0;
    self.startButton.alpha = 1.0;
    self.level = self.level + 1;
    self.ballView.center = CGPointMake(160, 280);
}

// Displays an alert showing the player beat the game and sets the level back to 1.
-(void)playerBeatGameAlert
{

    self.beatGameAlert = [[UIAlertView alloc] initWithTitle:@"You beat the game!" message:@"You brick breakin' son of a bitch, you!" delegate:self cancelButtonTitle:@"Start Over" otherButtonTitles:nil, nil];
    [self.beatGameAlert show];
    [self removeAllBlocks];
    [self.pushBehavior removeItem:self.ballView];
    [self.dynamicAnimator removeBehavior:self.dynamicItemBehaviorBall];

    self.pushBehavior.active = NO;
    self.ballView.alpha = 0.0;
    self.startButton.alpha = 1.0;
    self.level = 1;
}

// Removes all blocks from the superview and the blocksarray.
-(void)removeAllBlocks
{
    for (BlockView *block in self.blocksArray) {
        [block removeFromSuperview];
        [self.collisionBehavior removeItem:block];
    }

    [self.blocksArray removeAllObjects];
    [self.pushBehavior removeItem:self.ballView];
    [self.dynamicAnimator removeBehavior:self.dynamicItemBehaviorBall];
}

-(void)createBall
{
    self.ballView = [[BallView alloc] initWithFrame:CGRectMake(160, 280, 10, 10)];
    self.ballView.backgroundColor = [UIColor redColor];
    self.ballView.tag = 2;
    [self setRoundedView:self.ballView toDiameter:15];

    [self.view addSubview:self.ballView];

    [self.collisionBehavior addItem:self.ballView];

    self.dynamicItemBehaviorBall = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.dynamicItemBehaviorBall.allowsRotation = NO;
    self.dynamicItemBehaviorBall.density = 8;
    self.dynamicItemBehaviorBall.elasticity = 1.0;
    self.dynamicItemBehaviorBall.friction = 0.0;
    self.dynamicItemBehaviorBall.resistance = 0.0;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBall];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = .1;
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    [self.dynamicAnimator addBehavior:self.pushBehavior];

}



@end
