//
//  ListBoughtParser.h
//  iTVOD
//
//  Created by Do Thanh Nam on 05/01/2013.
//  Copyright (c) 2013 Edoo Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListVideoObject.h"
#import "ErrorObj.h"
#import "JSON.h"
#import "BoughtObject.h"

@interface ListBoughtParser : NSObject
{
ListVideoObject *_listVideoObj;
NSMutableData *receivedData;
}
@property (nonatomic, retain) ListVideoObject *_listVideoObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;

@end
