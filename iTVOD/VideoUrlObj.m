
//  VideoUrlObj.m
//  iTVOD

//  Created by vivas-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "VideoUrlObj.h"

@implementation VideoUrlObj
@synthesize success,sessionID,url,subtitle;
-(id)init
{
    if (self = [super init]) {
            
    }
    return self;
}
-(void)dealloc
{
   // SAFE_RELEASE(success);
    SAFE_RELEASE(sessionID);
    SAFE_RELEASE(url);
    SAFE_RELEASE(subtitle);
    [super dealloc];
}
@end
