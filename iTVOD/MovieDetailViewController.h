
//  MovieDetailViewController.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerViewController.h"

#import "VideoUrlParser.h"
#import "UserViewController.h"
#import "MBProgressHUD.h"
#import "SubtitleObj.h"
#import "AddToFavorite.h"
#import "ListCommentParser.h"
#import "PostCommentParser.h"
#import "ListVideoParser.h"

@class AppDelegate;

#define ALERT_CONFIRM_PLAY_MOVIE 100
#define ALERT_LOGIN      200

@interface MovieDetailViewController : UIViewController<MPMediaPickerControllerDelegate, UIAlertViewDelegate,MBProgressHUDDelegate,CustomMoviePlayerViewControllerDelegate, UITableViewDataSource,UITableViewDelegate>
{

    MPMoviePlayerController *moviePlayer;
    MPMoviePlayerViewController *moviePlayerViewCtrl;
    
    NSString *video_id;
    NSString *strUrl;
    VideoUrlParser *_videoUrlParser;
    AddToFavoriteParser *addToFavoriteParser;
    ListCommentParser *listCommentParser;
    PostCommentParser *postCommentParser;
    ListVideoParser *_listVideoParser;
    NSMutableArray *lstRelateVideo;
    NSString *_type;
    NSMutableArray *lstRelatedResource;
    
    int totalRelatedVideo;
    int totalRelatedPage;
    
    NSMutableArray *listComment;
    
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIImageView *imgFilm;
    IBOutlet UILabel *lblFilmName;
    IBOutlet UILabel *lblNumberViews;
    IBOutlet UILabel *lblDuration;
    IBOutlet UILabel *lblPrice;
    IBOutlet UIImageView *imgPrice;
    
    IBOutlet UITextView *txtDescription;
    
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UIWebView *webView;
    //comment view
    IBOutlet UITextField *txtComment;
    
    IBOutlet UIButton *btnPostComment;
    
    IBOutlet UITableView *tblListComment;
    IBOutlet UIView *commentView;
    
    double orginalYofCommentView ;
    int    orginalHeightOfCommentView;
    double orginalYofSegmentControl;
    //related videos
    
    IBOutlet UIView *relatedVideoView;
    
    IBOutlet UITableView *tblRelatedVideo;
    
    NSString *m_duration;
    NSString *m_strTitle;
    NSString *m_strVietnameseTitle;
    NSString *m_numberViews;
    NSString *m_price;
    NSString *m_description;
    
    UIImage *_img;
    
    AppDelegate *_appDelegate;
    MBProgressHUD *HUD;
    
    CustomMoviePlayerViewController *_customMoviePlayer;
    
    NSMutableArray *lstSubtitles;
    NSMutableDictionary *subtitles;
    float currentTime;
    
    NSTimer *timer;
    UILabel *lbl;
    int _startIndexSub;
}
@property (nonatomic,copy) NSString *m_duration;
@property (nonatomic,copy) NSString *m_strTitle;
@property (nonatomic,copy) NSString *m_numberViews;
@property (nonatomic,copy) NSString *m_price;

@property (nonatomic,copy) NSString *m_description;

@property (nonatomic,copy) UIImage *_img;
@property (nonatomic, copy)  NSString *video_id;
@property (nonatomic, copy) NSString *m_strVietnameseTitle;

@property (nonatomic, retain) IBOutlet UIImageView *imgFilm;
@property (nonatomic, retain) IBOutlet UILabel *lblFilmName;
@property (nonatomic, retain) IBOutlet UILabel *lblNumberViews;
@property (nonatomic, retain) IBOutlet UILabel *lblDuration;
@property (nonatomic, retain) IBOutlet UILabel *lblPrice;

@property (nonatomic, retain) IBOutlet UITextView *txtDescription;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
-(id)initWithTitle:(NSString *)strTitle vietnameseTitle:(NSString *)vietnamese_title videoId:(NSString *)_id image:(UIImage *)img numberViews:(NSString *)numberViews duration:(NSString *)duration price:(NSString *)price description:(NSString *)description;
-(IBAction)backPress:(id)sender;
-(IBAction)playVideo:(id)sender;
- (IBAction)postComment:(id)sender;
- (IBAction)switchTab:(UISegmentedControl *)sender;
- (IBAction)didBeginEditingComment:(UITextField*)sender;

- (IBAction)didEndEditingComment:(UITextField*)sender;

-(void)requestGetUrl:(NSString *)_video_id;
-(void) loadsubfile:(NSString *)strData;
-(NSString *) strip:(NSString *)str;
-(float) toSecond:(NSString *)time;

- (IBAction)addToFavorite:(id)sender;
@end
