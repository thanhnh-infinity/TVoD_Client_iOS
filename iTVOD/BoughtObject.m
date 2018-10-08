//
//  BoughtObject.m
//  iTVOD
//
//  Created by Do Thanh Nam on 05/01/2013.
//  Copyright (c) 2013 Edoo Corp. All rights reserved.
//

#import "BoughtObject.h"

@implementation BoughtObject

@synthesize transaction_id,transaction_date,transaction_value, stop_time, content_picture_path, content_id,content_name;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)dealloc
{
    SAFE_RELEASE(transaction_id);
    SAFE_RELEASE(transaction_date);
    SAFE_RELEASE(transaction_value);
    SAFE_RELEASE(stop_time);
    SAFE_RELEASE(content_picture_path);
    SAFE_RELEASE(content_id);
    SAFE_RELEASE(content_name);
    [super dealloc];
}

@end
