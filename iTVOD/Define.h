
//  Define.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#ifndef iTVOD_Define_h
#define iTVOD_Define_h

//define util functions============================================================================
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(p) if( p != nil ){ [p release]; p = nil; }
#endif

#ifndef SAFE_ENDTIMER
#define SAFE_ENDTIMER(p) if( p != nil ){ [p invalidate]; p = nil; }
#endif

#ifndef SAFE_DELETE
#define SAFE_DELETE(p) {if( p != NULL ){ delete p; p = NULL; }}
#endif

#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(p) {if( p != NULL ){ delete [] p; p = NULL; }}
#endif

#ifndef SAFE_FREE
#define SAFE_FREE(p) {if( p != NULL ){ free(p); p = NULL; }}
#endif
//end define util functions========================================================================

//define json key==================================================================================
#define ktransaction_id @"transaction_id"
#define ktransaction_date @"transaction_date"
#define ktransaction_value @"transaction_value"
#define kstop_time @"stop_time"
#define kcontent_picture_path @"content_picture_path"
#define kcontent_id @"content_id"
#define kcontent_name @"content_name"


#define kSuccess                @"success"
#define kSessionId              @"sessionID"
#define kName                   @"name"
#define kEmail                  @"email"
#define kBallance               @"balance"
#define kSubscriber             @"subcriber"
#define kQuantity               @"quantity"
#define kTotalQuantity          @"total_quantity"
#define kItems                  @"items"
#define kUid                    @"uid"
#define kGroupUser              @"group_user"
#define kPaymentMethod          @"payment_method"

//video
#define kVideoId                @"video_id"
#define kVideoEnglishTitle      @"video_english_title"
#define kVideoVietnameseTitle   @"video_vietnamese_title"
#define kVideoDuration          @"video_duration"
#define kVideoNumberViews       @"video_number_views"
#define kVideoPrice             @"video_price"
#define kVideoPicturePath       @"video_picture_path"
#define kVideoDescription       @"video_description"

//chanel
#define kLiveChannelId            @"live_channel_id"
#define kLiveChannelTitle       @"live_channel_title"
#define kLiveChannelNumberView  @"live_channel_number_view"
#define kLiveChannelFolder      @"live_channel_folder"
#define kLiveChannelUrl         @"live_channel_url"

//news
#define kNewsId                 @"news_id"
#define kNewsContent            @"news_content"
#define kNewsTitle              @"news_title"
#define kNewsImagePath          @"news_image_path"
#define kNewsNumberView         @"news_number_view"

#define kCategoryId             @"category_id"
#define kCategoryImage          @"category_image"
#define kCategoryName           @"category_name"
#define kNumberVideoCategory    @"number_video_category"
#define kUrl                    @"url"
#define kSubtitle               @"subtitle"

#define kContent                @"content"

//Drama
#define kDramaId                @"drama_id"
#define kDramaEnTitle           @"drama_english_title"
#define kDramaViTitle           @"drama_vietnamese_title"
#define kDramaQuantity          @"drama_quantity"
#define kDramaImagePath         @"drama_image_path"

//Error
#define kReason                 @"reason"
#define kType                   @"type"
#define kTypeVideo              @"video"
#define kTypeLiveStreaming      @"live_streaming"
#define kTypeNews               @"news"
#define kTypeTransaction               @"transaction"
//end define json key==============================================================================

//====================
#define MOVIE_ID                @"14"
#define MUSIC_ID                @"13"
#define SPORT_ID                @"15"
#define TV_ID                   @"14"
#define LIVE_ID                 @"14"

//end================
//Define filter type===============================================================================
#define FILTER_NEWEST           @"newest"
#define FILTER_MOST_VIEW        @"most_view"
#define FILTER_FAVORITE         @"favorite"
#define FILTER_RANDOM           @"random"
#define FILTER_OLDEST           @"oldest"
//End define filter type ==========================================================================

#define CCONNECTION_OK                          @"CCONNECTION_OK"
#define NETWORK_OFFLINE                         @"NETWORK_OFFLINE"

#define LOGIN_OK                                @"LOGIN_OK"
#define LOGIN_ERROR                             @"LOGIN_ERROR"

#define GET_PARENT_CATEGORY_OK                  @"GET_PARENT_CATEGORY_OK"
#define GET_PARENT_CATEGORY_ERROR               @"GET_PARENT_CATEGORY_ERROR"

#define GET_CHILD_CATEGORY_OK                   @"GET_CHILD_CATEGORY_OK"
#define GET_CHILD_CATEGORY_ERROR                @"GET_CHILD_CATEGORY_ERROR"
#define GET_CHILD_CATEGORY_CONNECTION_FAILED    @"GET_CHILD_CATEGORY_CONNECTION_FAILED"

#define GET_LIST_VIDEO_OK                       @"GET_LIST_VIDEO_OK"
#define GET_LIST_VIDEO_ERROR                    @"GET_LIST_VIDEO_ERROR"
#define GET_LIST_VIDEO_CONNECTION_FAILED        @"GET_LIST_VIDEO_CONNECTION_FAILED"

#define GET_USER_DETAIL_OK                      @"GET_USER_DETAIL_OK"
#define GET_USER_DETAIL_ERROR                   @"GET_USER_DETAIL_ERROR"
#define GET_USER_DETAIL_CONNECTION_FAILED       @"GET_USER_DETAIL_CONNECTION_FAILED"

#define GET_VIDEO_URL_OK                        @"GET_VIDEO_URL_OK"
#define GET_VIDEO_URL_ERROR                     @"GET_VIDEO_URL_ERROR"
#define GET_VIDEO_URL_CONNECTION_FAILED         @"GET_VIDEO_URL_CONNECTION_FAILED"

#define REGISTER_OK                             @"REGISTER_OK"
#define REGISTER_ERROR                          @"REGISTER_ERROR"
#define REGISTER_CONNECTION_FAILED              @"REGISTER_CONNECTION_FAILED"

#define SEARCH_OK                               @"SEARCH_OK"
#define SEARCH_ERROR                            @"SEARCH_ERROR"
#define SEARCH_CONNECTION_FAILED                @"SEARCH_CONNECTION_FAILED"

#define LOGOUT_OK                               @"LOGOUT_OK"
#define LOGOUT_ERROR                            @"LOGOUT_ERROR"
#define LOGOUT_CONNECTION_FAILED                @"LOGOUT_CONNECTION_FAILED"

#define CONNECTION_ERROR                        @"CONNECTION_ERROR"
#define LOGIN_CONNECTION_ERROR                  @"LOGIN_CONNECTION_ERROR"
#define GET_PARENT_CATEGORY_CONNECTION_FAILED   @"GET_PARENT_CATEGORY_CONNECTION_FAILED"

#define EXPAND_OK                               @"EXPAND_OK"
#define EXPAND_ERROR                            @"EXPAND_ERROR"
#define EXPAND_CONNECTION_FAILED                @"EXPAND_CONNECTION_FAILED"

#define GET_LIST_DRAMA_OK                     @"GET_LIST_DRAMA_OK"
#define GET_LIST_DRAMA_ERROR                  @"GET_LIST_DRAMA_ERROR"
#define GET_LIST_DRAMA_CONNECTION_FAILED      @"GET_LIST_DRAMA_CONNECTION_FAILED"

#define CHECK_VERSION_OK                        @"CHECK_VERSION_OK"

#define DRAMA_ID                              @"4"

#define TVOD_LOGIN                      @"http://tvod.vn/?q=external_device/login&user_name=%@&password=%@"

#define TVOD_LOGOUT                     @"http://tvod.vn/?q=external_device/logout"

#define TVOD_REGISTER                   @"http://tvod.vn/?q=external_device/register&user_name=%@&password=%@"

#define TVOD_GET_USER_PROFILE           @"http://tvod.vn/?q=external_device/get_user_detail" 

//@"http://tvod.vn/?q=external_device/get_user_detail_iphone"

#define TVOD_GET_LIST_PARENT_CATEGORY   @"http://tvod.vn/?q=external_device/list_parent_category_iphone"

#define TVOD_GET_LIST_CHILD_CATEGORY    @"http://tvod.vn/?q=external_device/list_children_category_iphone&parent_category=%@" 

#define TVOD_GET_LIST_VIDEO             @"http://tvod.vn/?q=external_device/list_video_iphone&category=%@&filter=%@&page=%d"
#define TVOD_GET_LIST_VIDEO_BY_DRAMA    @"http://tvod.vn/?q=external_device/list_video_follow_drama_iphone&filter=%@&drama=%@&page=%d"

#define TVOD_GET_LIST_DRAMA             @"http://tvod.vn/?q=external_device/list_drama_iphone&filter=%@&page=%d"

#define TVOD_GET_LIST_LIVE_MOBILE       @"http://tvod.vn/?q=external_device/list_video_iphone&category=740&filter=newest&page=1"

#define TVOD_GET_LIST_LIVE_SD           @"http://tvod.vn/?q=external_device/list_video_iphone&category=710&filter=newest&page=1"

#define TVOD_GET_LIST_LIVE_HD           @"http://tvod.vn/?q=external_device/list_video_iphone&category=739&filter=newest&page=1"

//#define TVOD_GET_LIST_VIDEO             @"http://10.3.2.175/tvod/?q=external_device/list_video_iphone&category=%@&filter=%@&page=%d"
#define TVOD_GET_VIDEO_URL              @"http://tvod.vn/?q=external_device/getURL_iphone&video_id=%@&video_type=3"
#define TVOD_GET_VIDEO_IPAD_URL         @"http://tvod.vn/?q=external_device/getURL_iphone&video_id=%@&video_type=3"
    
#define TVOD_SEARCH                     @"http://tvod.vn/?q=external_device/search&keyword=%@&page=%d"
#define TVOD_EXPAND_EXPIRED_DATE        @"http://tvod.vn/?q=external_device/convert_balance_to_expired_date&pur_type=%d"
#define TVOD_CHECK_VERSION              @"http://api.tvod.vn/?q=external_api_device/checkVersionApplication&application_id=562&device=1"

#define TVOD_ADD_CONTENT_ID_TO_FAVORITE @"http://tvod.vn/?q=external_device_level_2/addContentFavorite&content_id=%@"
#define TVOD_LIST_FAVORITE_CONTENTS     @"http://tvod.vn/?q=external_device_level_2/getListContentFavorite&page=%d"
#define TVOD_LIST_COMMENTS_OF_CONTENT_ID    @"http://tvod.vn/?q=external_device_level_2/getListCommentsFollwoContent&content_id=%@&page=%d"
#define TVOD_POST_COMMENT_TO_CONTENT_ID  @"http://tvod.vn/?q=external_device_level_2/addCommentFollwoContent&content_id=%@&subject=%@"

#define TVOD_GET_LIST_RELATED_BY_CONTENT_ID @"http://tvod.vn/?q=external_device_level_2/getListRelatedContent&content_id=%@&page=%d"

#define TVOD_GET_LIST_BOUGHT    @"http://tvod.vn/?q=external_device/get_list_transaction&transaction_type=1&page=%d&time=%@"

#define GET_LIST_VIDEOS_BY_DRAMA_OK     @"GET_LIST_VIDEOS_BY_DRAMA_OK"
#define GET_LIST_VIDEOS_BY_DRAMA_ERROR  @"GET_LIST_VIDEOS_BY_DRAMA_ERROR"
#define GET_LIST_VIDEOS_BY_DRAMA_CONNECTION_FAILED  @"GET_LIST_VIDEOS_BY_DRAMA_CONNECTION_FAILED"

#define ADD_TO_FAVORITE_OK  @"ADD_TO_FAVORITE_OK"
#define ADD_TO_FAVORITE_ERROR    @"ADD_TO_FAVORITE_CONNECTION_ERROR"
#define ADD_TO_FAVORITE_FAILED      @"ADD_TO_FAVORITE_FAILED"

#define GET_LIST_LIVE_OK    @"GET_LIST_LIVE_OK"
#define GET_LIST_LIVE_ERROR    @"GET_LIST_LIVE_ERROR"
#define GET_LIST_LIVE_FAILED    @"GET_LIST_LIVE_FAILED"

#define LIST_FAVORITE_OK  @"LIST_FAVORITE_OK"
#define LIST_FAVORITE_ERROR    @"LIST_FAVORITE_CONNECTION_ERROR"
#define LIST_FAVORITE_FAILED      @"LIST_FAVORITE_FAILED"

#define LIST_BOUGHT_OK  @"LIST_BOUGHT_OK"
#define LIST_BOUGHT_ERROR  @"LIST_BOUGHT_ERROR"
#define LIST_BOUGHT_FAILED  @"LIST_BOUGHT_FAILED"

#define LIST_COMMENT_OK  @"LIST_COMMENT_OK"
#define LIST_COMMENT_ERROR    @"LIST_COMMENT_ERROR"
#define LIST_COMMENT_FAILED      @"LIST_COMMENT_FAILED"
#define kCommentId  @"comment_id"
#define kCommentUserId @"user_id"
#define kCommentUserName  @"name"
#define kCommentSubject  @"subject"
#define kCommentBodyValue  @"body_value"

#define POST_COMMENT_OK @"POST_COMMENT_OK"
#define POST_COMMENT_FAILED @"POST_COMMENT_FAILED"
#define POST_COMMENT_ERROR @"POST_COMMENT_ERROR"


#define ALERT_TITLE @"Thông báo"


#define TVOD_ITEMS_PAGE_SIZE    25

#define LOADING_MESSAGE @"Xin vui lòng chờ"

#endif

BOOL g_isRefreshGetUserDetail;
NSString *g_cookies;
BOOL isDebug;