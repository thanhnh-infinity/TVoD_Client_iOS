
//  ListVideoParser.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "SBJson.h"
#import "ListVideoObject.h"
#import "ErrorObj.h"

@interface ListVideoParser : NSObject
{
    ListVideoObject *_listVideoObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ListVideoObject *_listVideoObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
