//
//  BoughtObject.h
//  iTVOD
//
//  Created by Do Thanh Nam on 05/01/2013.
//  Copyright (c) 2013 Edoo Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoughtObject : NSObject

@property (nonatomic,copy) NSString *transaction_id;
@property (nonatomic,copy) NSDate   *transaction_date;
@property (nonatomic,copy) NSString *transaction_value;
@property (nonatomic,copy) NSString *stop_time;
@property (nonatomic,copy) NSString *content_picture_path;
@property (nonatomic,copy) NSString *content_id;
@property (nonatomic,copy) NSString *content_name;

@end
