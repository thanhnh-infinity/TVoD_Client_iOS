
//  ErrorObj.m
//  iTVOD

//  Created by vivas-mac on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ErrorObj.h"

@implementation ErrorObj
@synthesize success,reason,type;
-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
    
}
//-(NSString *) getLang:(NSString *) m_type{
//    NSString *rt = @"";
//    switch (m_type) {
//        case @"CONTENT_FAVOURITE_EXISTED":
//              rt =  @"Nội dung này đã nằm trong danh sách ưu thích của bạn";
//            break;
//            
//        default:
//            break;
//    }
//    return rt;
//}

//-(NSString *) reason {

//    return [self getLang:self.type];
//    
//}

-(void)dealloc
{
    SAFE_RELEASE(reason);
    SAFE_RELEASE(type);
    [super dealloc];
}
@end
