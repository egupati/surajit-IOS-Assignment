//
//  ResponseProcessor.m
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import "ResponseProcessor.h"
#import "Record.h"

@implementation ResponseProcessor
+ (NSArray *) processNoOfRows:(NSDictionary *)response{
    __block NSMutableArray *responseArray = [[NSMutableArray alloc]initWithCapacity:1];
    NSArray *responseProcess = response[@"rows"];
    [responseProcess enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Record *record = [[Record alloc]initWithDictionary:obj];
        [responseArray addObject:record];
    }];
    return responseArray;
}

+ (NSString *) processTitle:(NSDictionary *)response{
    return response[@"title"];
}

@end
