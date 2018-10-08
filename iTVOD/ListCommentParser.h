
//  ListCommentParser.h
//  iTVOD

//  Created by Do Thanh Nam on 30/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import <Foundation/Foundation.h>
#import "ListCommentObject.h"
#import "JSON.h"
#import "ErrorObj.h"
#import "CommentObject.h"

@interface ListCommentParser : NSObject
{
     ListCommentObject *_listCommentObj;
     NSMutableData *receivedData;
}
@property (nonatomic, retain) ListCommentObject *_listCommentObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
- (void) initData;

@end
