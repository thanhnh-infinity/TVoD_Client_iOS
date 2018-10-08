
//  CommentObject.m
//  iTVOD

//  Created by Do Thanh Nam on 30/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "CommentObject.h"

@implementation CommentObject
@synthesize comment_id,user_id,name,subject,body_value;

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void) dealloc {
    SAFE_RELEASE(comment_id);
    SAFE_RELEASE(user_id);
    SAFE_RELEASE(name);
    SAFE_RELEASE(body_value);    
    SAFE_RELEASE(subject);
    [super dealloc];
}
@end
