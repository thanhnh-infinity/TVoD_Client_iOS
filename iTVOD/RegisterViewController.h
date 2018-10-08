
//  RegisterViewController.h
//  iTVOD

//  Created by vivas-mac on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "RegisterParser.h"
#import "MBProgressHUD.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITextField *txtUserRegis;
    IBOutlet UITextField *txtPassRegis;
    IBOutlet UITextField *txtConfirmPassRegis;
    
    RegisterParser *_registerParser;
    MBProgressHUD *HUD;
}
-(IBAction)back:(id)sender;
-(IBAction)registerAcount:(id)sender;
- (BOOL) validateEmail: (NSString *) candidate;
-(void)requestRegister:(NSString *)user_name password:(NSString *)password;
@end
