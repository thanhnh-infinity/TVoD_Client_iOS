
//  LoginObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "LoginObject.h"

@implementation LoginObject
@synthesize success,session_id;
-(id)init
{
    if (self=[super init]) {
//        strSuccess = @"";
//        strSessionID = @"";
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(session_id);
    //SAFE_RELEASE(strSuccess);
    [super dealloc];
}
@end
