
//  ParentCategoryObj.h
//  iTVOD

//  Created by vivas-mac on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface ParentCategoryObj : NSObject
{
    NSString *category_id;
    NSString *category_image;
    NSString *category_name;
}
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *category_image;
@property (nonatomic, copy) NSString *category_name;
@end
