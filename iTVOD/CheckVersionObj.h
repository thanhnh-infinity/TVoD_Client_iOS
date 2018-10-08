
//  CheckVersionObj.h
//  iTVODForiPad

//  Created by vivas-mac on 10/11/12.



#import <Foundation/Foundation.h>

@interface CheckVersionObj : NSObject
{
    BOOL success;
    NSString *current_version;
    NSString *link_update;
}
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *current_version;
@property (nonatomic, copy) NSString *link_update;
@end
