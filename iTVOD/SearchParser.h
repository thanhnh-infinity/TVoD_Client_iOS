
//  SearchParser.h
//  iTVOD

//  Created by vivas-mac on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ListVideoObject.h"
#import "ErrorObj.h"

@interface SearchParser : NSObject
{
    ListVideoObject *_listVideoObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ListVideoObject *_listVideoObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
