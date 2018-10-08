
//  ChildCategoryObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "CategoryObject.h"

@interface ChildCategoryObject : NSObject
{
    BOOL success;
    NSString *quantity;
    NSMutableArray *lstItems;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, retain) NSMutableArray *lstItems;
@end
