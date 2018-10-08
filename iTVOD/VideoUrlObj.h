
//  VideoUrlObj.h
//  iTVOD

//  Created by vivas-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface VideoUrlObj : NSObject
{
    BOOL success;
    NSString *url;
    NSString *subtitle;
    NSString *sessionID;
}
@property (nonatomic,assign)  BOOL success;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *sessionID;
@end
