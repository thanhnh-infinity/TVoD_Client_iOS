
//  VideoObject.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "VideoObject.h"

@implementation VideoObject
@synthesize video_id;
@synthesize video_english_title;
@synthesize video_description;
@synthesize video_picture_path;
@synthesize video_price;
@synthesize video_number_views;
@synthesize video_vietnamese_title;
@synthesize video_duration;
@synthesize live_channel_id;
@synthesize live_channel_title;
@synthesize live_channel_number_view;
@synthesize live_channel_folder;
@synthesize live_channel_url;
@synthesize news_content;
@synthesize news_id;
@synthesize news_title;
@synthesize news_image_path;
@synthesize news_number_view;

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(news_number_view);
    SAFE_RELEASE(news_image_path);
    SAFE_RELEASE(news_title);
    SAFE_RELEASE(news_id);
    SAFE_RELEASE(news_content);
    
    SAFE_RELEASE(video_id);
    SAFE_RELEASE(video_english_title);
    SAFE_RELEASE(video_vietnamese_title);
    SAFE_RELEASE(video_duration);
    SAFE_RELEASE(video_description);
    SAFE_RELEASE(video_picture_path);
    SAFE_RELEASE(video_price);
    SAFE_RELEASE(video_number_views);
    SAFE_RELEASE(live_channel_id);
    SAFE_RELEASE(live_channel_title);
    SAFE_RELEASE(live_channel_number_view);
    SAFE_RELEASE(live_channel_folder);
    SAFE_RELEASE(live_channel_url);
    [super dealloc];
}
@end
