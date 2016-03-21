//
//  Record.h
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Record : NSObject

@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) NSString *descriptionText;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *appIcon;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
