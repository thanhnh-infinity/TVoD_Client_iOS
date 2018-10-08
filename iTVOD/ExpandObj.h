
//  ExpandObj.h
//  iTVOD

//  Created by vivas-mac on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface ExpandObj : NSObject
{
    BOOL success;
    NSString *content;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *content;
@end
