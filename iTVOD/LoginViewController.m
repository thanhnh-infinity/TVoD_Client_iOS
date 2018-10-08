
//  LoginViewController.m
//  iTVOD

//  Created by vivas-mac on 12/3/12.



#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtUsername,txtPass, isChecked;

-(void)saveAccountInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:txtUsername.text forKey:@"username"];
    [defaults setObject:txtPass.text forKey:@"password"];
    
    [defaults synchronize];
    
}
-(void)getSavedAccountInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    txtUsername.text = username;
    txtPass.text = password;
    
    
    
}
#pragma mark -
#pragma mark login
-(void)requestLogin:(NSString *)user_name password:(NSString *)password
{
   
    NSString *strLogin = [NSString stringWithFormat:TVOD_LOGIN,user_name,password];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK) name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginError) name:LOGIN_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionError) name:LOGIN_CONNECTION_ERROR object:nil];
    
    [self startLoading];
    
    _loginParser = [[LoginParser alloc] init];
    [_loginParser parserWithJSONLink:strLogin];
    
}
-(void)connectionError
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    [self stopLoading];
    
}
-(void)loginError
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    
    [self stopLoading];
    
}
-(void)loginOK
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_CONNECTION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_ERROR object:nil];
    
    [self stopLoading];
    
    [txtUsername resignFirstResponder];
    [txtPass resignFirstResponder];
    [self displayView];
   //save account info
    [self saveAccountInfo];
    
}
#pragma mark -
#pragma mark logout
-(void)requestLogout
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOK) name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutError) name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutConnectionFailed) name:LOGOUT_CONNECTION_FAILED object:nil];
    
    [self startLoading];
    
    _logoutParser = [[LogoutParser alloc] init];
    [_logoutParser parserWithJSONLink:TVOD_LOGOUT];
    
}
-(void)logoutConnectionFailed
{
    
    [self stopLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
    
}
-(void)logoutOK
{
    
    [self stopLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
    NSString *strName = txtUsername.text;
    NSString *strPass = txtPass.text;
        
        
    
    
    
    [self requestLogin:strName password:strPass];
    
}

-(void)logoutError
{
    
    [self stopLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUT_CONNECTION_FAILED object:nil];
    [_logoutParser release];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [txtUsername resignFirstResponder];
    [txtPass resignFirstResponder];
    
}
#pragma mark -
#pragma mark Action
-(IBAction)performRegister:(id)sender
{
    
    RegisterViewController *_registerViewCtrl = [[RegisterViewController alloc] init];
    [self presentModalViewController:_registerViewCtrl animated:YES];
//    [self.navigationController pushViewController:_registerViewCtrl animated:YES];
    [_registerViewCtrl release];
    
}

- (IBAction)checkRemember:(id)sender {
    if (isChecked == false) {
        [btnCheck setImage:[UIImage imageNamed:@"btnCheckBoxActive.png"] forState:UIControlStateNormal];
        isChecked = true;
    }
    else
        {
        [btnCheck setImage:[UIImage imageNamed:@"btnCheckBox.png"] forState:UIControlStateNormal];
        isChecked = false;
        }
}

-(IBAction)performLogin:(id)sender
{
    
    [txtPass resignFirstResponder];
    [txtUsername resignFirstResponder];
    //[self displayView];
    
    [self requestLogout];
    
    
}
-(void)startLoading
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
	[self.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
}
-(void)stopLoading
{
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
}
-(void)displayView
{
    
    UINavigationController *nav;
    NSMutableArray *lstNavigation = [[NSMutableArray alloc]init];
    //Home
    MainViewController *_mainViewController = [[MainViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
    nav.tabBarItem.image=[UIImage imageNamed:@"homepage.png"];
    _mainViewController.title = @"Trang chủ";
    [_mainViewController release];
    [lstNavigation addObject:nav];
    [nav release];
    
    //User
    UserViewController *_userViewController = [[UserViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController:_userViewController];
    _userViewController.title = @"Cá nhân";
    nav.tabBarItem.image=[UIImage imageNamed:@"user.png"];
    
    [_userViewController release];
    [lstNavigation addObject:nav];
    [nav release];
    
    
    //Search
    SearchViewController *_searchViewCtrl = [[SearchViewController alloc] init];
    _searchViewCtrl.title = @"Tìm kiếm";
    nav = [[UINavigationController alloc] initWithRootViewController:_searchViewCtrl];
    nav.tabBarItem.image=[UIImage imageNamed:@"search.png"];
    [_searchViewCtrl release];
    
    [lstNavigation addObject:nav];
    [nav release];
    
    
    tbControl = [[UITabBarController alloc]init];
    
	tbControl.viewControllers = lstNavigation;
	tbControl.customizableViewControllers= lstNavigation;
    
    [lstNavigation release];
	tbControl.delegate = self;
    
	//[self.view addSubview:tbControl.view];
    [self.navigationController pushViewController:tbControl animated:YES];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    
    txtUsername.text = username;
    txtPass.text = password;
    isChecked = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    
}

- (void)dealloc {
    [btnCheck release];
    [super dealloc];
}
- (void)viewDidUnload {
    [btnCheck release];
    btnCheck = nil;
    [super viewDidUnload];
}
@end
