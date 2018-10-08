
//  ListVideoViewController.m
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ListVideoViewController.h"
#import "ListVideosByDramaParser.h"

@implementation ListVideoViewController
@synthesize tblListVideo;
@synthesize strID;
@synthesize _type;
@synthesize lblTitle;
@synthesize parent_category_title;

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCategoryId:(NSString *)str_category_id parent_title: (NSString *) parent_title
{
    if (self=[super init]) {
        strID = str_category_id;
        parent_category_title = parent_title;
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
    
    SAFE_RELEASE(_listVideoParser);
//    SAFE_RELEASE(selectedDramaObject);
    SAFE_RELEASE(_type);
    SAFE_RELEASE(lstNewestResources);
    SAFE_RELEASE(lstMostViewResources);
    SAFE_RELEASE(lstImages);
    SAFE_RELEASE(lstNewestVideo);
    SAFE_RELEASE(lstMostViewVideo);
    SAFE_RELEASE(_listVideoParser);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    selectedDramaObject = nil;
    
    // Do any additional setup after loading the view from its nib.
    
    
    lblTitle.text = parent_category_title;
    
    tblListVideo.delegate = self;
    tblListVideo.dataSource = self;
    tblListVideo.backgroundColor = [UIColor clearColor];
    

    
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    
    currentNewestPage = 1;
    currentMostViewPage = 1;
    
    currentFavoritePage = 1;
    
    currentRandomPage = 1;
    
    totalNewestPages = 0;
    totalNewestVideos = 0;
    
    totalMostViewVideos = 0;
    totalMostViewPages = 0;
    
    currentFilterType = FILTER_NEWEST;
    
    lstNewestResources = [[NSMutableArray alloc] init];
    lstMostViewResources = [[NSMutableArray alloc] init];
    
    lstNewestDramaResources = [[NSMutableArray alloc] init];
    lstMostViewDramaResources = [[NSMutableArray alloc] init];
    
    
    
    if ([strID isEqualToString:DRAMA_ID]) {
        
        isDrama = TRUE;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_DRAMA];
        
        [self requestGetListDrama:FILTER_NEWEST page:currentNewestPage];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_VIDEO];
        
        [self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
    }
     
}
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}
#pragma mark -
#pragma mark Notification Get Image
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
    
	[self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
}
-(void)reloadTable:(InternetResource*)_resource{
	[tblListVideo reloadData];
}
#pragma mark -
#pragma mark GET LIST PHIM BO
-(void)requestGetListDrama:(NSString *)_filter page:(int)_page
{
    [self initGetListDramaNotification];
    [self addLoading];
    
    currentFilterType = _filter;
    
    if (_dramaParser == nil) {
        _dramaParser = [[DramaParser alloc] init];
    }
    [_dramaParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_LIST_DRAMA,_filter,_page]];
}
-(void)getListDramaOK
{
    
    [self removeLoading];
    [self removeGetListDramaNotification];
    
    if (currentFilterType == FILTER_NEWEST) {
        totalNewestDramas = [_dramaParser._listDramaObj.total_quantity intValue];
        totalNewestDramaPages = ceil(totalNewestDramas*1.0/25);
        if (currentNewestPage == totalNewestDramaPages) {
            btnShowMore.hidden = YES;
        }
        else
        {
            btnShowMore.hidden = NO;
        }
        
        if (lstNewestDramas == nil) {
            lstNewestDramas = [_dramaParser._listDramaObj.lstDrama retain];
            int _length = [lstNewestDramas count];
            for (int i=0; i<_length; i++) {
                DramaObj *obj = [lstNewestDramas objectAtIndex:i];
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.drama_image_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_DRAMA;
                [lstNewestDramaResources addObject:iResource];
                
            }
        }
        else
        {
            int _length = [_dramaParser._listDramaObj.lstDrama count];
            for (int i=0; i<_length; i++) {
                DramaObj *obj = [_dramaParser._listDramaObj.lstDrama objectAtIndex:i];
                [lstNewestDramas addObject:obj];
                
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.drama_image_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_DRAMA;
                [lstNewestDramaResources addObject:iResource];
                
                
            }
        }
        [_dramaParser release];
        _dramaParser = nil;
        
        
        //[lstNewestResources removeAllObjects];
        
        
    }
    else if(currentFilterType == FILTER_MOST_VIEW)
    {
        totalMostViewDramas = [_dramaParser._listDramaObj.total_quantity intValue];
        totalMostViewDramaPages = ceil(totalMostViewDramas*1.0/25);
        
        if (currentMostViewPage == totalMostViewDramaPages) {
            btnShowMore.hidden = YES;
        }
        else
        {
            btnShowMore.hidden = NO;
        }
        
        if (lstMostViewDrama == nil) {
            lstMostViewDrama = [_dramaParser._listDramaObj.lstDrama retain];
            int _length = [lstMostViewDrama count];
            for (int i=0; i<_length; i++) {
                DramaObj *obj = [lstMostViewDrama objectAtIndex:i];
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.drama_image_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_DRAMA;

                [lstMostViewDramaResources addObject:iResource];
                
            }
        }
        else
        {
            int _length = [_dramaParser._listDramaObj.lstDrama count];
            for (int i=0; i< _length; i++) {
                DramaObj *obj = [_dramaParser._listDramaObj.lstDrama objectAtIndex:i];
                [lstMostViewDrama addObject:obj];
                
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.drama_image_path] autorelease];               
                iResource.receiver = TVOD_GET_LIST_DRAMA;

                [lstMostViewDramaResources addObject:iResource];
            }
        }
        [_dramaParser release];
        _dramaParser = nil;
        
        //lstImages = [[NSMutableArray alloc] init];
        // [lstMostViewResources removeAllObjects];
        
    }
    
    [tblListVideo reloadData];
}
-(void)getListDramaError
{
    
    [self removeLoading];
    [self removeGetListDramaNotification];
}
-(void)getListDramaConnectionFailed
{
    
    [self removeLoading];
    [self removeGetListDramaNotification];
}
-(void)connectionFailed
{
    [self removeGetListVideoNotification];
    [self removeLoading];
}

-(void)initGetListDramaNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListDramaOK) name:GET_LIST_DRAMA_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListDramaError) name:GET_LIST_DRAMA_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListDramaConnectionFailed) name:GET_LIST_DRAMA_CONNECTION_FAILED object:nil];
}
-(void)removeGetListDramaNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_LIST_DRAMA_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_DRAMA_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_DRAMA_ERROR object:nil];
}
#pragma mark -
#pragma mark GET LIST VIDEO
-(void)requestGetListVideoFollowDrama:(NSString *)_filter withId:(NSString *)_id page:(int)_page
{
//    
//    if (selectedDramaObject){
//        ListVideosByDramaViewController *listVideosByDramaVC = [[ListVideosByDramaViewController alloc] initWithDramaObject: selectedDramaObject];
//            
//        [self.navigationController pushViewController:listVideosByDramaVC animated:YES];
//            
//        [listVideosByDramaVC release];
//        
//    }else{
    
        [self initGetListVideoNotification];
        [self addLoading];
        
        currentFilterType = _filter;
        
        if (_listVideoParser == nil) {
            _listVideoParser = [[ListVideoParser alloc] init];
        }
        [_listVideoParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_LIST_VIDEO_BY_DRAMA,_filter,_id,_page]];
//    }
}
-(void)requestGetListVideo:(NSString *)_filter page:(int)_page
{
    [self initGetListVideoNotification];
    [self addLoading];
   
    currentFilterType = _filter;
        
    if (_listVideoParser == nil) {
        _listVideoParser = [[ListVideoParser alloc] init];
    }
    [_listVideoParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_LIST_VIDEO,strID,_filter,_page]];
}

-(void)getListVideoOK
{
    
    
    [self removeLoading];
    
    [self removeGetListVideoNotification];
    
    //newest
    
    _type = [_listVideoParser._listVideoObj._type retain];
    
    if (currentFilterType == FILTER_NEWEST) {
       
        totalNewestVideos = _listVideoParser._listVideoObj.total_quantity;
        totalNewestPages = ceil(totalNewestVideos*1.0/25);
       
        
        if (currentNewestPage == totalNewestPages) {
            btnShowMore.hidden = YES;
        }
        else
        {
            btnShowMore.hidden = NO;
        }
        
        if (lstNewestVideo == nil) {
            lstNewestVideo = [_listVideoParser._listVideoObj.lstVideoItems retain];
            for (int i=0; i<[lstNewestVideo count]; i++) {
                VideoObject *obj = [lstNewestVideo objectAtIndex:i];
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_VIDEO;
                [lstNewestResources addObject:iResource];
                
            }
        }
        else
        {
            for (int i=0; i<[_listVideoParser._listVideoObj.lstVideoItems count]; i++) {
                VideoObject *obj = [_listVideoParser._listVideoObj.lstVideoItems objectAtIndex:i];
                [lstNewestVideo addObject:obj];
                
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_VIDEO;
                [lstNewestResources addObject:iResource];
                    
                
            }
        }
        [_listVideoParser release];
        _listVideoParser = nil;
        

        //[lstNewestResources removeAllObjects];
       

    }
    else if(currentFilterType == FILTER_MOST_VIEW)
    {
        
        totalMostViewVideos = _listVideoParser._listVideoObj.total_quantity;
        totalMostViewPages = ceil(totalMostViewVideos*1.0/25);
        
        
        
        if (currentMostViewPage == totalMostViewPages) {
            btnShowMore.hidden = YES;
        }
        else
        {
            btnShowMore.hidden = NO;
        }
        
        if (lstMostViewVideo == nil) {
            lstMostViewVideo = [_listVideoParser._listVideoObj.lstVideoItems retain];
            for (int i=0; i<[lstMostViewVideo count]; i++) {
                VideoObject *obj = [lstMostViewVideo objectAtIndex:i];
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_VIDEO;
                [lstMostViewResources addObject:iResource];
                
            }
        }
        else
        {
            for (int i=0; i<[_listVideoParser._listVideoObj.lstVideoItems count]; i++) {
                VideoObject *obj = [_listVideoParser._listVideoObj.lstVideoItems objectAtIndex:i];
                [lstMostViewVideo addObject:obj];
                
                InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
                iResource.receiver = TVOD_GET_LIST_VIDEO;
                [lstMostViewResources addObject:iResource];
            }
        }
        [_listVideoParser release];
        _listVideoParser = nil;
        
        //lstImages = [[NSMutableArray alloc] init];
       // [lstMostViewResources removeAllObjects];
       
    }
    
    [tblListVideo reloadData];
}
-(void)getListVideoError
{
    
    [self removeLoading];
    [self removeGetListVideoNotification];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thong bao" message:@"Loi ket noi" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//    [alert show];
//    [alert release];
     btnShowMore.hidden = YES;
    [_listVideoParser release];
    _listVideoParser = nil;
    [tblListVideo reloadData];
}

-(void)initGetListVideoNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideoOK) name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideoError) name:GET_LIST_VIDEO_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
}
-(void)removeGetListVideoNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_LIST_VIDEO_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEO_ERROR object:nil];
}
-(void)addLoading
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
}
-(void)removeLoading
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
#pragma mark -
#pragma mark UITableVide Delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 75;
    }
    else {
         return  100;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number_section = 0;
    if ([strID isEqualToString:DRAMA_ID]) {
        if (currentFilterType == FILTER_NEWEST) {
            number_section = [lstNewestDramas count];
        }
        else if(currentFilterType == FILTER_MOST_VIEW)
        {
            number_section = [lstMostViewDrama count];
        }
    }
    else {
        if (currentFilterType == FILTER_NEWEST) {
            number_section = [lstNewestVideo count];
        }
        else if(currentFilterType == FILTER_MOST_VIEW)
        {
            number_section = [lstMostViewVideo count];
        }
    }
    return number_section;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    
	}
    //DRAMA
    if ([strID isEqualToString:DRAMA_ID]) {
        DramaObj *obj = nil;
        InternetResource *iResource = nil;
        
        if (currentFilterType == FILTER_NEWEST) {
            obj = [lstNewestDramas objectAtIndex:indexPath.row];
            if ([lstNewestDramaResources count] >=(indexPath.row +1)) {
                iResource = [lstNewestDramaResources objectAtIndex:indexPath.row];              
            }
        }
        else if(currentFilterType == FILTER_MOST_VIEW)
        {
            obj = [lstMostViewDrama objectAtIndex:indexPath.row];
            if ([lstMostViewDramaResources count] >=(indexPath.row +1)) {
                iResource = [lstMostViewDramaResources objectAtIndex:indexPath.row];
            }
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
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",obj.drama_english_title];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@\n%@ tập phim",obj.drama_vietnamese_title,obj.drama_quantity];
                
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
            cell.contentView.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
            cell.accessoryView = imageView;
            [imageView release];
            [tableView setSeparatorColor:[UIColor grayColor]];
        

//        if (indexPath.row%2 == 0) {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.1];
//        }
//        else {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        }

    }
    else { //Video
        VideoObject *obj = nil;
        InternetResource *iResource = nil;
        
        if (currentFilterType == FILTER_NEWEST) {
            obj = [lstNewestVideo objectAtIndex:indexPath.row];
            if ([lstNewestResources count] >=(indexPath.row +1)) {
                iResource = [lstNewestResources objectAtIndex:indexPath.row];              
            }
        }
        else if(currentFilterType == FILTER_MOST_VIEW)
        {
            obj = [lstMostViewVideo objectAtIndex:indexPath.row];
            if ([lstMostViewResources count] >=(indexPath.row +1)) {
                iResource = [lstMostViewResources objectAtIndex:indexPath.row];
            }
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
        
        
        if ([_type isEqualToString:kTypeVideo]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",obj.video_english_title];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@\n%@ lượt xem",obj.video_vietnamese_title,obj.video_number_views];
        }
        else if([_type isEqualToString:kTypeLiveStreaming]){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",obj.live_channel_title];
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@ lượt xem",obj.live_channel_number_view];
        }
        else if([_type isEqualToString:kTypeNews]){
            NSString *strTitle = [NSString stringWithFormat:@"%@",obj.news_title];
            strTitle = [strTitle stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cell.textLabel.numberOfLines = 3;
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            cell.textLabel.text = strTitle;
            
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@ lượt xem",obj.news_number_view];
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
            cell.accessoryView = imageView;
            [imageView release];
            [tableView setSeparatorColor:[UIColor grayColor]];
        
        
//        if (indexPath.row%2 == 0) {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.1];
//        }
//        else {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        }

    }
    
   	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![strID isEqualToString:DRAMA_ID]) {
        VideoObject *obj;
        InternetResource *objResource;
        if (currentFilterType == FILTER_NEWEST) {
            obj = [lstNewestVideo objectAtIndex:indexPath.row];
            objResource = [lstNewestResources objectAtIndex:indexPath.row];
        }
        else {
            obj = [lstMostViewVideo objectAtIndex:indexPath.row];
            objResource = [lstMostViewResources objectAtIndex:indexPath.row];
        }
        
        if ([_type isEqualToString:kTypeVideo]) {
            selectedVideoId = obj.video_id;
            
            NSString *strTitle = obj.video_english_title;
            NSString *strVietnameseTitle = obj.video_vietnamese_title;
            int intTmpDuration = [obj.video_duration intValue];
            
            int duration_minutes = ceil(intTmpDuration*1.0/60);
            
            NSString *duration = [NSString stringWithFormat:@"Thời lượng: %d phút",duration_minutes];
            
            NSString *numberViews = [NSString stringWithFormat:@"%@ lượt xem",obj.video_number_views];
            NSString *price = [NSString stringWithFormat:@"Giá %@ xu",obj.video_price];
            NSString *description = [NSString stringWithFormat:@"%@",obj.video_description];
            NSString *_id = [NSString stringWithFormat:@"%@",obj.video_id];
            
            
            UIImage *img = objResource.image;
            
            
            MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:strTitle vietnameseTitle:strVietnameseTitle videoId:_id image:img numberViews:numberViews duration:duration price:price description:description];
            
            [img release];
            
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        else if([_type isEqualToString:kTypeLiveStreaming]){
            
            NSString *strLiveStream = [NSString stringWithFormat:@"%@/%@.m3u8",obj.live_channel_url,obj.live_channel_folder];
            
            
            _customMoviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:strLiveStream];
            _customMoviePlayer.delegate = self;
            [self presentModalViewController:_customMoviePlayer animated:YES];
            [_customMoviePlayer readyPlayer];
        }
        else if ([_type isEqualToString:kTypeNews]) {
            
            UIImage *imgResource = objResource.image;
            NewsDetailViewController *viewController = [[NewsDetailViewController alloc] initWithTitle:obj.news_title news_image:imgResource news_content:obj.news_content];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            
        }
    }
    else {
        isDrama = FALSE;
        isGetVideoFollowDrama = TRUE;
        DramaObj *obj;
        if (currentFilterType == FILTER_NEWEST) {
            obj = [lstNewestDramas objectAtIndex:indexPath.row];
        }else{
            obj = [lstMostViewDrama objectAtIndex:indexPath.row];
        }
//        


        ListVideosByDramaViewController *listVideosByDramaVC = [[[ListVideosByDramaViewController alloc] initWithDramaObject: [obj retain] dramaAvartar: [tableView cellForRowAtIndexPath:indexPath].imageView.image]retain];
        
        [self.navigationController pushViewController:listVideosByDramaVC animated:YES];
//        [obj autorelease];
        [listVideosByDramaVC release];
        
        /*
        if (currentFilterType == FILTER_NEWEST) {
            obj = [lstNewestDramas objectAtIndex:indexPath.row];
            selectedDramaObject = [lstNewestDramas objectAtIndex:indexPath.row]; 
            strID = obj.drama_id;
            currentNewestPage = 1;
            //[self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
            // currentFilterType = FILTER_NEWEST;
            [self requestGetListVideoFollowDrama:currentFilterType withId:obj.drama_id page:currentNewestPage];
        }
        else {
            obj = [lstMostViewDrama objectAtIndex:indexPath.row];
            selectedDramaObject = [lstMostViewDrama objectAtIndex:indexPath.row];
            strID = obj.drama_id;
            currentMostViewPage = 1;
            //[self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
            // currentFilterType = FILTER_NEWEST;
            [self requestGetListVideoFollowDrama:currentFilterType withId:obj.drama_id page:currentMostViewPage];
        }
        */
        //strID = obj.drama_id;
        //currentNewestPage = 1;
        //[self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
       // currentFilterType = FILTER_NEWEST;
       // [self requestGetListVideoFollowDrama:currentFilterType withId:obj.drama_id page:currentNewestPage];
        //ListVideoViewController *viewController = [[ListVideoViewController alloc] init];
        //viewController.strID = obj.drama_id;
        //[self.navigationController pushViewController:viewController animated:YES];
        //[viewController release];
    }
   
}
#pragma mark -
#pragma mark CustomMovie delegate
-(void)failedPlayVideo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Có lỗi xảy ra" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}
-(void)finishPlayVideo
{
    [_customMoviePlayer release];
    _customMoviePlayer = nil;
}
-(void)addSubtitle
{
    
}
-(void)back
{
    
    [_customMoviePlayer dismissModalViewControllerAnimated:YES];
    [_customMoviePlayer release];
    _customMoviePlayer = nil;
}
#pragma mark -
#pragma mark Action
-(IBAction)changeFilter:(id)sender
{
    
//    [[[segmentControl subviews] objectAtIndex:(1 - segmentControl.selectedSegmentIndex)] setTintColor:[UIColor grayColor]];
//    
//    [[[segmentControl subviews] objectAtIndex:segmentControl.selectedSegmentIndex] setTintColor:[UIColor blackColor]];
    
    int index = [sender selectedSegmentIndex] + 1;
	
    switch (index) {
        case 1:
            
            
            currentFilterType = FILTER_NEWEST;
            if (isDrama == TRUE) {
                if (currentNewestPage == totalNewestDramaPages) {
                    btnShowMore.hidden = YES;
                }
                else {
                    btnShowMore.hidden = NO;
                }

            }
            else {
                if (currentNewestPage == totalNewestPages) {
                    btnShowMore.hidden = YES;
                }
                else {
                    btnShowMore.hidden = NO;
                }
            }
            [self displayNewest];
            break;
        case 2:
            
            currentFilterType = FILTER_MOST_VIEW;
            if (isDrama == TRUE) {
                if (currentMostViewPage == totalMostViewDramaPages) {
                    btnShowMore.hidden = YES;
                }
                else {
                    btnShowMore.hidden = NO;
                }
            }
            else{
                if (currentMostViewPage == totalMostViewPages) {
                    btnShowMore.hidden = YES;
                }
                else {
                    btnShowMore.hidden = NO;
                }
            }
            [self displayMostView];
            break;
        case 3:
            
            currentFilterType = FILTER_FAVORITE;
            [self displayFavorite];
            break;
        case 4:
            
            currentFilterType = FILTER_RANDOM;
            [self displayRandom];
            break;
        default:
            break;
    }
}
-(void)displayNewest
{
    if (isDrama == TRUE) {
        if ([lstNewestDramas count] == 0) 
        {
           // [self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
            [self requestGetListDrama:FILTER_NEWEST page:currentNewestPage];
            currentFilterType = FILTER_NEWEST;
        }
        else
        {
            currentFilterType = FILTER_NEWEST;
            [tblListVideo reloadData];
        }

    }
    else 
    {
        if (isGetVideoFollowDrama == TRUE) {
            if ([lstNewestVideo count] == 0) 
            {
                //[self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
                [self requestGetListVideoFollowDrama:FILTER_NEWEST withId:strID page:currentNewestPage];
                currentFilterType = FILTER_NEWEST;
            }
            else
            {
                currentFilterType = FILTER_NEWEST;
                [tblListVideo reloadData];
            }
        }
        else {
            if ([lstNewestVideo count] == 0) 
            {
                [self requestGetListVideo:FILTER_NEWEST page:currentNewestPage];
                currentFilterType = FILTER_NEWEST;
            }
            else
            {
                currentFilterType = FILTER_NEWEST;
                [tblListVideo reloadData];
            }
        }

    }
}
-(void)displayMostView
{
    if (isDrama == TRUE) {
        if ([lstMostViewDrama count] == 0) 
        {
            currentFilterType = FILTER_MOST_VIEW;
            //[self requestGetListVideo:FILTER_MOST_VIEW page:currentMostViewPage];
            [self requestGetListDrama:FILTER_MOST_VIEW page:currentMostViewPage];
        }
        else
        {
            currentFilterType = FILTER_MOST_VIEW;
            [tblListVideo reloadData];
        }
    }
    else 
    {
        if (isGetVideoFollowDrama == TRUE) {
            if ([lstMostViewVideo count] == 0) {
                currentFilterType = FILTER_MOST_VIEW;
                //[self requestGetListVideo:FILTER_MOST_VIEW page:currentMostViewPage];
                [self requestGetListVideoFollowDrama:FILTER_MOST_VIEW withId:strID page:currentMostViewPage];
            }
            else
            {
                currentFilterType = FILTER_MOST_VIEW;
                [tblListVideo reloadData];
            }
        }
        else{
            if ([lstMostViewVideo count] == 0) {
                currentFilterType = FILTER_MOST_VIEW;
                [self requestGetListVideo:FILTER_MOST_VIEW page:currentMostViewPage];
            }
            else
            {
                currentFilterType = FILTER_MOST_VIEW;
                [tblListVideo reloadData];
            }
        }
    }
    
}
-(void)displayFavorite
{
    [self requestGetListVideo:FILTER_FAVORITE page:currentFavoritePage];
}
-(void)displayRandom
{
    [self requestGetListVideo:FILTER_RANDOM page:currentRandomPage];
}
-(IBAction)showMore:(id)sender
{
    
    if ([strID isEqualToString:DRAMA_ID]) 
    {
        if (currentFilterType == FILTER_NEWEST) {
            if (currentNewestPage<totalNewestDramaPages) {
                currentNewestPage ++;
                [self requestGetListDrama:currentFilterType page:currentNewestPage];
                btnShowMore.hidden = NO;
            }
            else
            {
                btnShowMore.hidden = YES;
            }
        }
        else if(currentFilterType == FILTER_MOST_VIEW)
        {
            if (currentMostViewPage<totalMostViewDramaPages) {
                currentMostViewPage ++;
                [self requestGetListDrama:currentFilterType page:currentMostViewPage];
                btnShowMore.hidden = NO;
            }
            else
            {
                btnShowMore.hidden = YES;
            }
            
        }
    }
    else 
    {
        if (isDrama == TRUE) 
        {
            if (currentFilterType == FILTER_NEWEST) {
                if (currentNewestPage<totalNewestPages) {
                    currentNewestPage ++;
                    //[self requestGetListVideo:currentFilterType page:currentNewestPage];
                    [self requestGetListVideoFollowDrama:currentFilterType withId:strID page:currentNewestPage];
                    btnShowMore.hidden = NO;
                }
                else
                {
                    btnShowMore.hidden = YES;
                }
            }
            else if(currentFilterType == FILTER_MOST_VIEW)
            {
                if (currentMostViewPage<totalMostViewPages) {
                    currentMostViewPage ++;
                    //[self requestGetListVideo:currentFilterType page:currentMostViewPage];
                    [self requestGetListVideoFollowDrama:currentFilterType withId:strID page:currentMostViewPage];
                    btnShowMore.hidden = NO;
                }
                else
                {
                    btnShowMore.hidden = YES;
                }
                
            }
        }
        else 
        {
            if (isGetVideoFollowDrama == TRUE) {
                if (currentFilterType == FILTER_NEWEST) {
                    if (currentNewestPage<totalNewestPages) {
                        currentNewestPage ++;
                        //[self requestGetListVideo:currentFilterType page:currentNewestPage];
                        [self requestGetListVideoFollowDrama:currentFilterType withId:strID page:currentNewestPage];
                        btnShowMore.hidden = NO;
                    }
                    else
                    {
                        btnShowMore.hidden = YES;
                    }
                }
                else if(currentFilterType == FILTER_MOST_VIEW)
                {
                    if (currentMostViewPage<totalMostViewPages) {
                        currentMostViewPage ++;
                        //[self requestGetListVideo:currentFilterType page:currentMostViewPage];
                        [self requestGetListVideoFollowDrama:currentFilterType withId:strID page:currentMostViewPage];
                        btnShowMore.hidden = NO;
                    }
                    else
                    {
                        btnShowMore.hidden = YES;
                    }
                    
                }

            }
            else
            {
                if (currentFilterType == FILTER_NEWEST) {
                    if (currentNewestPage<totalNewestPages) {
                        currentNewestPage ++;
                        [self requestGetListVideo:currentFilterType page:currentNewestPage];
                        btnShowMore.hidden = NO;
                    }
                    else
                    {
                        btnShowMore.hidden = YES;
                    }
                }
                else if(currentFilterType == FILTER_MOST_VIEW)
                {
                    if (currentMostViewPage<totalMostViewPages) {
                        currentMostViewPage ++;
                        [self requestGetListVideo:currentFilterType page:currentMostViewPage];
                        btnShowMore.hidden = NO;
                    }
                    else
                    {
                        btnShowMore.hidden = YES;
                    }
                    
                }
            }

        }
    }
   
}
@end
