
//  UserDetailObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "UserDetailObject.h"

@implementation UserDetailObject
@synthesize success,name,email,ballance,subscriber,uid, payment_method,group_user;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    //SAFE_RELEASE(success);
    SAFE_RELEASE(name);
    SAFE_RELEASE(email);
    SAFE_RELEASE(ballance);
    SAFE_RELEASE(subscriber);
    SAFE_RELEASE(uid);
    SAFE_RELEASE(payment_method);
    SAFE_RELEASE(group_user);
    
    [super dealloc];
}
@end
