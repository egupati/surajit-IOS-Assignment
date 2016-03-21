//
//  ConceptTableViewCell.h
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConceptTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, assign) BOOL didSetupConstraints;

+ (CGFloat) fetchImageIconHeight;
+ (CGFloat) fetchImageIconWidth;

@end
