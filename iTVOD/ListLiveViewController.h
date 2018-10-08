
//  ListLiveViewController.h
//  iTVOD

//  Created by Do Thanh Nam on 03/01/2013.
//  Copyright (c) 2013 NAMDT. All rights reserved.


#import <UIKit/UIKit.h>
#import "ListVideoParser.h"
#import "InternetResource.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerViewController.h"

@interface ListLiveViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate,CustomMoviePlayerViewControllerDelegate > {
    ListVideoParser *_listVideoParser;
    NSMutableArray *lstVideos;
    NSMutableArray *lstVideoResource;
    MBProgressHUD *HUD;
    MPMoviePlayerController *moviePlayer;
    CustomMoviePlayerViewController *_customMoviePlayer;
    MPMoviePlayerController *mp;
    BOOL isFinishPlaying;
    BOOL shouldAutoPlay;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UITableView *tblListLive;
- (IBAction)switchTab:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *notificationView;
@property (retain, nonatomic) IBOutlet UILabel *lblNotification;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *idcNotification;

@property (retain, nonatomic) IBOutlet UIImageView *imgTV;
@property (retain, nonatomic) IBOutlet UIView *theLiveListView;
- (IBAction)back:(id)sender;

@end
