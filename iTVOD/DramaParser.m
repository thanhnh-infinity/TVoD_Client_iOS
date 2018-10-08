
//  DramaParser.m
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "DramaParser.h"

@implementation DramaParser
@synthesize _listDramaObj;

- (id) init{
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	_listDramaObj = nil;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:GET_LIST_DRAMA_CONNECTION_FAILED object:nil];
    
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
	
	
	
	_listDramaObj = [[ListDramaObj alloc] init];
	
	_listDramaObj.success = [parserData objectForKey:kSuccess];
    if (_listDramaObj.success) {
        _listDramaObj.quantity = (NSString *)[parserData objectForKey:kQuantity];
        _listDramaObj.total_quantity = [parserData objectForKey:kTotalQuantity];
        _listDramaObj.lstDrama = [[NSMutableArray alloc] init];
        
        NSArray *_lstItems = [parserData objectForKey:kItems];
        
        for (NSDictionary *d in _lstItems) {
            DramaObj *obj = [[DramaObj alloc] init];
            obj.drama_id = (NSString *)[d objectForKey:kDramaId];
            obj.drama_english_title = (NSString *)[d objectForKey:kDramaEnTitle];
            obj.drama_vietnamese_title  = (NSString *) [d objectForKey:kDramaViTitle];
            obj.drama_image_path = (NSString *)[d objectForKey:kDramaImagePath];
            obj.drama_quantity = (NSString *)[d objectForKey:kDramaQuantity];
            
            [_listDramaObj.lstDrama addObject:obj];
            [obj release];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_LIST_DRAMA_OK object:nil];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_LIST_DRAMA_ERROR object:nil];
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
    SAFE_RELEASE(_listDramaObj.lstDrama)
	SAFE_RELEASE(_listDramaObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}
@end
