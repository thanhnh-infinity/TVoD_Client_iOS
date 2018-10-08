
//  RegisterViewController.m
//  iTVOD

//  Created by vivas-mac on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "RegisterViewController.h"

@implementation RegisterViewController

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
//#pragma mark -
//#pragma mark UITextFielDelegate
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    txtPassRegis.delegate = self;
    txtUserRegis.delegate = self;
    txtConfirmPassRegis.delegate = self;
    txtPassRegis.backgroundColor = [UIColor clearColor];
    txtUserRegis.backgroundColor = [UIColor clearColor];
    txtConfirmPassRegis.backgroundColor = [UIColor clearColor];
    [txtUserRegis becomeFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark REGISTER
-(void)requestRegister:(NSString *)user_name password:(NSString *)password
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerOK) name:REGISTER_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerError) name:REGISTER_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:REGISTER_CONNECTION_FAILED object:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    _registerParser = [[RegisterParser alloc] init];
    [_registerParser parserWithJSONLink:[NSString stringWithFormat:TVOD_REGISTER,user_name,password]];
}
-(void)connectionFailed
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_ERROR object:nil];
}
-(void)registerOK
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_ERROR object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Đăng ký thành công" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}
-(void)registerError
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_ERROR object:nil];
}
#pragma mark -
#pragma mark Action
-(IBAction)back:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)registerAcount:(id)sender
{
    
    BOOL isValidEmail = [self validateEmail:txtUserRegis.text];
    if (isValidEmail) {
        
        NSString *strPass = txtPassRegis.text;
        NSString *strConfirmPass = txtConfirmPassRegis.text;
        if ([strPass isEqualToString:strConfirmPass]) {
            
            [self requestRegister:txtUserRegis.text password:strPass];
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Mật khẩu không khớp" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Email không đúng định dạng" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}

@end
