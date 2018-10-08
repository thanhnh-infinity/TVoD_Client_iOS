
//  AppDelegate.h
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "LoginParser.h"
#import "LogoutParser.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    BOOL isLogin;
    UITabBarController *tbControl;
    NSString *m_username;
    NSString *m_password;
    
    LoginParser *_loginParser;
    LogoutParser *_logoutParser;
    UIImageView *imgView;
    
    UINavigationController *nav;
    LoginViewController *_loginViewCtrl;
}
@property (nonatomic, retain) UINavigationController *nav;
@property (nonatomic, retain) LoginViewController *_loginViewCtrl;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isLogin;
-(BOOL)getSavedAccInfo;
-(void)setupView;

-(void)requestLogout;

@end
