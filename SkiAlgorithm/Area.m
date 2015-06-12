//
//  CellItem.m
//  TictacToe
//
//  Created by Shekhar  on 22/1/15.
//  Copyright (c) 2015 Edenred. All rights reserved.
//

#import "Area.h"

@implementation Area



- (void)setRow:(int)row Column:(int)column andValue:(NSNumber*)value
{
    self.row = row;
    self.column = column;
    self.value = value;
}

- (id)initWithRow:(int)row Column:(int)column andValue:(NSNumber*)value
{
    self = [super init];
    
    if(self)
    {
        self.row = row;
        self.column = column;
        self.value = value;
    }
    return self;
}

@end
