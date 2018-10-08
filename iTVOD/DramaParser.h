
//  DramaParser.h
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "DramaObj.h"
#import "ListDramaObj.h"
#import "ErrorObj.h"

@interface DramaParser : NSObject
{
    ListDramaObj *_listDramaObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ListDramaObj *_listDramaObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
