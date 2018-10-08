
//  RootViewController.h
//  iTVOD

//  Created by vivas-mac on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SearchViewController.h"
#import "UserViewController.h"

@interface RootViewController : UIViewController<UITabBarControllerDelegate>
{
    UITabBarController *tbControl;
}
@end
