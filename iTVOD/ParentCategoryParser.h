
//  ParentCategoryParser.h
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ListParentCategoryObj.h"
#import "ErrorObj.h"

@interface ParentCategoryParser : NSObject
{
    ListParentCategoryObj *_listParentCategoryObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ListParentCategoryObj *_listParentCategoryObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
