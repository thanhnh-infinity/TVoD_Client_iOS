
//  DramaObj.h
//  iTVOD

//  Created by vivas-mac on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

@interface DramaObj : NSObject
{
    NSString *drama_id;
    NSString *drama_english_title;
    NSString *drama_vietnamese_title;
    NSString *drama_quantity;
    NSString *drama_image_path;
}
@property (nonatomic,copy) NSString *drama_id;
@property (nonatomic,copy) NSString *drama_english_title;
@property (nonatomic,copy) NSString *drama_vietnamese_title;
@property (nonatomic,copy) NSString *drama_quantity;
@property (nonatomic,copy) NSString *drama_image_path;
@end
