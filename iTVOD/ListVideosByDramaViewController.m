
//  ListVideosByDramaViewController.m
//  iTVOD

//  Created by Do Thanh Nam on 20/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "ListVideosByDramaViewController.h"
#import "InternetResource.h"
#import "MovieDetailViewController.h"
#import "cellIdentifier.h"

@implementation ListVideosByDramaViewController
@synthesize btnShowMore;
@synthesize lstVideoByDramaParser;
@synthesize tblFilmSeries;
@synthesize filmSeriesAvatar;
@synthesize filmSeriesVote;
@synthesize vietnameseTitle;
@synthesize englishTitle;
@synthesize numberOfSeries;
@synthesize theDramaObject;
@synthesize theAvartar;

#pragma mark -
#pragma mark INIT
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
	

    return self;
}


-(id)initWithDramaObject:(DramaObj*) dramaObj dramaAvartar:(UIImage *) img {
    
	
    if (self = [super init]){
        theDramaObject = [dramaObj retain];
        theAvartar = img;
    }
	

    return self;
}
- (void)didReceiveMemoryWarning
{
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    btnShowMore.hidden = YES;
    /*
     
     */
//    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
//    UIColor *newTintColor = [UIColor colorWithRed: 251/255.0 green:175/255.0 blue:93/255.0 alpha:1.0];
//    segmentControl.tintColor = newTintColor;

    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBezeled];

    
    // Do any additional setup after loading the view from its nib.
    
    englishTitle.text = theDramaObject.drama_english_title;
    vietnameseTitle.text = theDramaObject.drama_vietnamese_title;
    numberOfSeries.text = [NSString stringWithFormat:@"Số tập %@", theDramaObject.drama_quantity];
    
    [filmSeriesAvatar setImage:theAvartar];
    
    
    tblFilmSeries.delegate = self;
    tblFilmSeries.dataSource = self;
    tblFilmSeries.backgroundColor = [UIColor clearColor];
    tblFilmSeries.separatorStyle = UITableViewCellSeparatorStyleNone;

    //get list videos by drama
    lstResources = [[NSMutableArray alloc] init];
//    int totalPages = (int) ([theDramaObject.drama_quantity intValue] / 25);
//    for (int i = 0; i < totalPages; i++) {
//        [self getListVideosByDrama:i];
//    }

    currentFilterType = FILTER_OLDEST;
    
    [self getListVideosByDramaWithFilter:FILTER_OLDEST atPage:1];
    
    currentNewestPage = 1;
    currentOldestPage = 1;
    
	
    
}



-(void)handleFinishedLoadingImage:(NSNotification*)notification{
	
    [self performSelectorOnMainThread:@selector(loadDramaImages:) withObject:nil waitUntilDone:NO]; 
    
}
-(void)loadDramaImages:(InternetResource*)_resource{
	
    [self renderImages];
    
}
-(void)renderImages{
	
    UIImage *img;
    InternetResource *iResource = [lstResources objectAtIndex:0];
    
    @synchronized(iResource){
        
        switch (iResource.status) {
            case NEW:
          {
            
            img = [UIImage imageNamed:@"loading.png"];
            [iResource start];
          }
                break;
            case COMPLETE:
          {
            
            img = iResource.image;
          }
                break;
            case FAILED:	
          {
            
            img = [UIImage imageNamed:@"no_image.png"];
          }
                break;
            case FETCHING:
          {
            
            img = [UIImage imageNamed:@"loading.png"];
          }
                break;
            default:
                break;
        }
    }
    
    [filmSeriesAvatar setImage:img];
    SAFE_RELEASE(img);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FinishedLoadingLinkImage object:nil];
	

}
#pragma mark -
#pragma mark UNLOAD
- (void)viewDidUnload
{
	
    [self setTblFilmSeries:nil];
    [self setFilmSeriesAvatar:nil];
    [self setFilmSeriesVote:nil];
    [self setNumberOfSeries:nil];
    [self setVietnameseTitle:nil];
    [self setEnglishTitle:nil];
    [self setNumberOfSeries:nil];
    [segmentControl release];
    segmentControl = nil;
    [self setBtnShowMore:nil];
    [super viewDidUnload];
	

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	
    
    SAFE_RELEASE(lstResources);
//    SAFE_RELEASE(theAvartar);
    SAFE_RELEASE(theDramaObject);
    SAFE_RELEASE(lstFromLastVideo);
    SAFE_RELEASE(lstFromFirstVideo);
    SAFE_RELEASE(lstVideoByDramaParser)
//    
//    lstResources = nil;
//    theAvarta = nil;
//    theDramaObject = nil;
//    lstVideoObject = nil;
    
    [tblFilmSeries release];
    [filmSeriesAvatar release];
    [filmSeriesVote release];
    [numberOfSeries release];
    [vietnameseTitle release];
    [englishTitle release];
    [numberOfSeries release];

    [segmentControl release];
    [btnShowMore release];
    [super dealloc];

	
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TABLE VIEW
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentFilterType == FILTER_NEWEST) {
        return [lstFromLastVideo count];
    } else {
        return [lstFromFirstVideo count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
    */
    
    static NSString *simpleTableIdentifier = @"cellIndentifier";
    
    cellIndentifier *cell = (cellIndentifier *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cellIndentifier" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    } 
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.accessoryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    VideoObject *obj;
    if (currentFilterType == FILTER_NEWEST) {
        cell.thumbnailTitle.text = [NSString stringWithFormat:@"%d", totalNewestVideo - indexPath.row];
        
        obj = [lstFromLastVideo objectAtIndex:indexPath.row];
        if ((25 * currentNewestPage - 2 == indexPath.row)){
//            
            currentNewestPage++;
            if (currentNewestPage <= totalNewestPage){
                [self getListVideosByDramaWithFilter:currentFilterType atPage:currentNewestPage];
            }
        }
    } else {
        cell.thumbnailTitle.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        if ((25 * currentOldestPage - 2 == indexPath.row)){
//            
            currentOldestPage++;
            if (currentOldestPage <= totalOldestPage) {
                [self getListVideosByDramaWithFilter:currentFilterType atPage:currentOldestPage];
            }
        }
        obj = [lstFromFirstVideo objectAtIndex:indexPath.row];
    }
    
    
    cell.thumbnailTitle.textAlignment = UITextAlignmentCenter;
    
	cell.largeTitle.text = obj.video_english_title;
    cell.smalTitle.text = obj.video_vietnamese_title;
    
    cell.largeTitle.textColor = [UIColor whiteColor];
    cell.smalTitle.textColor = [UIColor whiteColor];
    
    cell.indentationLevel = 1;
    
    //cell.imageView.layer.masksToBounds = YES;
    //cell.imageView.layer.cornerRadius = 10;
    
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
//    cell.accessoryView = imageView;
//    [imageView release];
    
    [tableView setSeparatorColor:[UIColor grayColor]];

//    if (indexPath.row%2 == 0) {
//        cell.contentView.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.1];
//    }
//    else {
//        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    }
    
	

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    VideoObject *obj;

    if (currentFilterType == FILTER_NEWEST) {
        obj = [[lstFromLastVideo objectAtIndex:indexPath.row] retain];
    }
    else {
        obj = [[lstFromFirstVideo objectAtIndex:indexPath.row] retain];

    }

    NSString *strTitle = obj.video_english_title;
    NSString *strVietnameseTitle = obj.video_vietnamese_title;
    int intTmpDuration = [obj.video_duration intValue];
    int duration_minutes = ceil(intTmpDuration*1.0/60);
    
    NSString *duration = [NSString stringWithFormat:@"Thời lượng : %d phút",duration_minutes];
    
    NSString *numberViews = [NSString stringWithFormat:@"Số lượt xem : %@",obj.video_number_views];
    NSString *price = [NSString stringWithFormat:@"%@ xu",obj.video_price];
    NSString *description = [NSString stringWithFormat:@"%@",obj.video_description];
    NSString *_id = [NSString stringWithFormat:@"%@",obj.video_id];
    
    
    UIImage *img = filmSeriesAvatar.image;
    
    
    MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:[strTitle retain] vietnameseTitle:[strVietnameseTitle retain] videoId:[_id retain ] image:[img retain ] numberViews:[numberViews retain] duration:[duration retain] price:[price retain] description:[description retain]];
    
    [img release];
    [obj release];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}

#pragma mark -
#pragma mark GET LIST VIDEOS RESULT

-(void) getListVideosByDramaWithFilter:(NSString *) filter atPage:(int) page{
    [self setupListVideosByDramaNotification];
    [self addLoading];
    
    if (lstVideoByDramaParser == nil) {
        lstVideoByDramaParser = [[ListVideosByDramaParser alloc] init];
    }
    if (!page) page = 1;
    
    
    [lstVideoByDramaParser parserWithJSONLink:[NSString stringWithFormat:TVOD_GET_LIST_VIDEO_BY_DRAMA,filter,theDramaObject.drama_id,page]];
}

-(void) getListVideosByDramaOK {
    // assign result to ListVideosByDramaViewController, make it appear
    
    [self removeLoading];
    [self removeListVideosByDramaNotification];
  
// 
    if (currentFilterType == FILTER_NEWEST){
//        currentFilterType = FILTER_NEWEST;
        totalNewestVideo = lstVideoByDramaParser._listVideoObj.total_quantity;
        totalNewestPage = (int)(totalNewestVideo/25);
        if ((totalNewestVideo%25)>0){
            totalNewestPage++;
        }
        
        if (lstFromLastVideo == nil){
            //init this
            lstFromLastVideo = [lstVideoByDramaParser._listVideoObj.lstVideoItems retain];
        }else {
            //add objects to it
            int quantity = lstVideoByDramaParser._listVideoObj.quantity;
            for (int i = 0; i < quantity; i++) {
                VideoObject *obj = [lstVideoByDramaParser._listVideoObj.lstVideoItems objectAtIndex:i];
                [lstFromLastVideo addObject:obj];
                [obj release];
            }
        }
    } else {//_type = FILTER_OLDEST
            //currentFilterType = FILTER_OLDEST;
        totalOldestVideo = lstVideoByDramaParser._listVideoObj.total_quantity;
        totalOldestPage = (int)(totalOldestVideo/25);
        if ((totalOldestVideo%25) > 0){
            totalOldestPage++;
        }
        
        if (lstFromFirstVideo == nil){
            //init this
            lstFromFirstVideo = [lstVideoByDramaParser._listVideoObj.lstVideoItems retain];
        }else {
            //add objects to it
            int quantity = lstVideoByDramaParser._listVideoObj.quantity;
            for (int i = 0; i < quantity; i++) {
                VideoObject *obj = [lstVideoByDramaParser._listVideoObj.lstVideoItems objectAtIndex:i];
                [lstFromFirstVideo addObject:obj];
                [obj release];
            }
        }
    }
    
//    

//    InternetResource  *iResource =[[[InternetResource alloc] initWithTitle:@"URLImage" andURL:theDramaObject.drama_image_path] autorelease];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:iResource];
//    
//    lstResources = nil;
//    [lstResources addObject:iResource];
//    [iResource start];
    
//    SAFE_RELEASE(lstResources);
    
    btnShowMore.hidden = [self btnShowMoreHiddenByFilter:currentFilterType];
    
    [tblFilmSeries reloadData];
    
    //SAFE_RELEASE(lstVideoByDramaParser);
    
    
}
-(void) getListVideosByDramaError{
    
    [self removeLoading];
    [self removeListVideosByDramaNotification];
}
-(void) getListVideosByDramaConnectionFailed{
    
    [self removeLoading];
    [self removeListVideosByDramaNotification];
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

-(void)setupListVideosByDramaNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideosByDramaOK) name:GET_LIST_VIDEOS_BY_DRAMA_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideosByDramaError) name:GET_LIST_VIDEOS_BY_DRAMA_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListVideosByDramaConnectionFailed) name:GET_LIST_VIDEOS_BY_DRAMA_CONNECTION_FAILED object:nil];
}
-(void)removeListVideosByDramaNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_LIST_VIDEOS_BY_DRAMA_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEOS_BY_DRAMA_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_LIST_VIDEOS_BY_DRAMA_CONNECTION_FAILED object:nil];
}
#pragma mark -
#pragma mark FILTERS

- (IBAction)changeFilter:(UISegmentedControl *)sender {
    int index = [sender selectedSegmentIndex] + 1;

    switch (index) {
        case 1:
            //display newest video list
            currentFilterType = FILTER_OLDEST;
            if ([lstFromFirstVideo count] == 0) {
                [self getListVideosByDramaWithFilter:currentFilterType atPage:currentOldestPage];
            } else {
                [tblFilmSeries reloadData];
            }
            break;
        case 2:
            //display oldest video list
            currentFilterType = FILTER_NEWEST;
            if ([lstFromLastVideo count] == 0) {
                [self getListVideosByDramaWithFilter:currentFilterType atPage:currentNewestPage];
            } else {
                [tblFilmSeries reloadData];
            }
            break;
        default:
            break;
    }
    
    btnShowMore.hidden = [self btnShowMoreHiddenByFilter:currentFilterType];

}

- (BOOL) btnShowMoreHiddenByFilter:(NSString *) filter {
    return YES;
//    if (currentFilterType == FILTER_NEWEST) {
//        return (currentNewestPage >= totalNewestPage) ? YES: NO;
//    } else {
//        return (currentOldestPage >= totalOldestPage) ? YES: NO;
//    }
}

- (IBAction)showMore:(UIButton *)sender {
    

    if (currentFilterType == FILTER_NEWEST) {
        currentNewestPage++;
        [self getListVideosByDramaWithFilter:currentFilterType atPage:currentNewestPage];
    } else {
        currentFilterType = FILTER_OLDEST;
        currentOldestPage++;
        
        [self getListVideosByDramaWithFilter:currentFilterType atPage:currentOldestPage];
    }
    btnShowMore.hidden = [self btnShowMoreHiddenByFilter:currentFilterType];
    
}

@end
