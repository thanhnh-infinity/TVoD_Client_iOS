
//  ChildCategoryViewController.h
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>

#import "ListVideoViewController.h"
#import "ChildCategoryParser.h"
#import "MBProgressHUD.h"
#import "InternetResource.h"
#import <QuartzCore/QuartzCore.h>
#import "ListLiveViewController.h"

@interface ChildCategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblListChildCategory;
    NSMutableArray *lstChildCategory;
    NSMutableArray *lstImages;
    
    ChildCategoryParser *_childCategoryParser;
    IBOutlet UILabel *lblTitle;
    
    MBProgressHUD *HUD;
    NSMutableArray *lstResources;
    
    NSString *parent_category_id;
    NSString *parent_category_title;
}
@property (nonatomic,retain) IBOutlet UITableView *tblListChildCategory;
@property (nonatomic,retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) NSString *parent_category_id;
@property (nonatomic, retain) NSString *parent_category_title;

-(id)initWithParentCategoryId:(NSString *)_parent_category_id title:(NSString *)strTitle;
-(void)requestChildCategory;
-(IBAction)back:(id)sender;

@end
