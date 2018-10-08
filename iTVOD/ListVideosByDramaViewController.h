
//  ListVideosByDramaViewController.h
//  iTVOD

//  Created by Do Thanh Nam on 20/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import <UIKit/UIKit.h>
#import "ListVideoObject.h"
#import "MBProgressHUD.h"
#import "DramaObj.h"
#import "ListVideosByDramaParser.h"
@interface ListVideosByDramaViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSMutableArray *lstResources;
    //NSMutableArray *lstVideoObject;
    ListVideosByDramaParser *lstVideoByDramaParser;
    
    UIImage *theAvartar;
    DramaObj *theDramaObject;
    
    NSString *currentFilterType;
    IBOutlet UISegmentedControl *segmentControl;
    
    NSMutableArray *lstFromFirstVideo;
    NSMutableArray *lstFromLastVideo;
    
    NSString *video_type;
    
    int totalNewestVideo;
    int totalNewestPage;
    int totalOldestVideo;
    int totalOldestPage;
    
    int currentNewestPage;
    int currentOldestPage;
    
    
}
//@property (retain, nonatomic) NSMutableArray *lstResources;
//@property (retain, nonatomic) ListVideoObject *lstVideoObject;
@property (retain, nonatomic) IBOutlet UITableView *tblFilmSeries;
@property (retain, nonatomic) IBOutlet UIImageView *filmSeriesAvatar;
@property (retain, nonatomic) IBOutlet UIImageView *filmSeriesVote;
@property (retain, nonatomic) IBOutlet UILabel *vietnameseTitle;
@property (retain, nonatomic) IBOutlet UILabel *englishTitle;
@property (retain, nonatomic) IBOutlet UILabel *numberOfSeries;

@property (assign, nonatomic) DramaObj *theDramaObject;
@property (assign, nonatomic) UIImage *theAvartar;
@property (assign, nonatomic) ListVideosByDramaParser *lstVideoByDramaParser;

- (id)initWithDramaObject:(DramaObj*) dramaObj dramaAvartar:(UIImage *) img;
- (IBAction)back:(UIButton *)sender;
- (IBAction)changeFilter:(UISegmentedControl *)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnShowMore;


@end
