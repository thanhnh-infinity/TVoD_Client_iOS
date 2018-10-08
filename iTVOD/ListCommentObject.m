
//  ListCommentObject.m
//  iTVOD

//  Created by Do Thanh Nam on 30/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "ListCommentObject.h"

@implementation ListCommentObject
@synthesize success,quantity,lstCommentItems,total_quantity;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    //SAFE_RELEASE(success);
    //SAFE_RELEASE(quantity);
    //SAFE_RELEASE(total_quantity);
    SAFE_RELEASE(lstCommentItems);

    [super dealloc];
}

@end
