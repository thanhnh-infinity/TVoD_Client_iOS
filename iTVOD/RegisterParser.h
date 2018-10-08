
//  RegisterParser.h
//  iTVOD

//  Created by vivas-mac on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "RegisterObj.h"
#import "JSON.h"
#import "ErrorObj.h"

@interface RegisterParser : NSObject
{
    RegisterObj *_registerObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) RegisterObj *_registerObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
