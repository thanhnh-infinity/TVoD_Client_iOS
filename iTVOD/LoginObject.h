
//  LoginObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface LoginObject : NSObject
{
   // NSString *strSuccess;
    BOOL success;
    NSString *session_id;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *session_id;
@end
