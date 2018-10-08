
//  ExpandObj.m
//  iTVOD

//  Created by vivas-mac on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ExpandObj.h"

@implementation ExpandObj
@synthesize success,content;
-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(content);
    [super dealloc];
}
@end
