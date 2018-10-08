
//  UserViewController.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "UserDetailParser.h"
#import "LoginParser.h"
#import "LogoutParser.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "MBProgressHUD.h"

#import "ExpandParser.h"
#import "ListFavoriteParser.h"
#import "ListBoughtParser.h"

@class AppDelegate;

#define ACTIONSHEET_EXPAND 1;
#define ACTIONSHEET_TOPUP 2;
@interface UserViewController : UIViewController<UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    
    IBOutlet UILabel *lblPaymentMethod;
    IBOutlet UILabel *lblGroupUser;
    
    IBOutlet UILabel *lblSuccess;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblBallance;
    IBOutlet UILabel *lblSubscriber;
    
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIButton *btnLogout;
    IBOutlet UILabel *lblLogout;
    
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIView *loginView;
    IBOutlet UIView *userInfoView;
    
    IBOutlet UIView *listBoughtView;
    IBOutlet UIView *listFavoriteView;
    
    IBOutlet UITableView *tblListFavorite;
    NSMutableArray *lstFavoriteResources;
    NSMutableArray *lstBoughtResources;
    IBOutlet UITableView *tblListBought;
    IBOutlet UIButton *btnBack;
    
   // IBOutlet UITableView *tblUserInfo;
    IBOutlet UIButton *btnCheck;
    
    NSMutableArray *lstUserInfo;
    BOOL isChecked;
    
    
    UserDetailParser *_userDetailParser;
    ListFavoriteParser *listFavoriteParser;
    ListBoughtParser *listBoughtParser;
    
    NSMutableArray *lstVideoItems;
    NSMutableArray *lstBoughtItems;
    
    LoginParser *_loginParser;
    LogoutParser *_logoutParser;
    
    ExpandParser *_expandParser;
    
    MBProgressHUD *HUD;
    
    AppDelegate *_appDelegate;
    
    BOOL isFromMovieDetail;
    
    NSString *m_uid;
    
    BOOL isLogout;
    
}
@property (nonatomic, assign) BOOL isFromMovieDetail;

-(IBAction)back:(id)sender;
-(IBAction)logout:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)changeToRegister:(id)sender;
-(IBAction)check:(id)sender;
-(IBAction)topup:(id)sender;
-(IBAction)expandExpiredDate:(id)sender;

-(IBAction)switchPersonalTab:(id)sender;

-(void)saveAccountInfo;
-(void)getSavedAccountInfo;
-(void)requestGetUserDetail;
-(void)preSetup;
-(void)removeAccountInfo;

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
-(void)requestLogin:(NSString *)user_name password:(NSString *)password;
-(void)requestLogout;
@end
