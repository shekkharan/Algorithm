//
//  CellItem.h
//  TictacToe
//
//  Created by Shekhar  on 22/1/15.
//  Copyright (c) 2015 Edenred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface Area : NSObject

@property(nonatomic,assign)int firstValue;
@property(nonatomic,assign)int tag;
@property(nonatomic,assign)int row;
@property(nonatomic,assign)int column;
@property(nonatomic,assign)BOOL hasBeenScanned;
@property(nonatomic,strong)Area *rightArea;
@property(nonatomic,strong)Area *leftArea;
@property(nonatomic,strong)Area *downArea;
@property(nonatomic,strong)Area *upArea;

@property(nonatomic,strong)NSNumber *value;

- (void)setRow:(int)row Column:(int)column andValue:(NSNumber*)value;
- (id)initWithRow:(int)row Column:(int)column andValue:(NSNumber*)value;

@end
