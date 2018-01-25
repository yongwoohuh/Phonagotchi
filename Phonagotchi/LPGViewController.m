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
@property (nonatomic) UIImageView *petImageView;

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
    
    
    [self.petImageView setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPet:)];
    [self.petImageView addGestureRecognizer:panRecog];
    
    
}

- (void)panPet:(UIPanGestureRecognizer *)sender
{
    CGPoint petSpeed = [sender velocityInView:nil];
    double petMagnitude = sqrt((petSpeed.x * petSpeed.x) + (petSpeed.y * petSpeed.y));
    
    if ( petMagnitude > 2500.0 ) {
        NSLog(@"%.2f", petMagnitude);
        [self.cuteCat becomesGrumpy];
        [self updateView];
//        NSLog(@"pet will get grumpy");
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
