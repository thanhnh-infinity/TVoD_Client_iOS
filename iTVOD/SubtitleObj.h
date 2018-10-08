
//  SubtitleObj.h
//  ReadSubtitle

//  Created by vivas-mac on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface SubtitleObj : NSObject
{
    NSString *inSecond;
    NSString *outSecond;
    NSString *content;
}
@property (nonatomic,retain) NSString *inSecond;
@property (nonatomic, retain) NSString *outSecond;
@property (nonatomic, retain) NSString *content;
@end
