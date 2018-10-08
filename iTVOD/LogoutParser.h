
//  LogoutParser.h
//  iTVOD

//  Created by vivas-mac on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "LogoutObj.h"
#import "ErrorObj.h"

@interface LogoutParser : NSObject
{
    LogoutObj *_logoutObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) LogoutObj *_logoutObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
