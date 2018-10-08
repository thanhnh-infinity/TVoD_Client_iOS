
//  AddToFavorite.h
//  iTVOD

//  Created by Do Thanh Nam on 29/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.



#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ErrorObj.h"

@interface AddToFavoriteParser : NSObject
{
    NSMutableData *receivedData;
}

- (BOOL) parserWithJSONLink:(NSString*) strLink;

@end
