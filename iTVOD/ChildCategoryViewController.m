
//  ChildCategoryViewController.m
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ChildCategoryViewController.h"
#import <QuartzCore/CALayer.h>

@implementation ChildCategoryViewController
@synthesize tblListChildCategory;
@synthesize lblTitle;
@synthesize parent_category_id;
@synthesize parent_category_title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithParentCategoryId:(NSString *)_parent_category_id title:(NSString *)strTitle
{
    if (self=[super init]) {
        parent_category_id = _parent_category_id;
        parent_category_title = strTitle;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View lifecycle
-(void)dealloc
{
    
    
    
    //[lstImages release];
    [lstResources release];
    [_childCategoryParser release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_CHILD_CATEGORY];
    
    
    lblTitle.text = parent_category_title;
//    
    tblListChildCategory.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    
//    [tblListChildCategory setSeparatorColor:[UIColor blueColor]];
    
    tblListChildCategory.delegate = self;
    tblListChildCategory.dataSource = self;
    tblListChildCategory.backgroundColor = [UIColor clearColor];
    tblListChildCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    lstResources = [[NSMutableArray alloc] init];
    
    [self requestChildCategory];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FinishedLoadingLinkImage object:TVOD_GET_LIST_CHILD_CATEGORY];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Notification Get Image
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
    
    
	[self performSelectorOnMainThread:@selector(reloadTable:) withObject:nil waitUntilDone:NO]; 
}
-(void)reloadTable:(InternetResource*)_resource{
	[tblListChildCategory reloadData];
}
#pragma mark -
#pragma mark GET CHILD CATEGORY
-(void)requestChildCategory
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOADING_MESSAGE;
	[HUD show:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResponseResultOK) name:GET_CHILD_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResponseResultError) name:GET_CHILD_CATEGORY_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:GET_CHILD_CATEGORY_CONNECTION_FAILED object:nil];
    
    _childCategoryParser = [[ChildCategoryParser alloc] init];
    NSString *strRequest = [NSString stringWithFormat:TVOD_GET_LIST_CHILD_CATEGORY,parent_category_id];
    
    [_childCategoryParser parserWithJSONLink:strRequest];
    
}
-(void)connectionFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_CHILD_CATEGORY_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
-(void)getResponseResultOK
{
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_CHILD_CATEGORY_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_ERROR object:nil];
    
    lstChildCategory = _childCategoryParser._childCategoryObj.lstItems;
    //lstImages = [[NSMutableArray alloc] init];
    for (int i=0; i<[lstChildCategory count]; i++) {
        CategoryObject * obj = [lstChildCategory objectAtIndex:i];
        InternetResource  *iResource =[[[InternetResource alloc] initWithTitle:@"URLImage" andURL:obj.category_image] autorelease];
        iResource.receiver = TVOD_GET_LIST_CHILD_CATEGORY;
        [lstResources addObject:iResource];
    }
    
    
       
    
    [tblListChildCategory reloadData];
}
-(void)getResponseResultError
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_CHILD_CATEGORY_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GET_CHILD_CATEGORY_ERROR object:nil];
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
}
#pragma mark -
#pragma mark UITAbleView Delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lstChildCategory count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
    {
        return  75;
    }
    else {
        return  100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
    
    
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.accessoryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    
    CategoryObject *obj = [lstChildCategory objectAtIndex:indexPath.row];
    
    NSString *str = obj.category_name;//[NSString stringWithFormat:@"%@",obj.category_name];
	cell.textLabel.text = str;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Số lượng video: %d",obj.number_video_category];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    //cell.imageView.layer.masksToBounds = YES;
    //cell.imageView.layer.cornerRadius = 10;
    
    //UIImage *img =[lstImages objectAtIndex:indexPath.row];
    //cell.imageView.image = img;
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (obj.number_video_category >0){
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select2.png"]];
        
        
        cell.accessoryView = imageView;
        [imageView release];
//        if ([lstChildCategory count]>=5){
//            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            [tableView setSeparatorColor:[UIColor grayColor]];
//        }
    }
    /*
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
    }
    else {
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = cell.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor]CGColor], (id)[[UIColor greenColor] CGColor], nil];
//        [cell.layer addSublayer:gradient];
        
        
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellGradientBackground.png"]];

    }
    */
    
    
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Display listmovie view
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     CategoryObject *obj = [lstChildCategory objectAtIndex:indexPath.row];
    
//    
//    
//    if ([obj.category_id isEqualToString:@"16"]) {
//        ListLiveViewController *viewController = [[ListLiveViewController alloc] init];
//        [self.navigationController pushViewController:viewController animated:YES];
//        [viewController release];
//    } else {
        ListVideoViewController *viewController = [[ListVideoViewController alloc] initWithCategoryId:obj.category_id parent_title:obj.category_name];
   
//    viewController.lblTitle.text = obj.category_name;
    
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
//    }
}

@end
