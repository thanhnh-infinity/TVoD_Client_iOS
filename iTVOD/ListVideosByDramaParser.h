
//  ListVideosByDramaParser.h
//  iTVOD

//  Created by Do Thanh Nam on 21/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ListVideoObject.h"

@interface ListVideosByDramaParser :NSObject
{
    ListVideoObject *_listVideoObj;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) ListVideoObject *_listVideoObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;

@end
