
//  ListParentCategoryObj.m
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ListParentCategoryObj.h"

@implementation ListParentCategoryObj
@synthesize success,quantity,lstParentCategories;
-(id)init
{
    if (self = [super init]) {
        //success = nil;
        quantity = nil;
        lstParentCategories = nil;
    }
    return  self;
}
-(void)dealloc
{
    //SAFE_RELEASE(success);
    SAFE_RELEASE(quantity);
    SAFE_RELEASE(lstParentCategories);
    [super dealloc];
}
@end
