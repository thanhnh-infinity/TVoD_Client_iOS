
//  VideoObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface VideoObject : NSObject
{
    NSString *video_id;
    NSString *video_english_title;
    NSString *video_vietnamese_title;
    NSString *video_price;
    NSString *video_number_views;
    NSString *video_duration;
    
    NSString *video_description;
    NSString *video_picture_path;
    
    //live object
    NSString *live_channel_id;
    NSString *live_channel_title;
    NSString *live_channel_number_view;
    NSString *live_channel_folder;
    NSString *live_channel_url;
    
    //news
    NSString *news_id;
    NSString *news_title;
    NSString *news_content;
    NSString *news_image_path;
    NSString *news_number_view;
}
//news
@property (nonatomic, copy) NSString *news_id;
@property (nonatomic, copy) NSString *news_title;
@property (nonatomic, copy) NSString *news_content;
@property (nonatomic, copy) NSString *news_image_path;
@property (nonatomic, copy) NSString *news_number_view;
//video
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *video_english_title;
@property (nonatomic, copy) NSString *video_vietnamese_title;

@property (nonatomic, copy) NSString *video_price;
@property (nonatomic, copy) NSString *video_number_views;
@property (nonatomic, copy) NSString *video_duration;

@property (nonatomic, copy) NSString *video_description;
@property (nonatomic, copy) NSString *video_picture_path;

@property (nonatomic, copy) NSString *live_channel_id;
@property (nonatomic, copy) NSString *live_channel_title;
@property (nonatomic, copy) NSString *live_channel_number_view;
@property (nonatomic, copy) NSString *live_channel_folder;
@property (nonatomic, copy) NSString *live_channel_url;
@end
