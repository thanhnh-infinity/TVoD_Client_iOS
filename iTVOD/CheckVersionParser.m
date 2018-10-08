
//  ChechVersionParser.m
//  iTVODForiPad

//  Created by vivas-mac on 10/11/12.



#import "CheckVersionParser.h"

@implementation CheckVersionParser
@synthesize _checkVersionObj;
- (id) init{
	if (self = [super init]) {
		[self initData];
	}
	return self;
}

- (void) initData{
	_checkVersionObj = nil;
}


- (BOOL) parserWithJSONLink:(NSString*) strLink{
	// Create SBJSON object to parse JSON
	receivedData = [[NSMutableData data ] retain];
	
	// Perform request and get JSON back as a NSData object
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strLink]];
    [theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [pool release];
	
	return YES;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
	SAFE_RELEASE(receivedData);
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
	
	
    _checkVersionObj = [[CheckVersionObj alloc] init];
    _checkVersionObj.success = [[parserData objectForKey:kSuccess] boolValue];
    _checkVersionObj.current_version = (NSString *)[parserData objectForKey:@"version"];
    _checkVersionObj.link_update = (NSString *)[parserData objectForKey:@"link_update"];
	if (_checkVersionObj.success == TRUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_VERSION_OK object:nil];
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
	SAFE_RELEASE(_checkVersionObj);
	SAFE_RELEASE(receivedData);
    
	[super dealloc];
}
@end
