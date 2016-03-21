//
//  ConceptTableViewCell.m
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import "ConceptTableViewCell.h"
#import "PureLayout.h"

static const CGFloat kTopPadding = 5.0;
static const CGFloat kTrailingPadding = 5.0;
static const CGFloat kImageHeight = 70.0;
static const CGFloat kImageWidth = 50.0;

@implementation ConceptTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style
                                    reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        [self setNeedsUpdateConstraints];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageIcon];
        [self updateViewConstraints];
     }
    return self;
}


- (void) updateViewConstraints {
    
    if (!self.didSetupConstraints) {
        [self.imageIcon autoSetDimensionsToSize:CGSizeMake(kImageHeight, kImageHeight)];
        [self.imageIcon autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kTopPadding];
        [self.imageIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kTopPadding];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kTopPadding];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageIcon withOffset:8.0];
        [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:2.0];
        [self.descriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageIcon withOffset:8.0];
        [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kTrailingPadding];
        self.didSetupConstraints = YES;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *) titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initForAutoLayout];
        _titleLabel.font = [UIFont fontWithName:@"verdana-Bold" size:15.0f];
        _titleLabel.textColor = [UIColor blueColor];
    }
    return _titleLabel;
}

- (UILabel *) descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]initForAutoLayout];
        [_descriptionLabel sizeToFit];
    }
    return _descriptionLabel;
}

- (UIImageView *) imageIcon{
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]initForAutoLayout];
//        _imageIcon.layer.cornerRadius = 4.3;
//        _imageIcon.layer.borderColor = [UIColor grayColor].CGColor;
//        _imageIcon.layer.borderWidth = 4.3;
    }
    return _imageIcon;
}

#pragma mark - UTILITY SIZE METHOD
+ (CGFloat) fetchImageIconHeight{
     return kImageHeight;
}

+ (CGFloat) fetchImageIconWidth{
    return kImageWidth;
}


@end
