
//  ListCommentObject.h
//  iTVOD

//  Created by Do Thanh Nam on 30/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import <Foundation/Foundation.h>

@interface ListCommentObject : NSObject

{
    BOOL success;
    int quantity;
    int total_quantity;
    NSMutableArray *lstCommentItems;
}
@property (nonatomic,assign)BOOL success;
@property (nonatomic, assign) int quantity;
@property (nonatomic, assign) int total_quantity;
@property (nonatomic, assign) NSMutableArray *lstCommentItems;
@end
