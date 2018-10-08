
//  UserViewController.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "UserViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

@implementation UserViewController
@synthesize isFromMovieDetail;

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TVOD_LIST_FAVORITE_CONTENTS object:nil];

    
    SAFE_RELEASE(m_uid);
    SAFE_RELEASE(lstVideoItems);
    SAFE_RELEASE(lstFavoriteResources);
    
    [lblPaymentMethod release];
    [lblGroupUser release];
    [listFavoriteView release];
    [tblListFavorite release];
    [listBoughtView release];
    [tblListBought release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)preSetup
{
    loginView.hidden = YES;
    userInfoView.hidden = NO;
    btnLogout.hidden = NO;
    lblLogout.hidden = NO;
    lblTitle.text = @"Thông tin cá nhân";
    self.title = @"Cá nhân";
    self.navigationController.tabBarItem.image=[UIImage imageNamed:@"user.png"];
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isLogout = FALSE;
    
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];


    segmentControl.selectedSegmentIndex = 0;
    userInfoView.hidden = NO;
    listFavoriteView.hidden = YES;
    listBoughtView.hidden = YES;
    listFavoriteView.backgroundColor = [UIColor clearColor];
    
    tblListFavorite.delegate = self;
    tblListFavorite.dataSource = self;
    tblListFavorite.backgroundColor = [UIColor clearColor];

    lstFavoriteResources = [[NSMutableArray alloc] init];
    lstVideoItems = [[NSMutableArray alloc] init];
    lstBoughtItems = [[NSMutableArray alloc] init];
    lstBoughtResources = [[NSMutableArray alloc] init];
    
    tblListBought.delegate = self;
    tblListBought.dataSource  = self;
    tblListBought.backgroundColor = [UIColor clearColor];
    
    loginView.backgroundColor = [UIColor clearColor];
    userInfoView.backgroundColor = [UIColor clearColor];
    listBoughtView.backgroundColor = [UIColor clearColor];
    
   // tblUserInfo.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    txtUsername.delegate = self;
    txtPassword.delegate = self;
    txtUsername.backgroundColor = [UIColor clearColor];
    txtPassword.backgroundColor = [UIColor clearColor];
    isChecked = TRUE;
    
    if (self.isFromMovieDetail == TRUE) {
        btnBack.hidden = FALSE;
    }
    else {
        btnBack.hidden = TRUE;
    }
//    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//     if (_appDelegate.isLogin == TRUE) {
//         [self requestGetUserDetail];
//     }
    
    [self requestGetUserDetail];
}
-(void)viewWillAppear:(BOOL)animated
{
        
    //get user detail
    if (g_isRefreshGetUserDetail == TRUE) {
         [self requestGetUserDetail];
        g_isRefreshGetUserDetail = FALSE;
    }
}

- (void)viewDidUnload
{
    [lblPaymentMethod release];
    lblPaymentMethod = nil;
    [lblGroupUser release];
    lblGroupUser = nil;
    [listFavoriteView release];
    listFavoriteView = nil;
    [tblListFavorite release];
    tblListFavorite = nil;
    [listBoughtView release];
    listBoughtView = nil;
    [tblListBought release];
    tblListBought = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
   // return YES;
}

#pragma mark -
#pragma mark NSUserDefault 
-(void)saveAccountInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:txtUsername.text forKey:@"username"];
    [defaults setObject:txtPassword.text forKey:@"password"];
    
    [defaults synchronize];
}
-(void)removeAccountInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"" forKey:@"username"];
    [defaults setObject:@"" forKey:@"password"];
    
    [defaults synchronize];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }

    
   // [self clearCredentialStorage];

}
-(void)getSavedAccountInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    
    
}

#pragma mark - 
#pragma mark request user detail

- (void) setupGetUserDetailObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserDetailOK) name:GET_USER_DETAIL_OK object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserDetailError) name:GET_USER_DETAIL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserDetailConnectionFailed) name:GET_USER_DETAIL_CONNECTION_FAILED object:nil];
}
- (void) removeGetUserDetailObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_USER_DETAIL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_USER_DETAIL_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_USER_DETAIL_CONNECTION_FAILED object:nil];

}

-(void)requestGetUserDetail
{
    [self setupGetUserDetailObservers];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    _userDetailParser = [[UserDetailParser alloc] init];
    [_userDetailParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_USER_PROFILE]];
}
-(void)getUserDetailConnectionFailed
{
    [self stopLoading];
    [self removeGetUserDetailObservers];
}
-(void)getUserDetailError
{
    self.title = @"Đăng nhập";
    
    userInfoView.hidden = YES;
    btnLogout.hidden = YES;
    lblLogout.hidden = YES;
    
    loginView.hidden = NO;
    
    [self stopLoading];
    [self removeGetUserDetailObservers];
}
-(void)getUserDetailOK
{
    
    [self stopLoading];
    [self removeGetUserDetailObservers];
        
    NSString *name = [NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.name];
    NSString *email = [NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.email];
    NSString *ballance = [NSString stringWithFormat:@"%@ xu",_userDetailParser._userDetailObj.ballance];
    NSString *subscriber = [NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.subscriber];
    m_uid = [[NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.uid] retain];
    
    NSString *group_user = [NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.group_user];
    NSString *payment_method = [NSString stringWithFormat:@"%@",_userDetailParser._userDetailObj.payment_method];
    
    
    
    
    
    
    
    

    lblGroupUser.text = group_user;
        
    lblPaymentMethod.text = ([payment_method isEqualToString:@"1"]) ? @"Trả sau" : @"Trả trước";
            
    lblEmail.text = email;
    
    
    lblBallance.text = ballance;
    
    lblSubscriber.text = subscriber;
    
    lblUserName.text = name;
    
    //if (_appDelegate.isLogin == FALSE) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //[UIView setAnimationDelay:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:loginView cache:YES];
        
        loginView.hidden = YES;
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //[UIView setAnimationDelay:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:userInfoView cache:YES];
        
        userInfoView.hidden = NO;
        btnLogout.hidden = NO;
        lblLogout.hidden = NO;
        lblTitle.text = @"Thông tin cá nhân";
        self.title = @"Cá nhân";
        self.navigationController.tabBarItem.image=[UIImage imageNamed:@"user.png"];
        
        [UIView commitAnimations];

}

#pragma mark -
#pragma mark login
-(void)requestLogin:(NSString *)user_name password:(NSString *)password
{
    NSString *strLogin = [NSString stringWithFormat:TVOD_LOGIN,user_name,password];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK) name:LOGIN_OK object:nil]; 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginError) name:LOGIN_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionError) name:LOGIN_CONNECTION_ERROR object:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    _loginParser = [[LoginParser alloc] init];
    [_loginParser parserWithJSONLink:strLogin];
}
-(void)connectionError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    _appDelegate.isLogin = FALSE;
    isLogout = FALSE;
}
-(void)loginError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    
    
    _appDelegate.isLogin = FALSE;
    isLogout = FALSE;

    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
-(void)loginOK
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    _appDelegate.isLogin = TRUE;
    
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    if (isChecked) {
        [self saveAccountInfo];
    }
    
    //get user detail
    if (isFromMovieDetail) {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Đăng nhập thành công" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
    [self requestGetUserDetail];
    
}

#pragma mark -
#pragma mark logout
-(void)requestLogout
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOK) name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutError) name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutConnectionFailed) name:LOGOUT_CONNECTION_FAILED object:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    _logoutParser = [[LogoutParser alloc] init];
    [_logoutParser parserWithJSONLink:TVOD_LOGOUT];
}
-(void)logoutConnectionFailed
{

    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    isLogout = FALSE;
    [_logoutParser release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
}
-(void)logoutOK
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
    
    _appDelegate.isLogin = FALSE;
    if (isLogout == FALSE) {
        isLogout = TRUE;
        NSString *strName = txtUsername.text;
        NSString *strPass = txtPassword.text;
        
        
        
        
        [self requestLogin:strName password:strPass];
    }
    else
    {
        isLogout = FALSE;
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        

        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //[UIView setAnimationDelay:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:loginView cache:YES];
        loginView.hidden = NO;
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //[UIView setAnimationDelay:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:userInfoView cache:YES];
        btnLogout.hidden = YES;
        lblLogout.hidden = YES;
        userInfoView.hidden = YES;
        txtUsername.text = @"";
        txtPassword.text = @"";
        
        self.title = @"Đăng nhập";
        self.navigationController.tabBarItem.image=[UIImage imageNamed:@"dangnhap.png"];
        [UIView commitAnimations];
        
        [self removeAccountInfo];
        
    }
    [_logoutParser release];
}

-(void)logoutError
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    isLogout = FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
    [_logoutParser release];
}
#pragma mark -
#pragma mark IBAction
-(IBAction)logout:(id)sender
{
    
    isLogout = TRUE;
    [self requestLogout];
}
-(IBAction)login:(id)sender
{
    
    
    
    //do login
    if (isLogout == FALSE) {
        [self requestLogout];
    }
    
    
    
}
-(IBAction)changeToRegister:(id)sender
{
    
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
-(IBAction)check:(id)sender
{
    
    if (isChecked == false) {
        [btnCheck setImage:[UIImage imageNamed:@"btnCheckBoxActive"] forState:UIControlStateNormal];
        isChecked = true;
    }
    else
    {
        [btnCheck setImage:[UIImage imageNamed:@"btnCheckBox"] forState:UIControlStateNormal];
        isChecked = false;
    }
    
}

-(IBAction)expandExpiredDate:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Gia hạn" delegate:self cancelButtonTitle:@"Bỏ qua" destructiveButtonTitle:nil otherButtonTitles:@"3 ngày sử dụng (45 xu)",@"10 ngày sử dụng (120 xu)",@"30 ngày sử dụng (320 xu)",nil];
    actionSheet.tag = ACTIONSHEET_EXPAND;
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    [actionSheet release];
}
#pragma mark -
#pragma mark SMS nap tien
-(IBAction)topup:(id)sender
{
    
    
   //  [self sendSMS:@"Topup 15" recipientList:[NSArray arrayWithObjects:@"Abc", nil]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Nạp tiền" delegate:self cancelButtonTitle:@"Bỏ qua" destructiveButtonTitle:nil otherButtonTitles:@"Trọn gói 3 ngày (15000 VND)",@"Nạp 45 xu (15000 VND)", nil];
    actionSheet.tag = ACTIONSHEET_TOPUP;
    
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    [actionSheet release];
    
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;    
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
    {
        
    }
    else if (result == MessageComposeResultSent)
    {
        
        [self requestGetUserDetail];
    }
    else 
    {
        
    }
}
#pragma mark -
#pragma mark UIActionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strSMS = @"";
    int actionsheetTag = actionSheet.tag;
    int actionsheet_topup = ACTIONSHEET_TOPUP;
    int actionsheet_expand = ACTIONSHEET_EXPAND;
    
    if (actionsheetTag == actionsheet_topup) {
        switch (buttonIndex) {
            case 0:
                
                
                strSMS = [NSString stringWithFormat:@"TB %@",m_uid];
                [self sendSMS:strSMS recipientList:[NSArray arrayWithObjects:@"6780", nil]];
                break;
            case 1:
                
                
                strSMS = [NSString stringWithFormat:@"NAP %@",m_uid];
                [self sendSMS:strSMS recipientList:[NSArray arrayWithObjects:@"6780", nil]];
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                break;
        }
    }
    else if(actionsheetTag == actionsheet_expand)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandOK) name:EXPAND_OK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandError) name:EXPAND_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandConnectionFailed) name:EXPAND_CONNECTION_FAILED object:nil];
        
        BOOL isRequestExpand = FALSE;
        
        NSString *strRequest = @"";
        switch (buttonIndex) {
            case 0:
                
                //30 xu
                isRequestExpand = TRUE;
                strRequest = [NSString stringWithFormat:TVOD_EXPAND_EXPIRED_DATE,1];
                
                break;
            case 1:
                
                isRequestExpand = TRUE;
                strRequest = [NSString stringWithFormat:TVOD_EXPAND_EXPIRED_DATE,2];
                
                break;
            case 2:
                
                isRequestExpand = TRUE;
                strRequest = [NSString stringWithFormat:TVOD_EXPAND_EXPIRED_DATE,3];
                
                break;
            case 3:
                
                isRequestExpand = FALSE;
                break;
            case 4:
                isRequestExpand = TRUE;
                strRequest = [NSString stringWithFormat:TVOD_EXPAND_EXPIRED_DATE,5];
                
                break;
            default:
                isRequestExpand = FALSE;
                break;
        }
        
        if (isRequestExpand == TRUE) {
            _expandParser = [[ExpandParser alloc] init];
            [_expandParser parserWithJSONLink:strRequest];
        }
       

    }
}
-(void)expandOK
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_CONNECTION_FAILED object:nil];
    [self requestGetUserDetail];
    
}
-(void)expandError
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_CONNECTION_FAILED object:nil];
   
}
-(void)expandConnectionFailed
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXPAND_CONNECTION_FAILED object:nil];
}
- (void) switchPersonalTab:(id)sender {
    int i = [segmentControl selectedSegmentIndex];
//    userInfoView.hidden = i;
//    listFavoriteView.hidden = i;
    switch (i) {
        case 0:
            // thong tin chi tiet
            userInfoView.hidden = NO;
            listFavoriteView.hidden = YES;
            listBoughtView.hidden = YES;
            break;
        case 1:
            // danh sach uu thich
            userInfoView.hidden = YES;
            listFavoriteView.hidden = NO;
            listBoughtView.hidden = YES;
            [self showListFavorite];
            break;
        case 2:
            // danh sach da mua
            userInfoView.hidden = YES;
            listFavoriteView.hidden = YES;
            listBoughtView.hidden = NO;    
            [self showListBought];
            break;
        default:
            break;
    }
}
//========
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
	[self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
}
-(void)reloadTable:(InternetResource*)_resource{
    if (segmentControl.selectedSegmentIndex == 1) {
        [tblListFavorite reloadData];
    } else {
        [tblListBought reloadData];
    }
}
//========
- (void) showListFavorite {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_LIST_FAVORITE_CONTENTS];
    
    [self setupListFavoriteObservers];
    [self startLoading];
    listFavoriteParser = [[ListFavoriteParser alloc] init];
    NSString *strRequest = @"";
    strRequest = [NSString stringWithFormat:TVOD_LIST_FAVORITE_CONTENTS,1];
    [listFavoriteParser parserWithJSONLink:strRequest];
}


- (void) showListBought {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_BOUGHT];
    
    [self setupListBoughtObservers];
    [self startLoading];
    listBoughtParser = [[ListBoughtParser alloc] init];
    NSString *strRequest = @"";

    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];

    strRequest = [NSString stringWithFormat:TVOD_GET_LIST_BOUGHT,1,dateString];
    [listBoughtParser parserWithJSONLink:strRequest];
    [formatter release];    
}

- (void) setupListBoughtObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListBoughtOK) name:LIST_BOUGHT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListBoughtError) name:LIST_BOUGHT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListBoughtFailed) name:LIST_BOUGHT_FAILED object:nil];
}

- (void) removeListBoughtObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_BOUGHT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_BOUGHT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_BOUGHT_ERROR object:nil];
}

- (void) getListFavoriteOK {
    [self removeListFavoriteObservers];
    [self stopLoading];

    // show data on table favorite
    lstVideoItems = [listFavoriteParser._listVideoObj.lstVideoItems retain];
    for (int i = 0; i < [lstVideoItems count]; i++) {
        VideoObject *obj = [lstVideoItems objectAtIndex:i];
        InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
        iResource.receiver = TVOD_LIST_FAVORITE_CONTENTS;
        [lstFavoriteResources addObject:iResource];
        
    }
    
    if (listFavoriteParser) [listFavoriteParser release];
    
    [tblListFavorite reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [lstVideoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
    InternetResource *iResource = nil;
    
    if (segmentControl.selectedSegmentIndex == 1) {
        
        VideoObject *obj = nil;
        
        obj = [lstVideoItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",obj.video_english_title];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@\nSố lượt xem : %@",obj.video_vietnamese_title,obj.video_number_views];
        
        if ([lstFavoriteResources count] >=(indexPath.row +1)) {
            iResource = [lstFavoriteResources objectAtIndex:indexPath.row];              
        }    
        
    } else if (segmentControl.selectedSegmentIndex == 2) {
        BoughtObject *bobj = nil;
        
        bobj = [lstBoughtItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",bobj.content_name];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"Gía %@ xu\nMua: %@\n%@", bobj.transaction_value ,  bobj.transaction_date, ((bobj.stop_time) ? bobj.stop_time : @"Đã xem hết") ];
        
        if ([lstBoughtResources count] >=(indexPath.row +1)) {
            iResource = [lstBoughtResources objectAtIndex:indexPath.row];              
        }
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
    cell.accessoryView = imageView;
    [imageView release];
    
    if (iResource != nil) {
        @synchronized(iResource){
            switch (iResource.status) {
                case NEW:
                {
                cell.imageView.image = [UIImage imageNamed:@"loading.png"];
                [iResource start];
                }
                    break;
                case COMPLETE:
                {
                cell.imageView.image = iResource.image;
                }
                    break;
                case FAILED:	
                    cell.imageView.image = [UIImage imageNamed:@"no_image.png"];
                    break;
                case FETCHING:
                    cell.imageView.image = [UIImage imageNamed:@"loading.png"];
                    break;
                default:
                    break;
            }
        }
    }

    
//    if ([lstVideoItems count]>=5){
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [tableView setSeparatorColor:[UIColor grayColor]];
//    
//    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InternetResource *objResource;
    if (segmentControl.selectedSegmentIndex == 1) {
        
        VideoObject *obj;
        
        obj = [lstVideoItems objectAtIndex:indexPath.row];
        objResource = [lstFavoriteResources objectAtIndex:indexPath.row];
        
        NSString *strTitle = obj.video_english_title;
        NSString *strVietnameseTitle = obj.video_vietnamese_title;
        int intTmpDuration = [obj.video_duration intValue];
        
        int duration_minutes = ceil(intTmpDuration*1.0/60);
        
        NSString *duration = [NSString stringWithFormat:@"Thời lượng : %d phút",duration_minutes];
        
        NSString *numberViews = [NSString stringWithFormat:@"Số lượt xem : %@",obj.video_number_views];
        NSString *price = [NSString stringWithFormat:@"%@ xu",obj.video_price];
        NSString *description = [NSString stringWithFormat:@"%@",obj.video_description];
        NSString *_id = [NSString stringWithFormat:@"%@",obj.video_id];
        
        UIImage *img = objResource.image;
        
        MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:strTitle vietnameseTitle:strVietnameseTitle videoId:_id image:img numberViews:numberViews duration:duration price:price description:description];
        
        [img release];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    
    } else {
        BoughtObject *bobj;
        
        bobj = [lstBoughtItems objectAtIndex:indexPath.row];
        objResource = [lstBoughtResources objectAtIndex:indexPath.row];
        
        NSString *strTitle = bobj.content_name;
        NSString *strVietnameseTitle = bobj.content_name;
        
        NSString *duration = @"";
        
        NSString *numberViews = @"";
        NSString *price = [NSString stringWithFormat:@"%@ xu",bobj.transaction_value];
        NSString *description = @"";
        NSString *_id = [NSString stringWithFormat:@"%@",bobj.content_id];
        
        UIImage *img = objResource.image;
        
        MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:strTitle vietnameseTitle:strVietnameseTitle videoId:_id image:img numberViews:numberViews duration:duration price:price description:description];
        
        [img release];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } 
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (void) getListFavoriteFailed {
    [self stopLoading];
    [self removeListFavoriteObservers];

}
- (void) getListFavoriteError {
    [self stopLoading];
    [self removeListFavoriteObservers];
}
- (void) bringMessage:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}
- (void) setupListFavoriteObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListFavoriteOK) name:LIST_FAVORITE_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListFavoriteError) name:LIST_FAVORITE_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListFavoriteFailed) name:LIST_FAVORITE_FAILED object:nil];
}
- (void) removeListFavoriteObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_FAVORITE_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_FAVORITE_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIST_FAVORITE_ERROR object:nil];
}

- (void) stopLoading {
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
- (void) startLoading {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
}
- (void) getListBoughtOK {
    
    [self removeListBoughtObservers];
    [self stopLoading];
    
    lstBoughtItems = [listBoughtParser._listVideoObj.lstVideoItems retain];
    for (int i = 0; i < [lstBoughtItems count]; i++) {
        BoughtObject *obj = [lstBoughtItems objectAtIndex:i];
        InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"" andURL:obj.content_picture_path] autorelease];
        iResource.receiver = TVOD_GET_LIST_BOUGHT;
        [lstBoughtResources addObject:iResource];
    }
    
    if (listBoughtParser) [listBoughtParser release];
    
    [tblListBought reloadData];
    
}
- (void) getListBoughtError {

    [self removeListBoughtObservers];
    [self stopLoading];
}
- (void) getListBoughtFailed {
    
    [self removeListBoughtObservers];
    [self stopLoading];
}

@end
