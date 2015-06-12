//
//  NSObject+AddItems.m
//  SkiAlgorithm
//
//  Created by Shekhar  on 11/6/15.
//  Copyright (c) 2015 Myaango. All rights reserved.
//

#import "NSMutableArray+AddItems.h"

@implementation NSMutableArray (AddItems)

- (void)addItemsWithCount:(int)count
{
    for (int i =0; i < count; i++) {
        [self addObject:@""];
    }
}

@end
