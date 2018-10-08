
//  MainViewController.m
//  iTVOD

//  Created by vivas-mac on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "MainViewController.h"
#import "ListVideoViewController.h"

@implementation MainViewController 

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
-(void)checkVersion
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersionOK) name:CHECK_VERSION_OK object:nil];
    _checkVersionParser = [[CheckVersionParser alloc] init];
    [_checkVersionParser parserWithJSONLink:[NSString stringWithFormat:TVOD_CHECK_VERSION]];
    

}
-(void)checkVersionOK
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CHECK_VERSION_OK object:nil];
    NSString *current_version = _checkVersionParser._checkVersionObj.current_version;
    //[_checkVersionParser release];
    
        //debug(@"currentVersion = %@",current_version);

    NSString *str = [self getAppCurrentVersion];
    if ([current_version floatValue] > [str floatValue]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thông báo" message:@"Cập nhật phiên bản mới" delegate:self cancelButtonTitle:@"Bỏ qua" otherButtonTitles:@"Đồng ý", nil ];
        alert.tag = ALERT_CHECK_VERSION;
        [alert show];
        [alert release];
    }
    else if([current_version floatValue] == [str floatValue]    ){
        
    }
    else{
        
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == ALERT_CHECK_VERSION) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_checkVersionParser._checkVersionObj.link_update]];
                break;
            default:
                break;
        }
    }
    
}

-(NSString *)getAppCurrentVersion
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfiguration" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *strVersion = [dict objectForKey:@"current_version"];
    
        //path = nil;
        //[dict release];
        
    
    return strVersion;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishedLoadingImage:) name:FinishedLoadingLinkImage object:TVOD_GET_LIST_PARENT_CATEGORY];
    lstResources = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    scrollView = [[UIScrollView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        scrollView.frame = CGRectMake(0, 0, 320, 480);
    }
    else {
        scrollView.frame = CGRectMake(0, 0, 768, 1024);
    }
    lstButton = [[NSMutableArray alloc] init];
    btnRefresh.hidden = YES;
    
    [self getParentCategory];
    [self checkVersion];
    
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
-(IBAction)refresh:(id)sender
{
    
    [self getParentCategory];
    
}
#pragma mark -
#pragma mark Get parent Category
- (void) startLoading {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.delegate = self;
	[self.navigationController.view addSubview:HUD];
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
- (void) setupGetParentCategoryObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResponseResultOK) name:GET_PARENT_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResponseResultError) name:GET_PARENT_CATEGORY_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed) name:GET_PARENT_CATEGORY_CONNECTION_FAILED object:nil];
}
- (void) removeGetParentCategoryObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_PARENT_CATEGORY_CONNECTION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_PARENT_CATEGORY_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_PARENT_CATEGORY_ERROR object:nil];
    
}
-(void)getParentCategory
{
    
    
    [self setupGetParentCategoryObservers];
    
    [self startLoading];
    
    
    _parentCategoryParser = [[ParentCategoryParser alloc] init];
    [_parentCategoryParser parserWithJSONLink:TVOD_GET_LIST_PARENT_CATEGORY];
    
}
-(void)connectionFailed
{
    
    
    
    [self stopLoading];
    
    btnRefresh.hidden = NO;
    
    
}
-(void)getResponseResultOK
{
    
    
    [self removeGetParentCategoryObservers];

    btnRefresh.hidden = YES;
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    //code for display here
    lstParentCategories = [_parentCategoryParser._listParentCategoryObj.lstParentCategories retain];
//    for (int i=0; i<4; i++) {
//        for (int k=0; k<4; k++) {
//            ParentCategoryObj *obj = [_parentCategoryParser._listParentCategoryObj.lstParentCategories objectAtIndex:k];
//            [lstParentCategories addObject:obj];
//        }
//    }
    //int totalItems = [_parentCategoryParser._listParentCategoryObj.quantity intValue] *4;
    int totalItems = [lstParentCategories count];
        //totalItems = 81;
        //totalPages = ceil(totalItems*1.0/6);
    if (totalItems%6 == 0){
        totalPages = totalItems / 6;
    }else {
        totalPages = totalItems / 6 + 1;
    }
    
    
    
    pageControl.numberOfPages = totalPages;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [scrollView setContentSize:CGSizeMake(320 * totalPages, 480)];
        scrollView.pagingEnabled = (totalItems > 6) ? YES : NO;
        
        for (int i=0; i<totalPages; i++) {
            ParentCategoryObj *obj;
            int numberItems = 0;
            
            if (lastPage == i) {
                numberItems = [lstParentCategories count] - 6*(totalPages -1);
            }
            else {
                numberItems = 6;
            }
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 480)];
            contentView.backgroundColor = [UIColor clearColor];
            
            for (int k = 0; k<numberItems; k++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                
                int x_btn_pixel;
                int y_btn_pixel;
                
                int x_label_pixel;
                int y_label_pixel;
                int extra_width = 25;
                int height_space = 10;
                int title_bar_height = 44;
                int btn_width = 72;
                int btn_height = 72;
                
                int lbl_width = btn_width + extra_width;
                int lbl_height = 40;
                /* 2 items per line + 32*/
                // WIDTH = 96
                if (k%2 == 0){//0,2,4,6...
                    x_btn_pixel = (320/2 - btn_width) / 2;
                    x_label_pixel = x_btn_pixel - extra_width/2;
                } else if (k%2 == 1){//1,3,5,7...
                    x_btn_pixel =  320/2 + (320/2 - btn_width)/2;
                    x_label_pixel = x_btn_pixel - extra_width/2;
                }
                if (k == 0){//0
                    y_btn_pixel =  title_bar_height + height_space;// 
                    y_label_pixel = y_btn_pixel + btn_height;
                } else if (k%2 == 0){//2,4,6...
                    y_btn_pixel =  title_bar_height + (btn_height + lbl_height) * (k/2) + height_space;
                    y_label_pixel = y_btn_pixel + btn_height;
                }
                /* 2 items per line */
                /* 3 items per line 
                if (k%3 == 0) {
                    x_btn_pixel = 30;
                    x_label_pixel = 16;
                }
                else if(k%3 ==1){
                    x_btn_pixel = 128;
                    x_label_pixel = 113;
                }
                else if (k%3 == 2) {
                    x_btn_pixel = 224;
                    x_label_pixel = 215;
                }
                
                if (k/3 == 0) {
                    y_btn_pixel = 20 + 45;
                    y_label_pixel = 80 + 45;
                }
                else if (k/3 == 1) {
                    y_btn_pixel = 128 + 45;
                    y_label_pixel = 188 + 45;
                }
                else if (k/3 == 2) {
                    y_btn_pixel = 239 + 45;
                    y_label_pixel = 300 + 45;
                }
                 3 items per line */
                btn.tag = i*6 + k;
                btn.frame = CGRectMake(x_btn_pixel, y_btn_pixel, btn_width, btn_height);
                [btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
                //UIImage *img = [UIImage imageNamed:@"loading.png"];
                //[btn setImage:img forState:UIControlStateNormal];
                [contentView addSubview:btn];
                
                [lstButton addObject:btn];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x_label_pixel, y_label_pixel, lbl_width, lbl_height)];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = UITextAlignmentCenter;
                lbl.textColor = [UIColor whiteColor];
                lbl.numberOfLines = 2;
                
                
                obj = [lstParentCategories objectAtIndex:i*6 + k];
                lbl.text = obj.category_name;
                
                //set image for each category button
                InternetResource *iResource = [[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.category_image];
                iResource.receiver = TVOD_GET_LIST_PARENT_CATEGORY;
                [lstResources addObject:iResource];
                [iResource start];
                
                [iResource release];
                [btn setImage:iResource.image forState:UIControlStateNormal];
                
                
                [contentView addSubview:lbl];
                [lbl release];
                [contentView addSubview:btn];
                // [btn release];
                
            }
            
            [scrollView	 addSubview:contentView];
            [contentView release];
            
        }
    }
    else 
    {
        [scrollView setContentSize:CGSizeMake(768 * totalPages, 1024)];
        scrollView.pagingEnabled = YES;
        
        for (int i=0; i<totalPages; i++) {
            ParentCategoryObj *obj;
            int numberItems = 0;
            
            if (lastPage == i) {
                numberItems = [lstParentCategories count] - 9*(totalPages -1);
            }
            else {
                numberItems = 9;
            }
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(768*i, 0, 768, 1024)];
            contentView.backgroundColor = [UIColor clearColor];
            
            for (int k = 0; k<numberItems; k++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                
                int x_btn_pixel;
                int y_btn_pixel;
                
                int x_label_pixel;
                int y_label_pixel;
                
                int btn_width = 120;
                int btn_height = 120;
                
                int lbl_width = 120;
                int lbl_height =80;
                
                //Cot
                if (k%3 == 0) {
                    x_btn_pixel = 68;
                    x_label_pixel = 68;
                }
                else if(k%3 ==1){
                    x_btn_pixel = 324;
                    x_label_pixel = 324;
                }
                else if (k%3 == 2) {
                    x_btn_pixel = 580;
                    x_label_pixel = 580;
                }
                
                //hang
                if (k/3 == 0) {
                    y_btn_pixel = 20 + 45 + 38;
                    y_label_pixel = 20 + 45 + 38 + 120;
                }
                else if (k/3 == 1) {
                    y_btn_pixel = 314;
                    y_label_pixel = 314 + 120;
                }
                else if (k/3 == 2) {
                    y_btn_pixel = 648;
                    y_label_pixel = 648 + 120;
                }
                btn.tag = i*9 + k;
                btn.frame = CGRectMake(x_btn_pixel, y_btn_pixel, btn_width, btn_height);
                [[btn imageView]setContentMode:UIViewContentModeScaleAspectFit];
                [btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
                //UIImage *img = [UIImage imageNamed:@"loading.png"];
                //[btn setImage:img forState:UIControlStateNormal];
                [contentView addSubview:btn];
                
                [lstButton addObject:btn];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x_label_pixel, y_label_pixel, lbl_width, lbl_height)];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.textAlignment = UITextAlignmentCenter;
                lbl.textColor = [UIColor whiteColor];
                lbl.numberOfLines = 2;
                
                
                obj = [lstParentCategories objectAtIndex:i*9 + k];
                lbl.text = obj.category_name;
//                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:obj.category_image]];
//                
//                UIImage *img = [[UIImage alloc] initWithData:data];
//                [data release];
//                [btn setImage:img forState:UIControlStateNormal];
//                [img release];

                InternetResource *iResource = [[InternetResource alloc] initWithTitle:@"VietDung" andURL:obj.category_image];
                [lstResources addObject:iResource];
                iResource.receiver = TVOD_GET_LIST_PARENT_CATEGORY;

                [iResource start];
                
                [iResource release];
                [btn setImage:iResource.image forState:UIControlStateNormal];
                
                [contentView addSubview:lbl];
                [lbl release];
                [contentView addSubview:btn];
                // [btn release];
                
            }
            
            [scrollView	 addSubview:contentView];
            [contentView release];
            
        }
    }
    
    
    [self.view addSubview:scrollView];
    
}
-(void)getResponseResultError
{
    
    
    [self removeGetParentCategoryObservers];
    [self stopLoading];
    
    
}
-(void)handleFinishedLoadingImage:(NSNotification*)notification{
	
    [self performSelectorOnMainThread:@selector(reloadImage:) withObject:nil waitUntilDone:NO]; 
    
}
-(void)reloadImage:(InternetResource*)_resource{
	
    [self renderImage];
    
}
-(void)renderImage{
//    int count = [lstParentCategories count];
//    
    for (int i=0; i<[lstParentCategories count]; i++) {
        UIImage *img;
        InternetResource *iResource = [lstResources objectAtIndex:i];
        
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
		UIButton *btn = [lstButton objectAtIndex:i];
        
		[btn setBackgroundImage:img forState:UIControlStateNormal];
	}
    
}
-(void)selectCategory:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    
    
    int btnIndex = [btn tag];
    NSString *parent_id = @"";     
    //for testing
    // ListVideoViewController *lstVideoViewController = [[ListVideoViewController alloc] init];
    NSString *categoryTitle = @"";
    ParentCategoryObj *tmpObj = [lstParentCategories objectAtIndex:btnIndex];
    categoryTitle = tmpObj.category_name;
    parent_id = tmpObj.category_id;
    
    

    if ([parent_id isEqualToString:@"16"]) {
        ListLiveViewController *viewController = [[ListLiveViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
    } else {
        ChildCategoryViewController *viewController = [[ChildCategoryViewController alloc] initWithParentCategoryId:parent_id title:categoryTitle];
        
        viewController.lblTitle.text = categoryTitle;
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
}
#pragma mark -
#pragma mark Action
//-(IBAction)touchButton:(id)sender
//{
//    UIButton *tmpButton = (UIButton *)sender;
//    int btnIndex = [tmpButton tag];
//    NSString *parent_id = @"";     
//    //for testing
//   // ListVideoViewController *lstVideoViewController = [[ListVideoViewController alloc] init];
//    NSString *categoryTitle = @"";
//    switch (btnIndex) {
//        case 0:
//            
//            categoryTitle = @"Âm Nhạc";
//            parent_id = @"13";
//            break;
//        case 1:
//            
//            categoryTitle = @"Phim";
//            parent_id = @"14";
//            break;
//        case 2:
//            
//            categoryTitle = @"Clips";
//            parent_id = @"15";
//            break;
//        case 3:
//            
//            categoryTitle = @"Radio";
//            parent_id = @"552";
//            break;
//        case 4:
//            
//            categoryTitle = @"wtf";
//            parent_id = @"wtf";
//            break;
//        default:
//            break;
//    }
//    ChildCategoryViewController *viewController = [[ChildCategoryViewController alloc] initWithParentCategoryId:parent_id title:categoryTitle];

//    viewController.lblTitle.text = categoryTitle;
//   
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
//    
//  //  [self.navigationController pushViewController:lstVideoViewController animated:YES];
//    //[lstVideoViewController release];

//}
-(void)hudWasHidden{
    
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FinishedLoadingLinkImage object:TVOD_GET_LIST_PARENT_CATEGORY];
    
    SAFE_RELEASE(lstButton);
    SAFE_RELEASE(lstParentCategories);
    SAFE_RELEASE(lstResources);
    [super dealloc];
    
}
@end
