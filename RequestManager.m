//
//  RequestManager.m
//  Concept
//
//  Created by Surajit on 17/03/2016.
//  Copyright © 2016 axomedia. All rights reserved.
//

#import "RequestManager.h"
#import "AppDelegate.h"

@implementation RequestManager


+ (void) CreateDownloadRequest:(NSString *)urlString
                       success:(void (^)(NSDictionary *data, NSURLResponse *response))success
                       failure:(void (^)(NSError *error))failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    // create an session data task to obtain and process JSON
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession]
                        dataTaskWithRequest:request
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (error != nil){
                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     
                            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection){
                                abort();
                            }
                            else{
                                 AppDelegate *delegate =
                                (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                 [delegate handleError:error];
                            }
                        }];
                        
                            failure(error);
                        }else{//Success
                            NSString *responseString = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                            NSError *err = nil;
                            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
                            NSLog(@"RESP = %@",responseString);
                            NSLog(@"RESP DICT = %@",responseData);
                            success(responseData,response);
                            
                        }
                          }];
    [sessionTask resume];
}


@end
