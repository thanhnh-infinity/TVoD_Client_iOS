
//  SearchViewController.m
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "SearchViewController.h"

@implementation SearchViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FinishedLoadingLinkImage object:TVOD_SEARCH];
    
    SAFE_RELEASE(lstResources);
    SAFE_RELEASE(lstSearchResult);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_SEARCH];
    
    self.navigationController.navigationBar.hidden = YES;
    tblSearchResult.backgroundColor = [UIColor clearColor];
    tblSearchResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblSearchResult.hidden = YES;
    tblSearchResult.delegate = self;
    tblSearchResult.dataSource = self;
    _searchBar.delegate = self;
    
    lstResources = [[NSMutableArray alloc] init];
    //lstSearchResult = [[NSMutableArray alloc] init];
    
    currentPage = 1;
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
   // return YES;
}
#pragma mark -
#pragma mark Searchbar delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
	[searchBar resignFirstResponder];
    self.view.backgroundColor = [UIColor grayColor];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
	[searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    currentPage = 1;
    [searchBar resignFirstResponder];
    [lstResources removeAllObjects];
    [lstSearchResult removeAllObjects];
    //search from here
    m_strSearch = _searchBar.text;
    
    [self requestSearch:m_strSearch];
  
}
#pragma mark -
#pragma mark Request Search
-(void)requestSearch:(NSString *)keyword
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    NSString *strSearch = [NSString stringWithFormat:TVOD_SEARCH,keyword,currentPage];
    strSearch = [strSearch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchOK) name:SEARCH_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchError) name:SEARCH_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:SEARCH_CONNECTION_FAILED object:nil];
    
    _searchParser = [[SearchParser alloc] init];
    [_searchParser parserWithJSONLink:strSearch];
}
-(void)connectionFailed
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchError) name:SEARCH_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    [_searchParser release];
    _searchParser = nil;
        
    [tblSearchResult reloadData];
    btnShowMore.hidden = YES;
}
-(void)getSearchOK
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchError) name:SEARCH_ERROR object:nil];
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    totalResultVideos = _searchParser._listVideoObj.total_quantity;
    totalResultPages = ceil(totalResultVideos*1.0/25);
    
    if (currentPage == totalResultPages) {
        btnShowMore.hidden = YES;
    }
    else
    {
        btnShowMore.hidden = NO;
    }
    if ([lstSearchResult count] == 0) {
        lstSearchResult = [_searchParser._listVideoObj.lstVideoItems retain];
        
        for (int i=0; i<[lstSearchResult count]; i++) {
            VideoObject *obj = [lstSearchResult objectAtIndex:i];
            InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
            iResource.receiver = TVOD_SEARCH;
            [lstResources addObject:iResource];
        }
    }
    else
    {
        for (int i=0; i<[_searchParser._listVideoObj.lstVideoItems count]; i++) {
            VideoObject *obj = [_searchParser._listVideoObj.lstVideoItems objectAtIndex:i];
            [lstSearchResult addObject:obj];
            InternetResource *iResource = [[[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.video_picture_path] autorelease];
            [lstResources addObject:iResource];
            
        }
    }
    
    [_searchParser release];
    _searchParser = nil;
   
   
    tblSearchResult.hidden = NO;
    [tblSearchResult reloadData];
}
-(void)getSearchError
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchError) name:SEARCH_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    [tblSearchResult reloadData];
    btnShowMore.hidden = YES;
    [_searchParser release];
    _searchParser = nil;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self searchBarTextDidEndEditing:_searchBar];
}
#pragma mark -
#pragma mark Notification Get Image
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
	[self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
    
}
-(void)reloadTable:(InternetResource*)_resource{
	[tblSearchResult reloadData];
}
-(IBAction)showMore:(id)sender
{
    
    
    
    if (currentPage<totalResultPages) {
        currentPage++;
        [self requestSearch:m_strSearch];
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
    float returnHeight = 74.4;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        returnHeight = 74.4;
    }
    else {
        returnHeight = 100;
    }
    return returnHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lstSearchResult count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
	}
    VideoObject *obj = [lstSearchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.video_english_title;
    
    if ([lstResources count] >=(indexPath.row +1)) {
        InternetResource *iResource = [lstResources objectAtIndex:indexPath.row];
        
        // Configure the cell.
        
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
    
    
    NSString *str = [NSString stringWithFormat:@"%@\nSố lượt xem : %@",obj.video_vietnamese_title,obj.video_number_views];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text =  str;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
    else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoObject *obj = [lstSearchResult objectAtIndex:indexPath.row];
    
    NSString *strTitle = obj.video_english_title;
    NSString *duration = [NSString stringWithFormat:@"Thời lượng : %@",obj.video_duration];
    NSString *numberViews = [NSString stringWithFormat:@"Số lượt xem : %@",obj.video_number_views];
    NSString *price = [NSString stringWithFormat:@"Giá : %@",obj.video_price];
    NSString *description = [NSString stringWithFormat:@"%@",obj.video_description];
    NSString *_id = [NSString stringWithFormat:@"%@",obj.video_id];
    NSString *vietnameseTitle = [NSString stringWithFormat:@"%@",obj.video_vietnamese_title];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:obj.video_picture_path]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [data release];
    MovieDetailViewController *viewController = [[MovieDetailViewController alloc] initWithTitle:strTitle vietnameseTitle:vietnameseTitle videoId:_id image:img numberViews:numberViews duration:duration price:price description:description];
    
    [img release];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
@end
