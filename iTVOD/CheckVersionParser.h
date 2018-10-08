
//  ChechVersionParser.h
//  iTVODForiPad

//  Created by vivas-mac on 10/11/12.



#import <Foundation/Foundation.h>
#import "JSON.h"
#import "CheckVersionObj.h"

@interface CheckVersionParser : NSObject
{
    CheckVersionObj *_checkVersionObj;
    NSMutableData *receivedData;
    
}

@property (nonatomic, retain) CheckVersionObj *_checkVersionObj;
- (BOOL) parserWithJSONLink:(NSString*) strLink;
-(void)initData;
@end
