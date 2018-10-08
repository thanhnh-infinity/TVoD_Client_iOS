
//  CategoryObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "CategoryObject.h"

@implementation CategoryObject
@synthesize category_id,category_image,category_name,number_video_category;
-(id)init
{
    if (self = [super init]) {
        category_id = @"";
        category_image = @"";
        category_name = @"";
        number_video_category = 0;
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(category_id);
    SAFE_RELEASE(category_image);
    SAFE_RELEASE(category_name);
    
    [super dealloc];
}

@end
