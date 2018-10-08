
//  ListFavoriteParser.m
//  iTVOD

//  Created by Do Thanh Nam on 29/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "ListFavoriteParser.h"

@implementation ListFavoriteParser
@synthesize _listVideoObj;

- (id) init{
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	_listVideoObj = nil;
}

- (BOOL) parserWithJSONLink:(NSString*) strLink{
	// Create SBJSON object to parse JSON
	receivedData = [[NSMutableData data ] retain];		
	
	// Perform request and get JSON back as a NSData object
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strLink]];
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [pool release];
	
	return YES;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
	SAFE_RELEASE(receivedData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LIST_FAVORITE_FAILED object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
	// Get JSON as a NSString from NSData response
    
	NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ((json_string == nil) || (json_string == @"") || [json_string isEqualToString:@""]) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LIST_FAVORITE_ERROR object:nil];
    }
	else {
        
        NSDictionary *parserData = [json_string JSONValue];
        if (!parserData){
            [[NSNotificationCenter defaultCenter]postNotificationName:LIST_FAVORITE_ERROR object:nil];            
            return;
        }
        
        _listVideoObj = [[ListVideoObject alloc] init];
        
        _listVideoObj.success = [[parserData objectForKey:kSuccess] boolValue];
        if (_listVideoObj.success) {
            _listVideoObj.quantity = [[parserData objectForKey:kQuantity] intValue];
            _listVideoObj.total_quantity = [[parserData objectForKey:kTotalQuantity] intValue];
            _listVideoObj._type = (NSString *)[parserData objectForKey:kType];
            
            
            _listVideoObj.lstVideoItems = [[NSMutableArray alloc] init];
            
            NSArray *_lstItems = [parserData objectForKey:kItems];
            
            if ([_listVideoObj._type isEqualToString:kTypeVideo]) {
                for (NSDictionary *d in _lstItems) {
                    VideoObject *obj = [[VideoObject alloc] init];
                    obj.video_id = (NSString *)[d objectForKey:kVideoId];
                    obj.video_english_title = (NSString *)[d objectForKey:kVideoEnglishTitle];
                    obj.video_vietnamese_title = (NSString *)[d objectForKey:kVideoVietnameseTitle];
                    obj.video_duration = (NSString *)[d objectForKey:kVideoDuration];
                    obj.video_price = (NSString *) [d objectForKey:kVideoPrice];
                    obj.video_number_views = (NSString *) [d objectForKey:kVideoNumberViews];
                    obj.video_description = (NSString *) [d objectForKey:kVideoDescription];
                    obj.video_picture_path = (NSString *) [d objectForKey:kVideoPicturePath];
                    [_listVideoObj.lstVideoItems addObject:obj];
                    [obj release];
                }
            }
            else if([_listVideoObj._type isEqualToString:kTypeLiveStreaming]){
                for (NSDictionary *d in _lstItems) {
                    VideoObject *obj = [[VideoObject alloc] init];
                    obj.live_channel_url = (NSString *)[d objectForKey:kLiveChannelUrl];
                    obj.live_channel_title = (NSString *)[d objectForKey:kLiveChannelTitle];
                    obj.live_channel_number_view = (NSString *)[d objectForKey:kLiveChannelNumberView];
                    obj.live_channel_id = (NSString *)[d objectForKey:kLiveChannelId];
                    obj.live_channel_folder = (NSString *)[d objectForKey:kLiveChannelFolder];
                    
                    obj.video_picture_path = (NSString *) [d objectForKey:kVideoPicturePath];
                    [_listVideoObj.lstVideoItems addObject:obj];
                    [obj release];
                }
            }
            else if([_listVideoObj._type isEqualToString:kTypeNews]){
                for (NSDictionary *d in _lstItems) {
                    VideoObject *obj = [[VideoObject alloc] init];
                    obj.news_id = (NSString *)[d objectForKey:kNewsId];
                    obj.news_title = (NSString *)[d objectForKey:kNewsTitle];
                    obj.news_content = (NSString *)[d objectForKey:kNewsContent];
                    obj.news_image_path = (NSString *)[d objectForKey:kNewsImagePath];
                    obj.video_picture_path = (NSString *)[d objectForKey:kNewsImagePath];
                    obj.news_number_view = (NSString *)[d objectForKey:kNewsNumberView];
                    [_listVideoObj.lstVideoItems addObject:obj];
                    [obj release];
                }
                
            }
                        
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LIST_FAVORITE_OK object:nil];
        }
        else
            {
//            ErrorObj *_errObj = [[ErrorObj alloc] init];
//            _errObj.reason = [parserData objectForKey:kReason];
//            _errObj.type = [parserData objectForKey:kType];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_errObj.type message:_errObj.reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
//            [alert release];
//            [_errObj release];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:LIST_FAVORITE_ERROR object:nil];
            
            }
        
    }
    //free data
	[json_string release];
    //	[parser release];	
	
	//Release data received
	[receivedData release];
    receivedData = nil;
    
	[connection release];

}

- (void) dealloc 
{
	SAFE_RELEASE(receivedData);
	[super dealloc];
}
@end
