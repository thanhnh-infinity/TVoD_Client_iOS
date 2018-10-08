
//  ListVideoViewController.h
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "MovieDetailViewController.h"
#import "ListVideoParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoUrlParser.h"
#import "MBProgressHUD.h"
#import "InternetResource.h"

#import "CustomMoviePlayerViewController.h"
#import "NewsDetailViewController.h"

#import "DramaParser.h"
#import "ListVideosByDramaViewController.h"
#import "ListVideosByDramaParser.h"


@interface ListVideoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,MPMediaPickerControllerDelegate,MBProgressHUDDelegate,CustomMoviePlayerViewControllerDelegate>
{
    IBOutlet UITableView *tblListVideo;
    IBOutlet UIButton *btnShowMore;
    IBOutlet UISegmentedControl *segmentControl;
    NSMutableArray *lstNewestDramas;
    
    NSMutableArray *lstNewestVideo;
    NSMutableArray *lstMostViewVideo;
    NSMutableArray *lstMostViewDrama;
    
    NSMutableArray *lstVideoFavorite;
    NSMutableArray *lstVideoRandom;

    int totalNewestVideos;
    int totalNewestPages;
    
    int totalNewestDramas;
    int totalNewestDramaPages;
    
    int totalMostViewDramas;
    int totalMostViewDramaPages;
    
    int totalMostViewVideos;
    int totalMostViewPages;
    
    int currentNewestPage;
    int currentMostViewPage;
    int currentFavoritePage;
    int currentRandomPage;
    
//    DramaObj *selectedDramaObject;
    DramaParser *_dramaParser;
    ListVideoParser *_listVideoParser;
    
    NSString *currentFilterType;
    
     MBProgressHUD *HUD;
    //Play movie
    MPMoviePlayerController *moviePlayer;
    
    NSString *selectedVideoId;
    NSString *strID;
    
    NSMutableArray *lstImages;
    NSMutableArray *lstNewestResources;
    NSMutableArray *lstMostViewResources;
    
    NSMutableArray *lstNewestDramaResources;
    NSMutableArray *lstMostViewDramaResources;
    
    BOOL isDrama;
    BOOL isGetVideoFollowDrama;
    NSString *_type;
    CustomMoviePlayerViewController *_customMoviePlayer;
    NSString *parent_category_title;
}
@property (nonatomic, retain) IBOutlet UITableView *tblListVideo;
@property (nonatomic, retain) NSString *strID;
@property (nonatomic, retain) NSString *parent_category_title;
@property (nonatomic, retain) NSString *_type;

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;

-(id)initWithCategoryId:(NSString *)str_category_id parent_title:(NSString *) parent_title;

-(void)requestGetListVideo:(NSString *)_filter page:(int)_page;
-(void)requestGetListDrama:(NSString *)_filter page:(int)_page;
-(void)requestGetListVideoFollowDrama:(NSString *)_filter withId:(NSString *)_id page:(int)_page;

//-(IBAction)next:(id)sender;
//-(IBAction)previous:(id)sender;
-(IBAction)changeFilter:(id)sender;
-(IBAction)back:(id)sender;

-(void)displayNewest;
-(void)displayMostView;
-(void)displayFavorite;
-(void)displayRandom;

-(IBAction)showMore:(id)sender;

-(void)removeLoading;
-(void)addLoading;
-(void)initGetListVideoNotification;
-(void)removeGetListVideoNotification;

-(void)initGetListDramaNotification;
-(void)removeGetListDramaNotification;
@end
