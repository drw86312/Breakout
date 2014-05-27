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
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) PaddleView *paddleView;
@property (strong, nonatomic) BallView *ballView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *dynamicItemBehaviorBall;
@property UIDynamicItemBehavior *dynamicItemBehaviorPaddle;
@property UIDynamicItemBehavior *dynamicItemBehaviorBlock;
@property (strong, nonatomic) NSMutableArray *blocksArray;
@property (strong, nonatomic) UIAlertView *lossAlert;
@property (strong, nonatomic) UIAlertView *winAlert;
@property (strong, nonatomic) UIAlertView *beatGameAlert;
@property CGFloat ballDensity;
@property CGFloat paddleWidth;
@property NSInteger level;
@property BOOL startButtonPressed;

@end

@implementation ViewController

// Sets up collision behavior for the paddleView
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collisionBehavior = [[UICollisionBehavior alloc] init];

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
    self.ballDensity = 2.5;
    self.paddleWidth = 150;
    self.blocksArray = [[NSMutableArray alloc] init];
}

// The bottom of the screen has a boundary identifer "lower bound". When any object passes the boundary, the playerLoss helper method is called.
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSString *currentbound = (NSString *)identifier;

    if ([currentbound isEqualToString:@"lower bound"]) {
        [self playerLossAlert];
    }
}

// When an item of type Ballview collides with an item of the type BlockView, the collided block is removed from the superview, the array of block objects, and its collision behavior is removed. When the array count falls below 1, the player has beat the level and the playerWin helper method is called. If the player, beats the 10th level, the game has been beaten and the playerBeatGame helper method is called.
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
     if ([item1 isKindOfClass:[BlockView class]] && [item2 isKindOfClass:[BallView class]])
     {
        BlockView *collidedBlock = (BlockView *)item1;
        [self.blocksArray removeObject:collidedBlock];
        [collidedBlock removeFromSuperview];
        [self.collisionBehavior removeItem:collidedBlock];
    }

    if (self.blocksArray.count < 1 && self.level == 10)
    {
        [self playerBeatGameAlert];
        NSLog(@"Beat Game!");
    }
    else if (self.blocksArray.count < 1)
    {
        [self playerWinAlert];
        NSLog(@"Beat Level!");
    }
}
#pragma  mark - IBActions

// Adds pan gesture behavior so the player can move the paddle laterally, but not vertically.
-(IBAction)dragPaddle:(UIPanGestureRecognizer *)pan
{
    self.paddleView.center = CGPointMake([pan locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

// Calls the reset method and sets the button and title alpha to 0
- (IBAction)onStartButtonPressed:(UIButton *)startbutton
{
    self.startButtonPressed = !self.startButtonPressed;
    if (self.startButtonPressed) {
        [self reset];
        self.startButton.alpha = 0.0;
        self.gameTitle.alpha = 0.0;
    }
}

#pragma  mark - Helper methods

// Resets the game by calling the createBall, createBlocksForLevel, and create paddle methods.
-(void)reset
{
    [self createBlocksForLevel];
    [self createBall];
    [self createPaddle];
}

// Creates the correct number of blocks for each respective level using a switch statement.

-(void)createBlocksForLevel
{
    switch (self.level) {
        case 1:
            [self createBlocks:10];
            break;
        case 2:
            [self createBlocks:20];
            break;
        case 3:
            [self createBlocks:30];
            break;
        case 4:
            [self createBlocks:40];
            break;
        case 5:
            [self createBlocks:50];
            break;
        case 6:
            [self createBlocks:60];
            break;
        case 7:
            [self createBlocks:70];
            break;
        case 8:
            [self createBlocks:80];
            break;
        case 9:
            [self createBlocks:90];
            break;
        case 10:
            [self createBlocks:100];
            break;
        default:
            break;
    }
}


// Creates the correct number of blocks and aligns them in rows according to the number of blocks parameter passed in.
-(void)createBlocks:(NSInteger) blocks
{
    NSInteger blocksPerRow = blocks / self.level;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat height = 20;
    CGFloat width = (self.view.frame.size.width - ((margin * blocksPerRow) + margin))/blocksPerRow;
    CGFloat lateralOffset = margin;
    CGFloat verticalOffset = margin;

    while (x < 10 && x < blocks) {

        // Create a block
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brickicon"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
         x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 10 && x < 20 && x < blocks) {

        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brick2"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 20 && x < 30 && x < blocks)
    {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brickicon"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 30 && x < 40 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brick2"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 40 && x < 50 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brickicon"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 50 && x < 60 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brick2"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 60 && x < 70 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brickicon"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 70 && x < 80 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brick2"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 80 && x < 90 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brickicon"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
    lateralOffset = margin;
    verticalOffset = verticalOffset + margin + height;
    while (x >= 90 && x < 100 && x < blocks) {
        BlockView *blockView = [[BlockView alloc] initWithFrame:CGRectMake(lateralOffset, verticalOffset, width, height)];
        [blockView setImage:[UIImage imageNamed:@"brick2"]];
        blockView.tag = 1;

        [self.view addSubview:blockView];
        [self.collisionBehavior addItem:blockView];
        [self.dynamicItemBehaviorBlock addItem:blockView];
        [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorBlock];
        [self.blocksArray addObject:blockView];
        lateralOffset = lateralOffset + width + margin;
        x += 1;
    }
}

// Displays an alert showing the player lost. When alert view is dismissed, player replays the current level.
-(void)playerLossAlert
{
    self.lossAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!" message:@"You Lost" delegate:self cancelButtonTitle:@"Play Again" otherButtonTitles:nil, nil];

    [self.lossAlert show];
    [self removeAllBlocks];
    [self removeBall];
    [self removePaddle];
    self.startButton.alpha = 1.0;
    self.gameTitle.alpha = 1.0;

}

// Displays an alert showing the player beat the level and increments the level integer by 1.
-(void)playerWinAlert
{

    self.winAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You Won" delegate:self cancelButtonTitle:@"Next Level" otherButtonTitles:nil, nil];

    [self.winAlert show];
    [self removeBall];
    [self removePaddle];
    self.startButton.alpha = 1.0;
    self.gameTitle.alpha = 1.0;
    self.level = self.level + 1;
    self.ballDensity = self.ballDensity - 0.08;
    self.paddleWidth = self.paddleWidth - 8;
}

// Displays an alert showing the player beat the game and sets the level back to 1.
-(void)playerBeatGameAlert
{
    self.beatGameAlert = [[UIAlertView alloc] initWithTitle:@"You beat the game!" message:@"You brick breakin' son of a gun, you!" delegate:self cancelButtonTitle:@"Start Over" otherButtonTitles:nil, nil];
    [self.beatGameAlert show];

    [self removeAllBlocks];
    [self removeBall];
    [self removePaddle];
    self.startButton.alpha = 1.0;
    self.gameTitle.alpha = 1.0;
    self.level = 1;
    self.ballDensity = 2.5;
    self.paddleWidth = 150;
}

// Enables 'start' button when player dismisses the alert view.
-(void)alertView:(UIAlertView *)alert1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.startButtonPressed = !self.startButtonPressed;
    }
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

// Creates a ball in the view when the game begins.
-(void)createBall
{
    self.ballView = [[BallView alloc] initWithFrame:CGRectMake(160, 280, 20, 20)];
    self.ballView.tag = 2;
    [self.ballView setImage:[UIImage imageNamed:@"ball"]];

    [self.view addSubview:self.ballView];

    [self.collisionBehavior addItem:self.ballView];

    self.dynamicItemBehaviorBall = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.dynamicItemBehaviorBall.allowsRotation = NO;
    self.dynamicItemBehaviorBall.angularResistance = 0.0;
    self.dynamicItemBehaviorBall.density = self.ballDensity;
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

// Removes the ball from the view when the game ends.
-(void)removeBall
{
    [self.collisionBehavior removeItem:self.ballView];
    [self.pushBehavior removeItem:self.ballView];
    [self.dynamicAnimator removeBehavior:self.dynamicItemBehaviorBall];
    [self.ballView removeFromSuperview];
    self.pushBehavior.active = NO;
    self.ballView.alpha = 0.0;
    self.ballView.center = CGPointMake(160, 280);
}

// Creates a paddle when the game begins.
-(void)createPaddle
{
    self.paddleView = [[PaddleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - (self.paddleWidth/2), self.view.frame.size.height - 25, self.paddleWidth, 20)];
    self.paddleView.backgroundColor = [UIColor redColor];
    self.paddleView.tag = 0;

    [self.view addSubview:self.paddleView];

    [self.collisionBehavior addItem:self.paddleView];

    self.dynamicItemBehaviorPaddle = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.dynamicItemBehaviorPaddle.density = 100000;
    self.dynamicItemBehaviorPaddle.allowsRotation = NO;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehaviorPaddle];
}

// Removes the paddle when the game ends.
-(void)removePaddle
{
    [self.collisionBehavior removeItem:self.paddleView];
    [self.dynamicAnimator removeBehavior:self.dynamicItemBehaviorPaddle];
    [self.paddleView removeFromSuperview];
    self.paddleView.alpha = 0.0;
}



@end
