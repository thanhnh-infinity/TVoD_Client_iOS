
//  ListVideoObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ListVideoObject.h"

@implementation ListVideoObject
@synthesize success,quantity,lstVideoItems,total_quantity,_type;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    //SAFE_RELEASE(success);
    //SAFE_RELEASE(quantity);
   // SAFE_RELEASE(total_quantity);
    SAFE_RELEASE(lstVideoItems);
    SAFE_RELEASE(_type);
    [super dealloc];
}
@end
