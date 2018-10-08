
//  cellIndentifier.m
//  iTVOD

//  Created by Do Thanh Nam on 28/12/2012.
//  Copyright (c) 2012 NAMDT. All rights reserved.


#import "cellIdentifier.h"

@implementation cellIndentifier
@synthesize thumbnailTitle = _thumbnailTitle;
@synthesize largeTitle = _largeTitle;
@synthesize smalTitle = _smalTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
