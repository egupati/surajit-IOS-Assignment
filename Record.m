//
//  Record.m
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import "Record.h"

@implementation Record

- (instancetype) initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (dictionary[@"title"] != (id)[NSNull null] ) {
           self.titleText = dictionary[@"title"];
       }else{
           self.titleText = @"";
       }
        if (dictionary[@"description"] != (id)[NSNull null] ) {
            self.descriptionText = dictionary[@"description"];
        }else{
            self.descriptionText = @"";
        }
        if ( dictionary[@"imageHref"] != (id)[NSNull null] ) {
            self.imageUrl =  dictionary[@"imageHref"];
        }else{
            self.imageUrl = @"";
        }
    }
    return self;
}
@end
