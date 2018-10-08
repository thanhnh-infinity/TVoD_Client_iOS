
//  RegisterObj.m
//  iTVOD

//  Created by vivas-mac on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "RegisterObj.h"

@implementation RegisterObj
@synthesize success;
-(id)init
{
    if (self = [super init]) {
        
        //success = nil;
    }
    return self;
}
-(void)dealloc
{
    //SAFE_RELEASE(success);
    [super dealloc];
}
@end
