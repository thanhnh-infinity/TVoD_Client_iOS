
//  UserDetailParser.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "UserDetailParser.h"

@implementation UserDetailParser
@synthesize _userDetailObj;

- (id) init{
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	_userDetailObj = nil;
}


- (BOOL) parserWithJSONLink:(NSString*) strLink{
	// Create SBJSON object to parse JSON
	receivedData = [[NSMutableData data ] retain];		
	
	// Perform request and get JSON back as a NSData object
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strLink]];
   // [theRequest setHTTPShouldHandleCookies:NO];
    
    //[theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    //[theRequest setValue:g_cookies forHTTPHeaderField:@"Cookie"];
    //[theRequest setValue:g_cookies forHTTPHeaderField:@"Set-Cookie"];
    //[theRequest setHTTPShouldHandleCookies:YES];
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [pool release];
	
	return YES;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
	SAFE_RELEASE(receivedData);
    
    // notify to all classes involke CConnection instance
	
    [[NSNotificationCenter defaultCenter] postNotificationName:GET_USER_DETAIL_CONNECTION_FAILED object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    
    

}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
    NSDictionary *parserData = [json_string JSONValue];
	
	
	
	_userDetailObj = [[UserDetailObject alloc] init];
	
	_userDetailObj.success = [[parserData objectForKey:kSuccess] boolValue];
    if (_userDetailObj.success) {
        _userDetailObj.name = (NSString *) [parserData objectForKey:kName];
        
        _userDetailObj.email = (NSString *) [parserData objectForKey:kEmail];
        
        _userDetailObj.ballance = (NSString *)[parserData objectForKey:kBallance];
        _userDetailObj.subscriber = (NSString *)[parserData objectForKey:kSubscriber];
        _userDetailObj.uid = (NSString *)[parserData objectForKey:kUid];
        
        _userDetailObj.group_user = (NSString *)[parserData objectForKey:kGroupUser];
        _userDetailObj.payment_method = (NSString *)[parserData objectForKey:kPaymentMethod];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_USER_DETAIL_OK object:nil];
    }
    else
    {
        ErrorObj *_errObj = [[ErrorObj alloc] init];
        _errObj.reason = [parserData objectForKey:kReason];
        _errObj.type = [parserData objectForKey:kType];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_errObj.type message:_errObj.reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        [_errObj release];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:GET_USER_DETAIL_ERROR object:nil];
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
	SAFE_RELEASE(_userDetailObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}
@end
