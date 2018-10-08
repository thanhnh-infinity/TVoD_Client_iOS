
//  ParentCategoryObj.m
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ParentCategoryObj.h"

@implementation ParentCategoryObj
@synthesize category_id,category_name,category_image;
-(id)init
{
    if (self = [super init]) {
        category_image = nil;
        category_id = nil;
        category_name = nil;
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(category_name);
    SAFE_RELEASE(category_id);
    SAFE_RELEASE(category_image);
    [super dealloc];
}
@end
