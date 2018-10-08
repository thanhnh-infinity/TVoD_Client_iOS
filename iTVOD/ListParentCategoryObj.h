
//  ListParentCategoryObj.h
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import "ParentCategoryObj.h"

@interface ListParentCategoryObj : NSObject
{
    BOOL success;
    NSString *quantity;
    NSMutableArray *lstParentCategories;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, retain) NSMutableArray *lstParentCategories;
@end
