
//  AppDelegate.m
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "AppDelegate.h"
#import "MainViewController.h"
#import "UserViewController.h"
#import "SearchViewController.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize isLogin;
@synthesize nav;
@synthesize _loginViewCtrl;

- (void)dealloc
{
    
    [_window release];
    [super dealloc];
    
}
-(BOOL)getSavedAccInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    m_username = [defaults objectForKey:@"username"];
    m_password = [defaults objectForKey:@"password"];
//    
//    
    if ([m_username isEqualToString:@""] || (m_username == nil ) || ([m_password isEqualToString:@""]) || (m_password == nil)) {
        
        return NO;
    }
    
    
    return YES;
}
-(void)loginWithUsername:(NSString *)user_name password:(NSString *)pass
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK) name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginError) name:LOGIN_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionError) name:LOGIN_CONNECTION_ERROR object:nil];
    
    _loginParser = [[LoginParser alloc] init];
    [_loginParser parserWithJSONLink:[NSString stringWithFormat:TVOD_LOGIN,user_name,pass]];
    
    
}
-(void)connectionError
{
    
    [self removeObserVers];
    isLogin = FALSE;
    [_loginParser release];
    [_loginViewCtrl stopLoading];
    [self setupView];
    
}
-(void)loginOK
{
    
    [self removeObserVers];
    isLogin = TRUE;
    
    if (_loginParser ) [_loginParser release];
    [_loginViewCtrl stopLoading];
    
//    [self setupView];
    
    [_loginViewCtrl displayView];
    
}
-(void)loginError
{
    
        [self removeObserVers];
    
    isLogin = FALSE;
    [_loginParser release];
    [_loginViewCtrl stopLoading];
    [self setupView];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    isDebug = TRUE;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    // self.window.backgroundColor = [UIColor blueColor];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading.png"]];
//        [imgView setFrame:CGRectMake(0, 20, 768, 1024)];
//        // [imgView setFrame:[[UIScreen mainScreen]applicationFrame]];
//        [self.window addSubview:imgView];
//        [imgView release];
//    }
//    else {
//        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading.png"]];
//        //[imgView setFrame:CGRectMake(0, 20, 768, 1004)];
//       // [imgView setFrame:[[UIScreen mainScreen]applicationFrame]];
//        [self.window addSubview:imgView];
//        [imgView release];
//    }
    [self.window makeKeyAndVisible];
    
    //check version here
    _loginViewCtrl = [[LoginViewController alloc] init];
    // _loginViewCtrl.view.frame = CGRectMake(0, 0, 320, 460);
//    [_loginViewCtrl getSavedAccountInfo];
    nav = [[UINavigationController alloc] initWithRootViewController:_loginViewCtrl];
    
    [self.window addSubview:nav.view];

    
    BOOL isRemember = [self getSavedAccInfo];
    
    if (isRemember) {
        //login
        
        
        
        
        _loginViewCtrl.txtUsername.text = m_username;
        _loginViewCtrl.txtPass.text = m_password;
        
        [_loginViewCtrl startLoading];
        
        [self requestLogout];
        
    }
    else
    {
        
       // [self setupView];
    }
    
    
    return YES;
}

-(void)setupView
{
//    UINavigationController *nav;
//    NSMutableArray *lstNavigation = [[NSMutableArray alloc]init];
//    //Home
//    MainViewController *_mainViewController = [[MainViewController alloc] init];
//    nav = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
//    nav.tabBarItem.image=[UIImage imageNamed:@"homepage.png"];
//    _mainViewController.title = @"Trang chủ";
//    [_mainViewController release];
//    [lstNavigation addObject:nav];
//    [nav release];
//    
//    //User
//    UserViewController *_userViewController = [[UserViewController alloc] init];
//    nav = [[UINavigationController alloc] initWithRootViewController:_userViewController];
//    if (isLogin) {
//        _userViewController.title = @"Cá nhân";
//        nav.tabBarItem.image=[UIImage imageNamed:@"user.png"];
//        [_userViewController preSetup];
//    }
//    else
//    {
//        _userViewController.title = @"Đăng nhập";
//        nav.tabBarItem.image=[UIImage imageNamed:@"dangnhap.png"];
//    }    
//    
//    [_userViewController release];
//    [lstNavigation addObject:nav];
//    [nav release];
//    
//    
//    //Search
//    SearchViewController *_searchViewCtrl = [[SearchViewController alloc] init];
//    _searchViewCtrl.title = @"Tìm kiếm";
//    nav = [[UINavigationController alloc] initWithRootViewController:_searchViewCtrl];
//    nav.tabBarItem.image=[UIImage imageNamed:@"search.png"];
//    [_searchViewCtrl release];
//    
//    [lstNavigation addObject:nav];
//    [nav release];
//    
//    
//    tbControl = [[UITabBarController alloc]init];
//    
//	tbControl.viewControllers = lstNavigation;
//	tbControl.customizableViewControllers= lstNavigation;
//    
//    [lstNavigation release];
//	tbControl.delegate = self;
//    
//	[self.window addSubview:tbControl.view];
    
    
        //[_loginViewCtrl release];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    _logoutParser = [[LogoutParser alloc] init];
//    [_logoutParser parserWithJSONLink:TVOD_LOGOUT];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
        // [self loginWithUsername:m_username password:m_password];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
        //    
//    _logoutParser = [[LogoutParser alloc] init];
//    [_logoutParser parserWithJSONLink:TVOD_LOGOUT];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Memory Warning" message:@"Please delete some application" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alert show];
//    [alert release];
}

#pragma mark -
#pragma mark Logout
-(void) setupObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOK) name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutError) name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutConnectionFailed) name:LOGOUT_CONNECTION_FAILED object:nil];
}

- (void) removeObserVers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];

}
-(void)requestLogout
{
    
    [self setupObservers];
    
    _logoutParser = [[LogoutParser alloc] init];
    [_logoutParser parserWithJSONLink:TVOD_LOGOUT];
    
}
-(void)logoutConnectionFailed
{
    
 
    [self removeObserVers];
    
    [_loginViewCtrl stopLoading];
    
    isLogin = FALSE;
    [self setupView];
    
}
-(void)logoutOK
{
    
    
    [self removeObserVers];
    
    [self loginWithUsername:m_username password:m_password];
    
}

-(void)logoutError
{
    
    
    
    [self removeObserVers];
   
    
    [_loginViewCtrl stopLoading];
    
    isLogin = FALSE;
    [self setupView];
    
}
@end
