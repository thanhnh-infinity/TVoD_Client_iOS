
//  CustomMoviePlayerViewController.m

//  Copyright iOSDeveloperTips.com All rights reserved.


#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController
@synthesize delegate;
@synthesize mp;
@synthesize customSize;
@synthesize customFrame = _customFrame;
@synthesize customCenterPoint = _customCenterPoint;

- (CGRect) customFrame {
    if (CGRectIsNull(_customFrame)) {
        return CGRectMake(0, 0, 320, 180);
    }
    return _customFrame;
}
- (CGPoint) customCenterPoint {
    if (CGPointEqualToPoint (_customCenterPoint, CGPointZero )) {
        return CGPointMake(160, 90);
    }
    return _customCenterPoint;
}
/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
	// Initialize and create movie URL
    
    if (self = [super init])
    {
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        movieURL = [NSURL URLWithString:moviePath];    
        [movieURL retain];
    }
    
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //    
    [mp pause];
    if (toInterfaceOrientation != UIInterfaceOrientationPortrait){
        
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        [[mp view] setCenter:CGPointMake(240, 160)];
        [mp play];
        //    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        //        [[mp view] setCenter:CGPointMake(240, 160)];
        //        [mp play];
    } 
    else {
        [[mp view] setFrame:self.customFrame];// CGRectMake(0, 0, 320, 240)];
        [[mp view] setCenter:self.customCenterPoint];// CGPointMake(160, 120)];
        [mp play];
        
    }
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
    
	// Unless state is unknown, start playback
    [self.delegate addSubtitle];
	if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        
        [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

        if (customSize) {
            
            [[self view] setBounds:CGRectMake(0, 0, 320, 180)];
            [[self view] setCenter:CGPointMake(160, 90)];            

            [[mp view] setFrame: self.customFrame];  //CGRectMake(0, 0, 320, 240)];
            [[mp view] setCenter: self.customCenterPoint]; //CGPointMake(160, 120)];

            [[self view] addSubview:[mp view]];   
            
            [mp play];
            
            return;
        }
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

		// Rotate the view for landscape playback
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[self view] setBounds:CGRectMake(0, 0, 1024, 768)];
            [[self view] setCenter:CGPointMake(384, 512)];
            [[mp view] setFrame:CGRectMake(0, 0, 1024, 768)];
        } else {
            
            [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
            [[self view] setCenter:CGPointMake(160, 240)];
            [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        }
        
    
        
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 

        // Set frame of movieplayer
		
    
        // Add movie player as subview
        [[self view] addSubview:[mp view]];   

        // Play the movie
		[mp play];
	}
    
    else {
        
        //[self dismissModalViewControllerAnimated:YES];
    }
    
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
    
	// Remove observer
    [self.delegate addSubtitle];
	[[NSNotificationCenter 	defaultCenter] removeObserver:self name:MPMoviePlayerContentPreloadDidFinishNotification
                        	object:nil];

	// Play the movie
 	[mp play];
    
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
 	// Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

    [indicator stopAnimating];
    [indicator release];
    
    
    
    NSNumber *reason =[notification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
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
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"There is some error take place" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alert show];
//                [alert release];
                //[self.view removeFromSuperview];
                //[self dismissModalViewControllerAnimated:YES];
                [self.delegate failedPlayVideo];
                break; 
            }
            case MPMovieFinishReasonUserExited:
            { /* The user exited the player */
                
                break; 
            }
        }
    
    }
    
    
	[self dismissModalViewControllerAnimated:YES];	
    
    //[self.view removeFromSuperview];
    
    //delegate
    [self.delegate finishPlayVideo];
    
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
   // [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if ([mp respondsToSelector:@selector(loadState)]) 
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        [mp currentPlaybackTime];

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

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView
{
    
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];

//	[self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    if (customSize) {
        return;
    }
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        indicator.center = CGPointMake(384, 512);
    }
    else
    {
        indicator.center = CGPointMake(160, 240);
    }
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    UILabel *lbl = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        lbl.frame = CGRectMake(0, 522, 768, 40);
    }
    else {
        lbl.frame = CGRectMake(0, 250, 320, 40);
    }
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.text = LOADING_MESSAGE;
    [self.view addSubview:lbl];
    [lbl release];
    //[indicator release];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setTitle:@"Huỷ" forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"btn_huy.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        btnBack.frame = CGRectMake(334, 562, 100, 40);
    }
    else{
        btnBack.frame = CGRectMake(110, 290, 100, 40);
    }
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UILabel *lblBack = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        lblBack.frame = CGRectMake(334, 562, 100, 40);
    }
    else {
        lblBack.frame = CGRectMake(110, 290, 100, 40);
    }
    
    lblBack.backgroundColor = [UIColor clearColor];
    lblBack.textColor = [UIColor whiteColor];
    lblBack.textAlignment = UITextAlignmentCenter;
    lblBack.text = @"Huỷ";
    [self.view addSubview:lblBack];
    [lblBack release];
    
    
}
-(void)back
{
    
    //[self.view removeFromSuperview];
    [mp stop];
    [self.delegate back];
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
////    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    return YES;
//}
/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
- (void)dealloc 
{
    
	[mp release];
    mp = nil;
    [movieURL release];
    movieURL = nil;
	[super dealloc];
}

@end
