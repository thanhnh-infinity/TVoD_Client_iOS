
//  DramaObj.m
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "DramaObj.h"

@implementation DramaObj
@synthesize drama_image_path,drama_quantity,drama_vietnamese_title,drama_id,drama_english_title;
-(id)init
{
    if (self = [super init]) {
        drama_id = @"";
        drama_english_title = @"";
        drama_vietnamese_title = @"";
        drama_image_path = @"";
        drama_quantity = @"";
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(drama_id);
    SAFE_RELEASE(drama_english_title);
    SAFE_RELEASE(drama_vietnamese_title);
    SAFE_RELEASE(drama_quantity);
    SAFE_RELEASE(drama_image_path);
    [super dealloc];
}

@end
