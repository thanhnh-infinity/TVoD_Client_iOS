
//  NewsDetailViewController.m
//  iTVOD

//  Created by vivas-mac on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
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
-(id)initWithTitle:(NSString *)_news_title news_image:(UIImage *)_image news_content:(NSString *)_news_content
{
    if (self = [super init]) {
        news_title = _news_title;
        news_image = _image;
        news_content = _news_content;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    news_content = [news_content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    news_title = [news_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
   // webView.scalesPageToFit = YES;

    [webView loadHTMLString:news_content baseURL:nil];
    
    
    lblTitle.text = news_title;
    lblTitleDetail.text = news_title;
    imgView.image = news_image;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
