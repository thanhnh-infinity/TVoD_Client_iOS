
//  CategoryObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject
{
    NSString *category_id;
    NSString *category_image;
    NSString *category_name;
    int number_video_category;
}
@property (nonatomic, assign) int number_video_category;
@property (nonatomic, copy)  NSString *category_id;
@property (nonatomic, copy)  NSString *category_image;
@property (nonatomic, copy)  NSString *category_name;

@end
