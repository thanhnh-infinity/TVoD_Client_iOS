
//  ChildCategoryParser.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "SBJson.h"
#import "ChildCategoryObject.h"
#import "ErrorObj.h"

@interface ChildCategoryParser : NSObject
{
    ChildCategoryObject *_childCategoryObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ChildCategoryObject *_childCategoryObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
