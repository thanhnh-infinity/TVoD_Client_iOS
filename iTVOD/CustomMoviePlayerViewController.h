
//  CustomMoviePlayerViewController.h

//  Copyright iOSDeveloperTips.com All rights reserved.


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol CustomMoviePlayerViewControllerDelegate<NSObject>
-(void)finishPlayVideo;
-(void)failedPlayVideo;
-(void)back;
-(void)addSubtitle;
@end

@interface CustomMoviePlayerViewController : UIViewController 
{
    id<CustomMoviePlayerViewControllerDelegate> delegate;
    MPMoviePlayerController *mp;
    NSURL *movieURL;
    
    UIActivityIndicatorView *indicator;
    NSTimeInterval currentPlaybackTime;
}
@property(nonatomic,assign) id<CustomMoviePlayerViewControllerDelegate> delegate;
@property(nonatomic,assign) MPMoviePlayerController *mp;
@property(nonatomic,assign) BOOL customSize;
@property(nonatomic,assign) CGRect customFrame;
@property(nonatomic,assign) CGPoint customCenterPoint;
- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;


@end
