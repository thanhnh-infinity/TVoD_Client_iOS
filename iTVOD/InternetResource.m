/******************************************************************************
 * Copyright (c) 2010, Maher Ali <maher.ali@gmail.com>
 * Advanced iOS 4 Programming: Developing Mobile Applications for Apple iPhone, iPad, and iPod touch
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/

#import "InternetResource.h"


@implementation InternetResource

@synthesize  image_string, url, title, image, status, receiver;

-(id)initWithTitle:(NSString*)_title andURL:(NSString*)_url{
	if(self = [super init]){
		self.title = _title;
		
		
		
		self.url = _url;
		self.status = NEW;
		
	}
    
	return self;
}

-(void)start{
    
	self.status = FETCHING;
	receivedData = [[NSMutableData data] retain];
	[NSThread detachNewThreadSelector:@selector(fetchURL) toTarget:self withObject:nil];
    
}

-(void)fetchURL {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
	[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	[[NSRunLoop currentRunLoop ] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:60]];
	[pool release];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	int statusCode = ((NSHTTPURLResponse*) response).statusCode;
	if(statusCode != 200)
	{
		self.status = FAILED;
	}
	
	[receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[connection release];
	
	if(receivedData)
	{
		[receivedData release];
		receivedData = nil;
	}
	
    self.status = FAILED;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	if(self.status != FAILED)
	{
		self.status = COMPLETE;
		self.image = [UIImage imageWithData:receivedData];
		
		
		[receivedData release];
		receivedData = nil;
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FinishedLoadingLinkImage object:self.receiver];
	
	[connection release]; 
    
}          

-(void)dealloc{
	
	if(receivedData)
	{
		[receivedData release];
	}
//    [conn release];
	self.title = nil;
	self.url = nil;
	self.image = nil;
	[super dealloc];
    
}
@end
