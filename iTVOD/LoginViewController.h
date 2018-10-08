
//  LoginViewController.h
//  iTVOD

//  Created by vivas-mac on 12/3/12.



#import <UIKit/UIKit.h>
#import "UserViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "LogoutParser.h"
#import "LoginParser.h"

@interface LoginViewController : UIViewController<UITabBarControllerDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPass;
    
    IBOutlet UIButton *btnCheck;
    BOOL isChecked;
    
    UITabBarController *tbControl;
    
    MBProgressHUD *HUD;
    
    LogoutParser *_logoutParser;
    
    LoginParser *_loginParser;
    
}
@property (nonatomic, retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPass;
@property (nonatomic, assign) BOOL isChecked;
-(IBAction)performLogin:(id)sender;
-(IBAction)performRegister:(id)sender;
- (IBAction)checkRemember:(id)sender;

-(void)displayView;
-(void)startLoading;
-(void)stopLoading;
-(void)getSavedAccountInfo;
@end
