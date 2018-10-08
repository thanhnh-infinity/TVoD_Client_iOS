//
//  ListBoughtParser.m
//  iTVOD
//
//  Created by Do Thanh Nam on 05/01/2013.
//  Copyright (c) 2013 Edoo Corp. All rights reserved.
//

#import "ListBoughtParser.h"

@implementation ListBoughtParser
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LIST_BOUGHT_FAILED object:nil];
    
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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LIST_BOUGHT_ERROR object:nil];
    }
	else {
        
        NSDictionary *parserData = [json_string JSONValue];
        if (!parserData){
            [[NSNotificationCenter defaultCenter]postNotificationName:LIST_BOUGHT_ERROR object:nil];            
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

            
            if ([_listVideoObj._type isEqualToString:kTypeTransaction]) {
                for (NSDictionary *d in _lstItems) {
                    BoughtObject *obj = [[BoughtObject alloc] init];
                    obj.transaction_id = (NSString *)[d objectForKey:ktransaction_id];
                    obj.transaction_date = (NSDate *)[d objectForKey:ktransaction_date];
                    obj.transaction_value = (NSString *)[d objectForKey:ktransaction_value];
                    obj.stop_time = (NSString *)[d objectForKey:kstop_time];
                    obj.content_picture_path = (NSString *) [d objectForKey:kcontent_picture_path];
                    obj.content_id = (NSString *) [d objectForKey:kcontent_id];
                    obj.content_name = (NSString *) [d objectForKey:kcontent_name];
                    [_listVideoObj.lstVideoItems addObject:obj];
                    [obj release];
                }
            }
                        
            [[NSNotificationCenter defaultCenter] postNotificationName:LIST_BOUGHT_OK object:nil];
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
            
            [[NSNotificationCenter defaultCenter]postNotificationName:LIST_BOUGHT_ERROR object:nil];
            
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
