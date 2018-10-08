
//  MovieDetailViewController.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "MovieDetailViewController.h"
#import "AppDelegate.h"


@implementation MovieDetailViewController
@synthesize video_id;
@synthesize imgFilm,lblFilmName,lblNumberViews,lblDuration,lblPrice,txtDescription;
@synthesize m_duration,m_strTitle,m_numberViews,m_price,_img,m_description,m_strVietnameseTitle;
-(IBAction)backPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    
//    
    [self didEndEditingComment:txtComment];
}
-(id)initWithTitle:(NSString *)strTitle vietnameseTitle:(NSString *)vietnamese_title videoId:(NSString*)_id image:(UIImage *)img numberViews:(NSString *)numberViews duration:(NSString *)duration price:(NSString *)price description:(NSString *)description;
{
    if (self = [super init]) {
        self.video_id = _id;
        self.m_duration = duration;
        self.m_strTitle = strTitle;
        self.m_numberViews = numberViews;
        self.m_price = price;
        self._img = img;
        self.m_description = description;
        self.m_strVietnameseTitle = vietnamese_title;
    }
    return self;
}
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
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_OK object:nil];
    
    self.imgFilm = nil;
    self.lblPrice = nil;
    self.lblNumberViews = nil;
    self.lblFilmName = nil;
    self.lblDuration = nil;
    self.txtDescription = nil;
    
    [segmentControl release];
    [txtComment release];
    [tblListComment release];
    [commentView release];
    [relatedVideoView release];
    [tblRelatedVideo release];
    
    SAFE_RELEASE(listCommentParser);
    
    [btnPostComment release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    strUrl = @"";
    
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
    
    // thong tin chi tiet
    webView.hidden = NO;
    commentView.hidden = YES;
    relatedVideoView.hidden = YES;
    
    orginalYofCommentView = commentView.frame.origin.y;
    orginalYofSegmentControl = segmentControl.frame.origin.y;
    orginalHeightOfCommentView = commentView.frame.size.height;
    
    tblListComment.dataSource = self;
    tblListComment.delegate = self;
    relatedVideoView.backgroundColor = [UIColor clearColor];
    
    tblRelatedVideo.delegate = self;
    tblRelatedVideo.dataSource = self;
    tblRelatedVideo.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblRelatedVideo.separatorColor = [UIColor grayColor];
    tblRelatedVideo.backgroundColor = [UIColor clearColor];
    
    txtDescription.backgroundColor = [UIColor clearColor];
    txtDescription.textColor = [UIColor whiteColor];
    
    self.lblDuration.text = m_duration;
    self.lblDuration.hidden = YES;
    
    if (![m_strVietnameseTitle isEqualToString:@""]) {
        self.lblFilmName.text = m_strVietnameseTitle;
    }
    else {
        self.lblFilmName.text = m_strTitle;
    }
    
    
    self.lblNumberViews.text = m_numberViews;
   
    if ([m_price intValue] < 0) {
        lblPrice.hidden = YES;
        imgPrice.hidden = YES;
    } else if ([m_price intValue] == 0) {
        m_price = @"Miễn phí";

        lblPrice.textColor = lblFilmName.textColor;

    }
    self.lblPrice.text = m_price;
    self.imgFilm.image = _img;
    [self.imgFilm.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.imgFilm.layer setBorderWidth:2];
    
    m_description = [m_description stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    webView.backgroundColor = [UIColor clearColor];
    
    webView.opaque = NO;
    
    if ([m_description isEqualToString:@"<font color='white'></font>"]) {
        [webView loadHTMLString:@"<font color='white'>Thông tin video đang được cập nhật</font>" baseURL:nil];
    }
    else {
        [webView loadHTMLString:m_description baseURL:nil];
    }
    
    
    
   // self.txtDescription.text = m_description;
    lblTitle.text = m_strTitle;
    txtDescription.editable = NO;
}



- (void)viewDidUnload
{
    [segmentControl release];
    segmentControl = nil;
    [txtComment release];
    txtComment = nil;
    [tblListComment release];
    tblListComment = nil;
    [commentView release];
    commentView = nil;
    [relatedVideoView release];
    relatedVideoView = nil;
    [tblRelatedVideo release];
    tblRelatedVideo = nil;
    [btnPostComment release];
    btnPostComment = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//    return YES;
//}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
    //return NO;
    
    //return NO;
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

#pragma mark -
#pragma mark REQUEST GET VIDEO URL
-(void)requestGetUrl:(NSString *)_video_id
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoURLOK) name:GET_VIDEO_URL_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoURLError) name:GET_VIDEO_URL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:GET_VIDEO_URL_CONNECTION_FAILED object:nil];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    
    _videoUrlParser = [[VideoUrlParser alloc] init];
    NSString *strRequest = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        strRequest = [NSString stringWithFormat:TVOD_GET_VIDEO_IPAD_URL,_video_id];
    }
    else {
        strRequest = [NSString stringWithFormat:TVOD_GET_VIDEO_URL,_video_id];
    }
    [_videoUrlParser parserWithJSONLink:strRequest];
}
-(void)connectionFailed
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_CONNECTION_FAILED object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
}
-(void)getVideoURLError
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_CONNECTION_FAILED object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
-(void)getVideoURLOK
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_VIDEO_URL_CONNECTION_FAILED object:nil];
    
    strUrl = _videoUrlParser._videoUrlObj.url;
    
    
    //=============LOAD SUB
//    lstSubtitles = [[NSMutableArray alloc] init];
//    
//    _videoUrlParser._videoUrlObj.subtitle = [_videoUrlParser._videoUrlObj.subtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSString *strSub = [NSString stringWithContentsOfURL:[NSURL URLWithString:_videoUrlParser._videoUrlObj.subtitle] encoding:NSUTF8StringEncoding error:nil];
//    
//    [self loadsubfile:strSub];
    //========================END LOAD SUB
    
    g_isRefreshGetUserDetail = TRUE;
    
   
    //_customMoviePlayer = nil;
	_customMoviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:strUrl];
    _customMoviePlayer.delegate = self;
	[self presentModalViewController:_customMoviePlayer animated:YES];
    [_customMoviePlayer readyPlayer]; 
    
}
#pragma mark -
#pragma mark CustomMovieDelegate
-(void)addSubtitle
{
    
    lbl = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        lbl.frame = CGRectMake(-432,472, 1024, 80);
    }
    else {
        lbl.frame = CGRectMake(-200,200, 480, 80);
    }
    
    [lbl setTransform:[self transformForOrientation:UIInterfaceOrientationLandscapeRight]];
      
    
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.text = @"";
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.numberOfLines = 3;
    
    UIWindow *moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    [moviePlayerWindow addSubview:lbl];
    [lbl release];

}
-(void)back
{
    //[_customMoviePlayer.view removeFromSuperview];
    lbl.text = @"";
    lbl = nil;
    [_customMoviePlayer dismissModalViewControllerAnimated:YES];
    [_customMoviePlayer release];
    _customMoviePlayer = nil;
    if (timer) {
        [timer invalidate];
    }
    
    //[moviePlayer.view removeFromSuperview];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)finishPlayVideo
{
    
    lbl.text = @"";
    //[lbl release];
    lbl = nil;
//    //[_customMoviePlayer.view removeFromSuperview];
//    //[_customMoviePlayer dismissModalViewControllerAnimated:YES];
//    //[_customMoviePlayer release];
//    //_customMoviePlayer = nil;
//    if ([timer isValid]) {
    if (timer) {
        [timer invalidate];
    }
   
//    }
    
}
-(void)failedPlayVideo
{
    
    lbl.text = @"";
    lbl = nil;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [_customMoviePlayer.view removeFromSuperview];
    [_customMoviePlayer dismissModalViewControllerAnimated:YES];
    [_customMoviePlayer release];
    _customMoviePlayer = nil;
}
#pragma mark -
#pragma mark Action
-(IBAction)playVideo:(id)sender
{
//    
//    if (_appDelegate.isLogin) {
        NSString *strMessage = [NSString stringWithFormat:@"Đồng ý xem với giá %@",m_price];
        UIAlertView *alertConfirm = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:strMessage delegate:self cancelButtonTitle:@"Bỏ qua" otherButtonTitles:@"Đồng ý", nil];
        alertConfirm.tag = ALERT_CONFIRM_PLAY_MOVIE;
        [alertConfirm show];
        [alertConfirm release];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Bạn cần đăng nhập để xem video" delegate:self cancelButtonTitle:@"Bỏ qua" otherButtonTitles:@"Đăng nhập", nil];
//        alert.tag = ALERT_LOGIN;
//        [alert show];
//        [alert release];
//    }
    //[self requestGetUrl:video_id];
}

- (IBAction)postComment:(UIButton *)sender {
    if ([txtComment.text isEqualToString:@""]){
        return;
    }
    //post comment
    //reload table list Comment after post ok
    [self setupPostCommentObservers];
    [self startLoading];
    
    //http://stackoverflow.com/questions/8088473/url-encode-a-nsstring
    
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)txtComment.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 );
    
    postCommentParser = [[PostCommentParser alloc] init];
    NSString *strRequest = @"";
    strRequest = [NSString stringWithFormat:TVOD_POST_COMMENT_TO_CONTENT_ID,video_id,encodedString];
    [postCommentParser parserWithJSONLink:strRequest];

}

- (IBAction)switchTab:(UISegmentedControl *)sender {
    int i = [segmentControl selectedSegmentIndex];
    switch (i) {
        case 0:
            // thong tin chi tiet
            [txtComment resignFirstResponder];

            [self displayWebAndRelatedView];

            webView.hidden = NO;
            commentView.hidden = YES;
            relatedVideoView.hidden = YES;
            break;
        case 1:
            // binh luan
//            [self displayCommentView];
            [txtComment resignFirstResponder];
            [self getListCommentByVideoId];

            webView.hidden = YES;
            commentView.hidden = NO;
            relatedVideoView.hidden = YES;
            break;
        case 2:
            // phim lien quan
            [txtComment resignFirstResponder];
            [self getListRelatedVideoByVideoIdAtPage:1];
            [self displayWebAndRelatedView];
            
//            [tblRelatedVideo reloadData];
            
            webView.hidden = YES;
            commentView.hidden = YES;
            relatedVideoView.hidden = NO;
            break;
        default:
            break;
    }
    
}

- (IBAction)didBeginEditingComment:(UITextField*)sender {
    
    [self displayCommentView];
}

- (IBAction)didEndEditingComment:(UITextField*)sender {
    
    [sender resignFirstResponder];    
}

- (void) displayWebAndRelatedView {
    CGRect frame = commentView.frame;
    if (frame.origin.y < orginalYofCommentView) { // da bi lui len hoac dai ra
                                                  // => cho day xuong va ngan lai
        
        
        //commentView
        frame = commentView.frame;
        frame.origin.y = orginalYofCommentView;
        frame.size.height = orginalHeightOfCommentView;
        commentView.frame = frame;
        
        //segment control
        frame = segmentControl.frame;
        frame.origin.y = orginalYofSegmentControl;
        segmentControl.frame = frame;
    }
}
- (void) displayCommentView {
    CGRect frame = commentView.frame;
    
    if (frame.origin.y == orginalYofCommentView) { // chua lui len + dai ra 
                                                   // => cho lui len + cho dai them
        
        // segment control
        frame = segmentControl.frame;
        frame.origin.y = orginalYofSegmentControl - 100;
        segmentControl.frame = frame;
        
        //comment view
        frame = commentView.frame;
        frame.origin.y = orginalYofCommentView - 100;
        frame.size.height = orginalHeightOfCommentView + 100;
        commentView.frame = frame;
        
        //get list comments
        
    }
}

#pragma mark - 
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_CONFIRM_PLAY_MOVIE) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self requestGetUrl:video_id];
                break;
            default:
                break;
        }
    }
//    else if(alertView.tag == ALERT_LOGIN)
//        {
//        switch (buttonIndex) {
//            case 0:
//                break;
//            case 1:
//                UserViewController *viewController = [[UserViewController alloc] init];
//                viewController.isFromMovieDetail = TRUE;
//                [self.navigationController pushViewController:viewController animated:YES];
//                [viewController release];
//                break;
//            default:
//                break;
//        }
//        
//        }
}


-(void)moviePlayBackDidFinish:(NSNotification *)objNotification{
    
    [timer invalidate];
    NSNumber *reason = [objNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil){
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:
            {
                /* The movie ended normally */
                
                
                break; 
            }
            case MPMovieFinishReasonPlaybackError:
            {
                /* An error happened and the movie ended */
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thong bao" message:@"An error happened" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
                if ([moviePlayerViewCtrl.moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
                    [moviePlayerViewCtrl dismissModalViewControllerAnimated:YES];
                }
                [_customMoviePlayer dismissModalViewControllerAnimated:YES];
                break; 
            }
            case MPMovieFinishReasonUserExited:
            { /* The user exited the player */
                
                if ([moviePlayerViewCtrl.moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
                    [moviePlayerViewCtrl dismissModalViewControllerAnimated:YES];
                }
                [_customMoviePlayer dismissModalViewControllerAnimated:YES];
                break; 
            }
        }
        
        /*
        if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {  
            [moviePlayer.view removeFromSuperview];  
        } 
         */
        
    } /* if (reason != nil){ */
}

#pragma mark -
#pragma mark Subtitle
-(void) loadsubfile:(NSString *)strData
{
    // var data;
    
    //get duoc strdata = data
    
    
    NSString *_str;
//    _str = [strData stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
//    _str = [strData stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
//    _str = [strData stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];
    _str = strData;
    
    _str = [self strip:_str];    
    
    
    NSArray *arrSubObj = [_str componentsSeparatedByString:@"\r\n\r\n"];
    
    
    for (int i=0; i<[arrSubObj count]; i++) {
        NSString *tmp = [arrSubObj objectAtIndex:i];
        
        NSArray *arrSubItem = [tmp componentsSeparatedByString:@"\n"];
        if ([arrSubItem count] >=3) 
        {
            // 
            NSString *timeStr = [arrSubItem objectAtIndex:1];
            NSArray *arrTime = [timeStr componentsSeparatedByString:@" --> "];
            
            SubtitleObj *obj = [[SubtitleObj alloc] init];
            if ([arrTime count] ==2) {
                obj.inSecond = [NSString stringWithFormat:@"%f",[self toSecond:[arrTime objectAtIndex:0]]];
                
                obj.outSecond = [NSString stringWithFormat:@"%f",[self toSecond:[arrTime objectAtIndex:1]]];
            }
            obj.content = [arrSubItem objectAtIndex:2];
            if ([arrSubItem count] > 3) {
                for (int j=3; j<[arrSubItem count]; j++) {
                    obj.content = [obj.content stringByAppendingString:[arrSubItem objectAtIndex:j]];
                }
            }
            [lstSubtitles addObject:obj];
            [subtitles setValue:obj forKey:obj.inSecond];
            [obj release];
        }
        
    }

    _startIndexSub = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(displaySubtitle) userInfo:nil repeats:YES];
    
}
-(void)displaySubtitle
{
    
    
    currentTime = [_customMoviePlayer.mp currentPlaybackTime];
    
    for (int i=0; i<[lstSubtitles count]; i++) {
        SubtitleObj *obj = [lstSubtitles objectAtIndex:i];
        if (fabs([obj.inSecond floatValue]- currentTime) <= 0.2) {
            lbl.text = obj.content;//str_sub;
            //_startIndexSub = i;
            
            break;
            //[lstSubtitles removeObjectAtIndex:i];
        }
        
        if (fabs([obj.outSecond floatValue] - currentTime)< 0.2) {
            lbl.text = @"";
            [lstSubtitles removeObjectAtIndex:i];
            break;
        }
    }
}

-(float) toSecond:(NSString *)time
{
    float second = 0.0;
    if(time)
    {
        NSArray *arr = [time componentsSeparatedByString:@":"];
        for (int i = 0; i<[arr count]; i++) {
            NSString *tmp = [arr objectAtIndex:i];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"," withString:@"."];
            second = 60 *second + [tmp floatValue];
        }
    }
    return second;
}
-(NSString *) strip:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark -
#pragma mark Transform

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    
    switch (orientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}

- (void)rotateViewAccordingToStatusBarOrientation:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self transformForOrientation:orientation];
    
    [lbl setTransform:[self transformForOrientation:orientation]];
    
}
#pragma mark -
#pragma ADD FAVORITE
- (void) setupFavoriteObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToFavoriteOK) name:ADD_TO_FAVORITE_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToFavoriteFailed) name:ADD_TO_FAVORITE_FAILED object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToFavoriteError) name:ADD_TO_FAVORITE_ERROR object:nil];

}
- (void) removeFavoriteObservers{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ADD_TO_FAVORITE_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ADD_TO_FAVORITE_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ADD_TO_FAVORITE_FAILED object:nil];
}
- (void) addToFavorite:(id)sender{
    [self setupFavoriteObservers];
    [self startLoading];
    
    addToFavoriteParser = [[AddToFavoriteParser alloc] init];
    NSString *strRequest = @"";
    strRequest = [NSString stringWithFormat:TVOD_ADD_CONTENT_ID_TO_FAVORITE,video_id];
    [addToFavoriteParser parserWithJSONLink:strRequest];
    
    return;
}
- (void) addToFavoriteOK {
    [self bringMessage:@"Nội dung này đã được thêm vào \"Cá nhân -> Danh sách ưu thích\" của bạn."];
    [self removeFavoriteObservers];
    [self stopLoading];
}
- (void) addToFavoriteError{
//    [self bringMessage:@"Bạn đã từng thêm nội dung này trước đó."];    
    [self bringMessage:@"Nội dung này đã được thêm vào \"Cá nhân -> Danh sách ưu thích\" của bạn."];

    [self removeFavoriteObservers];
    [self stopLoading];
}
- (void) addToFavoriteFailed {
//    [self bringMessage:@"Lỗi kết nối!"];
    [self removeFavoriteObservers];
    [self stopLoading];
}
- (void) bringMessage:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
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
#pragma mark -
#pragma mark TABLE LIST COMMENT

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentControl.selectedSegmentIndex == 1) {
        return 70;
    } else {
        return 85;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentControl.selectedSegmentIndex == 1) {
        return [listComment count];
    } else {
        return [lstRelateVideo count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
	}
    
    if (segmentControl.selectedSegmentIndex == 1) {
        if ([listComment count] == 0) {
            tableView.separatorColor = [UIColor clearColor];
            return cell;
        }
        CommentObject *obj = nil;
        if (listComment){
            obj = [listComment objectAtIndex:indexPath.row];
            cell.textLabel.text = obj.name;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = obj.body_value;
            cell.imageView.image = [UIImage imageNamed:@"user.png"];
            
        }
    } 
    else if (segmentControl.selectedSegmentIndex == 2) {
        if ([lstRelateVideo count] == 0) {
            tableView.separatorColor = [UIColor clearColor];
            return cell;
        }
        VideoObject *obj;
        if (lstRelateVideo){
            obj = [lstRelateVideo objectAtIndex:indexPath.row];
            if ([_type isEqualToString:kTypeVideo]) {
                cell.textLabel.text = obj.video_english_title;
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@\n%@ lượt xem",obj.video_vietnamese_title,obj.video_number_views];
                
                InternetResource *iResource = nil;
                if ([lstRelatedResource count] >=(indexPath.row +1)) {
                    iResource = [lstRelatedResource objectAtIndex:indexPath.row];
                }
            
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
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
                            cell.accessoryView = imageView;
                            [imageView release];
                            
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

            }
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [txtComment resignFirstResponder];
    [self displayWebAndRelatedView];
    if (segmentControl.selectedSegmentIndex == 2) {
        VideoObject *obj;
        InternetResource *objResource;
        
        obj = [lstRelateVideo objectAtIndex:indexPath.row];
        objResource = [lstRelatedResource objectAtIndex:indexPath.row];
        
        UIImage *img = objResource.image;

        MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:obj.video_english_title vietnameseTitle:obj.video_vietnamese_title videoId:obj.video_id image:img numberViews:obj.video_number_views duration:obj.video_duration price:obj.video_price description:obj.video_description];
        
        [img release];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark -
#pragma mark LIST RELATED
- (void) getListRelatedVideoByVideoIdAtPage:(int) page {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_VIDEO];
    
    [self initGetListVideoNotification];
    [self startLoading];
        
    if (_listVideoParser == nil) {
        _listVideoParser = [[ListVideoParser alloc] init];
    }
    [_listVideoParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_LIST_RELATED_BY_CONTENT_ID,video_id,page]];
    
}

-(void)handleFinishedLoadingImage:(NSNotification*)notification{
    
	[self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
}
-(void)reloadTable:(InternetResource*)_resource{
	[tblRelatedVideo reloadData];
}

-(void)getListVideoFailed
{
    [self stopLoading];  
    [self removeGetListVideoNotification];
}

-(void)getListVideoError
{
    
    [self stopLoading];
    [self removeGetListVideoNotification];
    
}

-(void)getListVideoOK
{
    [self stopLoading];
    
    [self removeGetListVideoNotification];
    
    _type = [_listVideoParser._listVideoObj._type retain];
    
    totalRelatedVideo = _listVideoParser._listVideoObj.total_quantity;
    totalRelatedPage = (int)(totalRelatedVideo/25);
    if ((totalRelatedVideo%25)>0){
        totalRelatedPage++;
    }
    
    if (lstRelateVideo == nil) {
        lstRelatedResource = [[NSMutableArray alloc] init];
        lstRelateVideo = [_listVideoParser._listVideoObj.lstVideoItems retain];
        for (int i=0; i<[lstRelateVideo count]; i++) {
            VideoObject *obj = [lstRelateVideo objectAtIndex:i];
            InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"" andURL:obj.video_picture_path] autorelease];
            iResource.receiver = TVOD_GET_LIST_VIDEO;
            [lstRelatedResource addObject:iResource];
            
        }
    }
    else
        {
            for (int i=0; i<[_listVideoParser._listVideoObj.lstVideoItems count]; i++) {
                VideoObject *obj = [_listVideoParser._listVideoObj.lstVideoItems objectAtIndex:i];
                [lstRelateVideo addObject:obj];
                
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"" andURL:obj.video_picture_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_VIDEO;
                [lstRelatedResource addObject:iResource];
            }
        }
    if (_listVideoParser) {
        [_listVideoParser release];
        _listVideoParser = nil;
    }
    [tblRelatedVideo reloadData];
}

-(void)initGetListVideoNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideoOK) name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideoError) name:GET_LIST_VIDEO_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideoFailed) name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
}
-(void)removeGetListVideoNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_ERROR object:nil];
}

#pragma mark -
#pragma mark LIST COMMENT
- (void) getListCommentByVideoId {
    [self startLoading];
    [self setupListCommentObservers];
    listCommentParser = [[ListCommentParser alloc] init];
    NSString *strRequest = @"";
    strRequest = [NSString stringWithFormat:TVOD_LIST_COMMENTS_OF_CONTENT_ID,video_id,1];//page = 1
    [listCommentParser parserWithJSONLink:strRequest];
}

- (void) setupListCommentObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCommentOK) name:LIST_COMMENT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCommentFailed) name:LIST_COMMENT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCommentError) name:LIST_COMMENT_ERROR object:nil];
    
}
- (void) removeListCommentObservers{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LIST_COMMENT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LIST_COMMENT_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LIST_COMMENT_FAILED object:nil];
}
- (void) listCommentOK {
    [self stopLoading];
    [self removeListCommentObservers];
    //reload table list comment
    listComment = [listCommentParser._listCommentObj.lstCommentItems retain];
    [tblListComment reloadData];
    
}
- (void) listCommentFailed {
//    [self bringMessage:@"Lỗi kết nối!"];
    [self removeListCommentObservers];
    [self stopLoading];
}
- (void) listCommentError {
//    [self bringMessage:@"Không tải được các bình luận của nội dung này!"];
    [self removeListCommentObservers];
    [self stopLoading];
}
#pragma mark -
#pragma mark POST COMMENT
- (void) setupPostCommentObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentOK) name:POST_COMMENT_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentFailed) name:POST_COMMENT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentError) name:POST_COMMENT_ERROR object:nil];
}
- (void) removePostCommentObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:POST_COMMENT_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:POST_COMMENT_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:POST_COMMENT_FAILED object:nil];
}
- (void) postCommentOK {
    [self removePostCommentObservers];
    
    // reload table comment
    
    [self stopLoading];
    [self bringMessage:@"Bình luận của bạn đã được ghi nhận!"];
    txtComment.text = @"";
    txtComment.enabled = NO;
    btnPostComment.enabled = NO;
    
//    [self getListCommentByVideoId];
    //[tblListComment reloadData];

}
- (void) postCommentError {
//    [self bringMessage:@"Bạn không thể bình luận cho nội dung này!"];
    [self removePostCommentObservers];
    [self stopLoading];
}
- (void) postCommentFailed {
//    [self bringMessage:@"Lỗi kết nối!"];
    [self removePostCommentObservers];
    [self stopLoading];
}

@end
