
//  SubtitleObj.m
//  ReadSubtitle

//  Created by vivas-mac on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "SubtitleObj.h"

@implementation SubtitleObj
@synthesize inSecond,outSecond,content;
-(id)init
{
    if (self =[super init]) {
        inSecond = @"";
        outSecond = @"";
        content = @"";
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}
@end
