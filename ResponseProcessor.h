//
//  ResponseProcessor.h
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseProcessor : NSObject

+ (NSArray *) processNoOfRows:(NSDictionary *)response;
+ (NSString *) processTitle:(NSDictionary *)response;
@end
