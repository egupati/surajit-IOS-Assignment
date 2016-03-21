//
//  ResponseProcessor.h
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

@import UIKit;
@class Record;

@interface IconDownloader : NSObject

@property (nonatomic, strong) Record *appRecord;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
