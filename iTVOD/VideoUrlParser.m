
//  VideoUrlParser.m
//  iTVOD

//  Created by vivas-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "VideoUrlParser.h"

@implementation VideoUrlParser
@synthesize _videoUrlObj;
- (id) init{
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	_videoUrlObj = nil;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:GET_VIDEO_URL_CONNECTION_FAILED object:nil];
    
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
	
	_videoUrlObj = [[VideoUrlObj alloc] init];
	
	_videoUrlObj.success = [[parserData objectForKey:kSuccess] boolValue];
    
    if (_videoUrlObj.success) {
        _videoUrlObj.sessionID = (NSString *)[parserData objectForKey:kSessionId];
        _videoUrlObj.url = (NSString *)[parserData objectForKey:kUrl];
        _videoUrlObj.subtitle = (NSString *)[parserData objectForKey:kSubtitle];
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_VIDEO_URL_OK object:nil];
    }
    else
    {
        
        ErrorObj *errObj = [[ErrorObj alloc] init];
        errObj.reason  = [parserData objectForKey:kReason];
        errObj.type = [parserData objectForKey:kType];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errObj.type message:errObj.reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        [errObj release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_VIDEO_URL_ERROR object:nil];
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
	SAFE_RELEASE(_videoUrlObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}
@end
