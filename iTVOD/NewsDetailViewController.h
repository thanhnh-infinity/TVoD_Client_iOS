
//  NewsDetailViewController.h
//  iTVOD

//  Created by vivas-mac on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController
{
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblTitleDetail;
    IBOutlet UIImageView *imgView;
    
    NSString *news_title;
    UIImage *news_image;
    NSString *news_content;
}

-(id)initWithTitle:(NSString *)_news_title news_image:(UIImage *)_image news_content:(NSString *)_news_content;
-(IBAction)back:(id)sender;
@end
