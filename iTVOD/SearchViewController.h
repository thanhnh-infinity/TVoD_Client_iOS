
//  SearchViewController.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "SearchParser.h"
#import "InternetResource.h"
#import "MovieDetailViewController.h"
#import "MBProgressHUD.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblSearchResult;
    IBOutlet UISearchBar *_searchBar;
    IBOutlet UIButton *btnShowMore;
    
    SearchParser *_searchParser;
    NSMutableArray *lstResources;
    
    NSMutableArray *lstSearchResult;
    
    int currentPage;
    
    int totalResultVideos;
    int totalResultPages;
    
    MBProgressHUD *HUD;
    
    NSString *m_strSearch;
}
-(IBAction)showMore:(id)sender;
-(void)requestSearch:(NSString *)keyword;
@end
