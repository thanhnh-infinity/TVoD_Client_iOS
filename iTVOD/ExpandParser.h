
//  ExpandParser.h
//  iTVOD

//  Created by vivas-mac on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ExpandObj.h"
#import "ErrorObj.h"
@interface ExpandParser : NSObject{
    ExpandObj *_expandObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ExpandObj *_expandObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
