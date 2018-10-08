
//  UserDetailObject.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

/*
 {
 "success": true,
 "uid": "146", -> ma tai khoan 
 "name": "chinhnk", -> ten tai khoan x
 "email": "chinhnk@vivas.vn",
 "balance": "10", -> so du x
 "payment_method": "0", -> hinh thuc thue bao -> anything: truoc, 1: sau
 "group_user": "Basic 1", -> goi thue bao
 "subcriber": "27-10-2050" -> han thue bao x
 }
 */
@interface UserDetailObject : NSObject
{
    BOOL success;
    
    NSString *uid;
    NSString *name;
    NSString *email;
    NSString *ballance;
    NSString *subscriber;
    NSString *payment_method;
    NSString *group_user;
    
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *ballance;
@property (nonatomic, copy) NSString *subscriber;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *payment_method;
@property (nonatomic, copy) NSString *group_user;

@end
