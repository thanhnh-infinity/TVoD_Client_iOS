
//  ChildCategoryObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ChildCategoryObject.h"

@implementation ChildCategoryObject
@synthesize success,quantity,lstItems;
-(id)init
{
    if (self=[super init]) {
        lstItems = nil;
//        success = @"";
        quantity = @"";
    }
    return self;
}
-(void)dealloc
{
//    SAFE_RELEASE(success);
    SAFE_RELEASE(quantity);
    SAFE_RELEASE(lstItems);
    
    [super dealloc];
}
@end
