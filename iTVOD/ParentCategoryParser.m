
//  ParentCategoryParser.m
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ParentCategoryParser.h"

@implementation ParentCategoryParser
@synthesize _listParentCategoryObj;

- (id) init{
    
	
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	
	_listParentCategoryObj = nil;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:GET_PARENT_CATEGORY_CONNECTION_FAILED object:nil];
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
	
	
	
	_listParentCategoryObj = [[ListParentCategoryObj alloc] init];
	
	_listParentCategoryObj.success = [[parserData objectForKey:kSuccess] boolValue];
    
    if (_listParentCategoryObj.success) {
        _listParentCategoryObj.quantity = (NSString *)[parserData objectForKey:kQuantity];
        
        _listParentCategoryObj.lstParentCategories = [[NSMutableArray alloc] init];
        
        NSArray *_lstItems = [parserData objectForKey:kItems];
        
        for (NSDictionary *d in _lstItems) {
            ParentCategoryObj *obj = [[ParentCategoryObj alloc] init];
            obj.category_id = (NSString *)[d objectForKey:kCategoryId];
            obj.category_image = (NSString *)[d objectForKey:kCategoryImage];
            obj.category_name = (NSString *) [d objectForKey:kCategoryName];
            
            [_listParentCategoryObj.lstParentCategories addObject:obj];
            [obj release];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_PARENT_CATEGORY_OK object:nil];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_PARENT_CATEGORY_ERROR object:nil];
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
    
	SAFE_RELEASE(_listParentCategoryObj.lstParentCategories);
	SAFE_RELEASE(_listParentCategoryObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}

@end
