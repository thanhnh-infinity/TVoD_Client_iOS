
//  ListLiveViewController.m
//  iTVOD

//  Created by Do Thanh Nam on 03/01/2013.
//  Copyright (c) 2013 NAMDT. All rights reserved.


#import "ListLiveViewController.h"

@interface ListLiveViewController ()

@end

@implementation ListLiveViewController
@synthesize notificationView;
@synthesize lblNotification;
@synthesize lblTitle;
@synthesize idcNotification;
@synthesize imgTV;
@synthesize theLiveListView;
@synthesize segmentControl;
@synthesize tblListLive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    theLiveListView.backgroundColor = [UIColor clearColor];
    tblListLive.dataSource = self;
    tblListLive.delegate = self;
    tblListLive.backgroundColor = [UIColor clearColor];
    imgTV.hidden = YES;
    lstVideos = [[NSMutableArray alloc] init];
    lstVideoResource = [[NSMutableArray alloc] init];
    notificationView.hidden = YES;
    notificationView.backgroundColor = [UIColor clearColor];
    shouldAutoPlay = YES;
    [self getListLive:TVOD_GET_LIST_LIVE_MOBILE];
}
- (void) getListLive:(NSString *) link {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_VIDEO];
    
    [self setupListLiveObservers];
    [self startLoading];
    _listVideoParser = nil;
    if (_listVideoParser == nil) {
        _listVideoParser = [[ListVideoParser alloc] init];
    }
    [_listVideoParser parserWithJSONLink:[NSString stringWithFormat:link]];
}
- (void) setupListLiveObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListLiveOK) name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListLiveFailed) name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListLiveError) name:GET_LIST_VIDEO_ERROR object:nil];
}
- (void) removeListLiveObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
}
- (void) bringMessage:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}
- (void) getListLiveOK {
    
    [self stopLoading]; 
    [self removeListLiveObservers];
    
    if (lstVideos) {
        [lstVideos removeAllObjects];
    }
    if (lstVideoResource) {
        [lstVideoResource removeAllObjects];
    }
    
    lstVideos = [_listVideoParser._listVideoObj.lstVideoItems retain];
    
    for (int i=0; i<[lstVideos count]; i++) {
        VideoObject *obj = [lstVideos objectAtIndex:i];
        InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"" andURL:obj.video_picture_path] autorelease];
        iResource.receiver = TVOD_GET_LIST_VIDEO;
        [lstVideoResource addObject:iResource];
    }
    
    [tblListLive reloadData];
    
    if (shouldAutoPlay && [lstVideos count]) {
        shouldAutoPlay = NO;
        [self playLiveAt:0];
    }
}
- (void) getListLiveFailed {
    [self stopLoading]; 
    [self removeListLiveObservers];    
}
- (void) getListLiveError {
    [self stopLoading]; 
    [self removeListLiveObservers];

}
- (void) startLoading{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
}
- (void) stopLoading {
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
-(void)detectOrientation:(NSNotification*)notification {
 /*
    //did rotate
    UIInterfaceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
    
    [mp pause];
    if (toInterfaceOrientation != UIInterfaceOrientationPortrait){
        
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        [[mp view] setCenter:CGPointMake(240, 160)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
        
        [mp play];
        //    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        //        [[mp view] setCenter:CGPointMake(240, 160)];
        //        [mp play];
    } 
    else {
        [mp setControlStyle:MPMovieControlStyleEmbedded];
        [mp setFullscreen:NO];
      [[mp view] setFrame:CGRectMake(42, 0, 320, 180)];
      [[mp view] setCenter:CGPointMake(160, 132)];
        [mp play];
        
    }
  */
}
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
    [self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
}
-(void)reloadTable:(InternetResource*)_resource{
	[tblListLive reloadData];
}

- (void)viewDidUnload
{
    [self setSegmentControl:nil];
    [self setTblListLive:nil];
    [imgTV release];
    imgTV = nil;
    [self setImgTV:nil];
    [self setTheLiveListView:nil];
    [self setNotificationView:nil];
    [self setLblNotification:nil];
    [self setLblTitle:nil];
    [self setIdcNotification:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    
    if (isFinishPlaying) {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    }
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown ;
//    UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
     
    [mp pause];
    if (toInterfaceOrientation != UIInterfaceOrientationPortrait){

        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        [[mp view] setCenter:CGPointMake(240, 160)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 

        [mp play];
        //    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        //        [[mp view] setCenter:CGPointMake(240, 160)];
        //        [mp play];
    } 
    else {
        [[mp view] setFrame:CGRectMake(42, 0, 320, 180)];
        [[mp view] setCenter:CGPointMake(160, 132)];
        [mp play];
        
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lstVideos count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
	}
    VideoObject *obj = nil;
    InternetResource *iResource = nil;
    
    
    obj = [lstVideos objectAtIndex:indexPath.row];
    
//    if ([lstVideoResource count] >=(indexPath.row +1)) {
        iResource = [lstVideoResource objectAtIndex:indexPath.row];
//    }
    
    if (iResource != nil) {
        
        @synchronized(iResource){
            switch (iResource.status) {
                case NEW:
                    {
                    cell.imageView.image = [UIImage imageNamed:@"loading.png"];
                    [iResource start];
                    }
                    break;
                case COMPLETE:
                    {
                    cell.imageView.image = iResource.image;
                    }
                    break;
                case FAILED:	
                    cell.imageView.image = [UIImage imageNamed:@"no_image.png"];
                    break;
                case FETCHING:
                    cell.imageView.image = [UIImage imageNamed:@"loading.png"];
                    break;
                default:
                    break;
            }
        }
    }
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@",obj.live_channel_title];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@ lượt xem",obj.live_channel_number_view];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self playLiveAt:indexPath.row];
    
}
- (void) showNotification: (NSString *) channelTitle {
    notificationView.hidden = NO;
    [idcNotification startAnimating];
    lblNotification.text = [NSString stringWithFormat:@"Đang tải \"%@\"",channelTitle];
    lblTitle.hidden = YES;

}
- (void) hideNotification {
    notificationView.hidden = YES;
    [idcNotification stopAnimating];
    lblNotification.text = @"";
    lblTitle.hidden = NO;
    lblTitle.text = @"Truyền hình";
}
- (void)playLiveAt:(NSInteger) index {
    VideoObject *obj;
    obj = [lstVideos objectAtIndex:index];
    
    [self showNotification:obj.live_channel_title];
        
    NSString *strLiveStream = [NSString stringWithFormat:@"%@/%@.m3u8",obj.live_channel_url,obj.live_channel_folder];
    [self readyPlayerWithURL:[NSURL URLWithString:strLiveStream]];   
}
-(void)addSubtitle {
    return;
}
- (void)dealloc {
    [segmentControl release];
    [tblListLive release];
    [imgTV release];
    [mp release];
    [theLiveListView release];
    [notificationView release];
    [lblNotification release];
    [lblTitle release];
    [idcNotification release];
    [super dealloc];
}
- (IBAction)switchTab:(id)sender {
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            
            [self getListLive:TVOD_GET_LIST_LIVE_MOBILE];
            break;
        case 1:
            
            [self getListLive:TVOD_GET_LIST_LIVE_SD];
            break;
        case 2:
            
            [self getListLive:TVOD_GET_LIST_LIVE_HD];
            break;
        default:
            break;
    }
    return;
}



/*---------------------------------------------------------------------------
 * For 3.2 and 4.x devices
 * For 3.1.x devices see moviePreloadDidFinish:
 *--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	
    // Unless state is unknown, start playback
    
	if ([mp loadState] != MPMovieLoadStateUnknown)
        {
        // Remove observer
        [[NSNotificationCenter 	defaultCenter] 
         removeObserver:self
         name:MPMoviePlayerLoadStateDidChangeNotification 
         object:nil];
        
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        
		// Rotate the view for landscape playback
//        [[self view] setBounds:CGRectMake(0, 0, 320, 480)];
//		[[self view] setCenter:CGPointMake(160, 240)];
        //		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
		// Set frame of movieplayer
		[[mp view] setFrame:CGRectMake(42, 0, 320, 180)];
        [[mp view] setCenter:CGPointMake(160, 132)];
        // Add movie player as subview
        [[self view] addSubview:[mp view]];   
        
		// Play the movie
        isFinishPlaying = NO;
        [self hideNotification];
		[mp play];
        }
    
}

/*---------------------------------------------------------------------------
 * For 3.1.x devices
 * For 3.2 and 4.x see moviePlayerLoadStateChanged: 
 *--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
    
    // Remove observer
	[[NSNotificationCenter 	defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerContentPreloadDidFinishNotification
     object:nil];
    
	// Play the movie
    isFinishPlaying = NO;
    [self hideNotification];
 	[mp play];
	

}

/*---------------------------------------------------------------------------
 * 
 *--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
 	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification 
     object:nil];
    isFinishPlaying = YES;
    
    [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];   
    
//    [mp.view removeFromSuperview];
//    if ([mp respondsToSelector:@selector(setFullscreen:animated:)]) {
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    [mp release];
//    mp = nil;
    
}

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (void) readyPlayerWithURL:(NSURL *) movieURL
{
 	
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if ([mp respondsToSelector:@selector(loadState)]) 
        {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleEmbedded];
//        [mp setFullscreen:YES];
        
		// May help to reduce latency
		[mp prepareToPlay];
        
		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayerLoadStateChanged:) 
                                                     name:MPMoviePlayerLoadStateDidChangeNotification 
                                                   object:nil];
        }  
    else
        {
        // Register to receive a notification when the movie is in memory and ready to play.
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePreloadDidFinish:) 
                                                     name:MPMoviePlayerContentPreloadDidFinishNotification 
                                                   object:nil];
        }
    
    // Register to receive a notification when the movie has finished playing. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
    
}


-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
