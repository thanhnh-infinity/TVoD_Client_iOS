
//  MainViewController.h
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "ChildCategoryViewController.h"
#import "ParentCategoryParser.h"
#import "MBProgressHUD.h"
#import "CheckVersionParser.h"
#define ALERT_CHECK_VERSION 20

@interface MainViewController : UIViewController<MBProgressHUDDelegate>
{
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIButton *btnRefresh;
    
    int totalPages;
    int lastPage;
    
    UIScrollView *scrollView;
    
    ParentCategoryParser *_parentCategoryParser;
    MBProgressHUD *HUD;
    
    NSMutableArray *lstParentCategories;
    
    NSMutableArray *lstButton;
    NSMutableArray *lstResources;
    
    CheckVersionParser *_checkVersionParser;
}
-(IBAction)refresh:(id)sender;
    //-(IBAction)touchButton:(id)sender;
-(void)getParentCategory;
-(void)renderImage;
@end
