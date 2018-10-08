
//  UserDetailParser.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "SBJson.h"
#import "UserDetailObject.h"
#import "ErrorObj.h"

@interface UserDetailParser : NSObject
{
    UserDetailObject* _userDetailObj;
	NSMutableData *receivedData;
}
@property (nonatomic, retain) UserDetailObject* _userDetailObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
