//
//  LPGViewController.m
//  Phonagotchi
//
//  Created by Steven Masuch on 2014-07-26.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "LPGViewController.h"
#import "LPGpet.h"

@interface LPGViewController ()
@property (nonatomic, strong) LPGpet *cuteCat;
@property (nonatomic, strong) UIImageView *petImageView;
@property (nonatomic,strong) UIView *movingView;
@end

@implementation LPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];
    
    
    self.cuteCat = [[LPGpet alloc] init];
    self.petImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.petImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.petImageView.image = [UIImage imageNamed:@"default"];
    [self.view addSubview:self.petImageView];
    [self.petImageView setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPet:)];
    [self.petImageView addGestureRecognizer:panRecog];
    
    [NSLayoutConstraint constraintWithItem:self.petImageView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0
                                   constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.petImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0
                                   constant:0.0].active = YES;
    
    // bucketView
    UIImageView *bucketView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bucketView.translatesAutoresizingMaskIntoConstraints = NO;
    bucketView.image = [UIImage imageNamed:@"bucket"];
    bucketView.userInteractionEnabled = YES;
    bucketView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bucketView];

    [NSLayoutConstraint constraintWithItem:bucketView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:50].active = YES;
    
    [NSLayoutConstraint constraintWithItem:bucketView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeftMargin
                                multiplier:1
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:bucketView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0.3
                                  constant:0].active = YES;    
    
    
    // appleView
    UIImageView *appleView = [[UIImageView alloc] initWithFrame:CGRectZero];
    appleView.translatesAutoresizingMaskIntoConstraints = NO;
    appleView.image = [UIImage imageNamed:@"apple"];
    [appleView setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPressRecog = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(moveApple:)];
    [appleView addGestureRecognizer:longPressRecog];
    appleView.contentMode = UIViewContentModeScaleAspectFit;
    [bucketView addSubview:appleView];
    
    [NSLayoutConstraint constraintWithItem:appleView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:bucketView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:appleView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:bucketView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:appleView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50].active = YES;
    
    [NSLayoutConstraint constraintWithItem:appleView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50].active = YES;
}

- (void)panPet:(UIPanGestureRecognizer *)sender
{
    CGPoint petSpeed = [sender velocityInView:nil];
    double petMagnitude = sqrt((petSpeed.x * petSpeed.x) + (petSpeed.y * petSpeed.y));
    
    if ( petMagnitude > 2500.0 ) {
        [self.cuteCat becomesGrumpy];
        [self updateView];
    }
}

- (void)moveApple:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.movingView = [[UIView alloc] initWithFrame:sender.view.bounds];
            UIImageView *newAppleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            newAppleView.image = [UIImage imageNamed:@"apple"];
            [self.movingView addSubview:newAppleView];
            newAppleView.contentMode = UIViewContentModeScaleAspectFit;
            self.movingView.center = [sender locationInView:self.view];
//            self.movingView.backgroundColor = [UIColor cyanColor];
            self.movingView.userInteractionEnabled = NO;
            [self.view addSubview:self.movingView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.movingView.center = [sender locationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (CGRectContainsPoint(self.petImageView.frame, self.movingView.center)) {
                [UIView
                 animateWithDuration:1.5
                 animations:^{
                     self.movingView.center =
                     CGPointMake(self.movingView.center.x,
                                 CGRectGetMidY(self.view.frame));
                 }
                 completion:^(BOOL finished) {
                     [self.movingView removeFromSuperview];
                     self.movingView = nil;
                 }];
                
            } else {
                
                [UIView
                 animateWithDuration:1.5
                 animations:^{
                     self.movingView.center =
                     CGPointMake(self.movingView.center.x,
                                 CGRectGetMaxY(self.view.frame) +
                                 CGRectGetHeight(self.movingView.frame));
                 }
                 completion:^(BOOL finished) {
                     [self.movingView removeFromSuperview];
                     self.movingView = nil;
                 }];
            }
            
        }
            break;
        default:
            break;
    }
}


- (void)updateView
{
    if (self.cuteCat.isGrumpy) {
        self.petImageView.image = [UIImage imageNamed:@"grumpy"];
        [self.petImageView setNeedsDisplay];
    }
}
@end
