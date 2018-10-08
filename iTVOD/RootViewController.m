
//  RootViewController.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "RootViewController.h"

@implementation RootViewController

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationController *nav;
    
    NSMutableArray *controls = [[NSMutableArray alloc]init];
    //Home
    MainViewController *_mainViewController = [[MainViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
    nav.tabBarItem.image=[UIImage imageNamed:@"homepage.png"];
    _mainViewController.title = @"Trang chủ";
    [_mainViewController release];
    [controls addObject:nav];
    [nav release];
    
    //User
    UserViewController *_userViewController = [[UserViewController alloc] init];
    _userViewController.title = @"Cá nhân";
    nav = [[UINavigationController alloc] initWithRootViewController:_userViewController];
    nav.tabBarItem.image=[UIImage imageNamed:@"user.png"];
    [_userViewController release];
    [controls addObject:nav];
    [nav release];
    
    
    //Search
    SearchViewController *_searchViewCtrl = [[SearchViewController alloc] init];
    _searchViewCtrl.title = @"Tìm kiếm";
    nav = [[UINavigationController alloc] initWithRootViewController:_searchViewCtrl];
    nav.tabBarItem.image=[UIImage imageNamed:@"search.png"];
    [_searchViewCtrl release];
   
    [controls addObject:nav];
    [nav release];
    
    
    tbControl = [[UITabBarController alloc]init];
    
	tbControl.viewControllers = controls;
	tbControl.customizableViewControllers= controls;

    [controls release];
	tbControl.delegate = self;
    [tbControl setWantsFullScreenLayout:YES];
	
	[self.view addSubview:tbControl.view];
    
    [self setWantsFullScreenLayout:YES];
    
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

@end
