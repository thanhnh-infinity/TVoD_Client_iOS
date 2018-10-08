
//  AddToFavorite.m
//  iTVOD

//  Created by Do Thanh Nam on 29/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "AddToFavorite.h"


@implementation AddToFavoriteParser

- (id) init{
	if (self = [super init]) {
        receivedData = nil;
	}
	return self;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_TO_FAVORITE_FAILED object:nil];
    
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
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ADD_TO_FAVORITE_ERROR object:nil];
    }
	else {
        
        NSDictionary *parserData = [json_string JSONValue];
        if (!parserData){
            [[NSNotificationCenter defaultCenter]postNotificationName:ADD_TO_FAVORITE_ERROR object:nil];            
            return;
        }
        
        if ([[parserData objectForKey:kSuccess] boolValue]){
            [[NSNotificationCenter defaultCenter]postNotificationName:ADD_TO_FAVORITE_OK object:nil];
        } else {
//            ErrorObj *_errObj = [[ErrorObj alloc] init];
//            _errObj.reason = [parserData objectForKey:kReason];
//            _errObj.type = [parserData objectForKey:kType];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: _errObj.type message: _errObj.reason delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
//            [alert release];
//            [_errObj release];
            [[NSNotificationCenter defaultCenter]postNotificationName:ADD_TO_FAVORITE_ERROR object:nil];            
        }
    }
    
    //free data
	[json_string release];
    //[parser release];	
	
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
