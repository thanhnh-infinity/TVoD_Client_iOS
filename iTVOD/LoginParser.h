
//  LoginParser.h
//  iLurebook

//  Created by VANHUNG510 on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "SBJson.h"
#import "LoginObject.h"
#import "ErrorObj.h"

@interface LoginParser : NSObject {
	LoginObject* _loginObj;
	NSMutableData *receivedData;

}

@property (nonatomic, retain) LoginObject* _loginObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;

@end
