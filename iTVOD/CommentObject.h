
//  CommentObject.h
//  iTVOD

//  Created by Do Thanh Nam on 30/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import <Foundation/Foundation.h>

@interface CommentObject : NSObject {
    NSString * comment_id;
    NSString * user_id;
    NSString * name; //user name
    NSString * subject;
    NSString * body_value;
}
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body_value;
@end
