
//  LoginParser.m
//  iLurebook

//  Created by VANHUNG510 on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "LoginParser.h"
#import "Define.h"

@implementation LoginParser

@synthesize _loginObj;

- (id) init{
    
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	
	_loginObj = nil;
}


- (BOOL) parserWithJSONLink:(NSString*) strLink{
	
        // Create SBJSON object to parse JSON
	receivedData = [[NSMutableData data ] retain];		
	
	// Perform request and get JSON back as a NSData object
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    	
    //[theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    [theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
   
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [pool release];
	
	return YES;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
	[connection release];
	SAFE_RELEASE(receivedData);
    
    // notify to all classes involke CConnection instance
    
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_CONNECTION_ERROR object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
	[receivedData setLength:0];
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    g_cookies = [cookie retain];
    
    
    
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
	[receivedData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
	// Get JSON as a NSString from NSData response
	
	NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
    NSDictionary *parserData = [json_string JSONValue];
	
//	
	
	_loginObj = [[LoginObject alloc] init];
	
	_loginObj.success = [[parserData objectForKey:kSuccess] boolValue];
    
    if (_loginObj.success) {
        _loginObj.session_id = (NSString *)[parserData objectForKey:kSessionId];
            
        
            //id
       // g_cookies = [[g_cookies stringByReplacingOccurrencesOfString:@"deleted" withString:_loginObj.session_id] retain]; 
        g_cookies = [_loginObj.session_id retain];
        
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_OK object:nil];
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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_ERROR object:nil];
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
	
	SAFE_RELEASE(_loginObj);
	SAFE_RELEASE(receivedData);

	[super dealloc];
}


@end
