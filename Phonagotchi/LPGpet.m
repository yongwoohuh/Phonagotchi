//
//  LPGpet.m
//  Phonagotchi
//
//  Created by Yongwoo Huh on 2018-01-25.
//  Copyright © 2018 Lighthouse Labs. All rights reserved.
//

#import "LPGpet.h"

@implementation LPGpet
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isGrumpy = NO;
    }
    return self;
}

- (void)becomesGrumpy
{
    self.isGrumpy = YES;
    NSLog(@"cat is grumpy");
}

@end
