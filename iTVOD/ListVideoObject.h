
//  ListVideoObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "VideoObject.h"

@interface ListVideoObject : NSObject
{
    BOOL success;
    int quantity;
    int total_quantity;
    NSString *_type;
    NSMutableArray *lstVideoItems;
}
@property (nonatomic,assign)BOOL success;
@property (nonatomic, assign) int quantity;
@property (nonatomic, assign) int total_quantity;
@property (nonatomic, copy) NSString *_type;
@property (nonatomic, assign) NSMutableArray *lstVideoItems;
@end
