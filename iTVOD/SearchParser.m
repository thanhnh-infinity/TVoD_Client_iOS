
//  SearchParser.m
//  iTVOD

//  Created by vivas-mac on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "SearchParser.h"

@implementation SearchParser
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
    //[NSURLConnection connectionWithRequest:theRequest delegate:self];
    [pool release];
	
	return YES;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
	SAFE_RELEASE(receivedData);
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_CONNECTION_FAILED object:nil];
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
    
    
	
    NSDictionary *parserData = [json_string JSONValue];
	
//	
	
	_listVideoObj = [[ListVideoObject alloc] init];
	
	_listVideoObj.success = [[parserData objectForKey:kSuccess] boolValue];
    
    //Neu success = true get data va ban ve thong tin nhan duoc
    if (_listVideoObj.success) {
        _listVideoObj.quantity = [[parserData objectForKey:kQuantity] intValue];
        _listVideoObj.total_quantity = [[parserData objectForKey:kTotalQuantity] intValue];
        _listVideoObj.lstVideoItems = [[NSMutableArray alloc] init];
        
        NSArray *_lstItems = [parserData objectForKey:kItems];
        
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_OK object:nil];
    }
    else
    {
        ErrorObj *objErr = [[ErrorObj alloc] init];
        objErr.reason = [parserData objectForKey:kReason];
        objErr.type = [parserData objectForKey:kType];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:objErr.type message:objErr.reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        [objErr release];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SEARCH_ERROR object:nil];
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
    
    SAFE_RELEASE(_listVideoObj.lstVideoItems);
	SAFE_RELEASE(_listVideoObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}
@end
