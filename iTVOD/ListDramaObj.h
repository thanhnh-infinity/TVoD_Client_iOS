
//  ListDramaObj.h
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface ListDramaObj : NSObject
{
    NSString *success;
    NSString *quantity;
    NSString *total_quantity;
    NSMutableArray *lstDrama;
}
@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *total_quantity;
@property (nonatomic, retain) NSMutableArray *lstDrama;
@end
