
//  CheckVersionObj.m
//  iTVODForiPad

//  Created by vivas-mac on 10/11/12.



#import "CheckVersionObj.h"

@implementation CheckVersionObj
@synthesize current_version,link_update,success;
-(id)init
{
    if (self = [super init]) {
        success = FALSE;
        current_version = @"";
        link_update = @"";
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}
@end
