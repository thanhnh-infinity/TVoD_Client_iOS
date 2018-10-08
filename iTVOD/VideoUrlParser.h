
//  VideoUrlParser.h
//  iTVOD

//  Created by vivas-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
//#import "SBJson.h"
#import "VideoUrlObj.h"
#import "ErrorObj.h"

@interface VideoUrlParser : NSObject
{
    VideoUrlObj *_videoUrlObj;
	NSMutableData *receivedData;
    
}

@property (nonatomic, retain) VideoUrlObj *_videoUrlObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;
@end
