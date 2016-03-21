//
//  RequestManager.h
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface RequestManager : NSObject

+ (void) CreateDownloadRequest:(NSString *)urlString
                        success:(void (^)(NSDictionary *data, NSURLResponse *response))success
                        failure:(void (^)(NSError *error))failure;

@end
