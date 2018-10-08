
//  ListDramaObj.m
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ListDramaObj.h"

@implementation ListDramaObj
@synthesize success,quantity,total_quantity,lstDrama;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(success);
    SAFE_RELEASE(quantity);
    SAFE_RELEASE(total_quantity);
    SAFE_RELEASE(lstDrama);
    [super dealloc];
}
@end
