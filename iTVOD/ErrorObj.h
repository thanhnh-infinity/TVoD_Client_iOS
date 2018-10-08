
//  ErrorObj.h
//  iTVOD

//  Created by vivas-mac on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface ErrorObj : NSObject
{
    BOOL success;
    NSString *reason;
    NSString *type;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *type;
@end
