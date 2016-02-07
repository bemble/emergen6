//
//  ServicesManager.m
//  emergen6
//
//  Created by yann breleur on 16/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "ServicesManager.h"
#import <UIKit/UIKit.h>

#import "HelpQuestionsViewController.h"

@implementation ServicesManager

static NSString *apiBaseUrl;

+(NSString*) getApiUrl:(NSString *)forType {
    if(apiBaseUrl == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        apiBaseUrl = [settings objectForKey:@"apiBaseUrl"];
    }
    return [NSString stringWithFormat:@"%@/api/%@", apiBaseUrl, forType];
}

+(void)saveUserWithData:(NSMutableDictionary *)jsonProfile AndDelegate:(id)delegate{
    NSString *apiUrl = [self getApiUrl:@"utilisateurs"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:apiUrl]];
    
    
    NSData *jsonData;
    if ([NSJSONSerialization isValidJSONObject:jsonProfile])
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonProfile
                                                           options:0
                                                             error:nil];
        
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Retour de webService : %@", result);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"profile.dat"];
        
        [data writeToFile:dataPath atomically:YES];
    }];
    
    [task resume];
}

+(void)sendFormWithData:(NSMutableDictionary *)formData  AndDelegate:(id)delegate{
    NSString *apiUrl = [self getApiUrl:@"signalements"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:apiUrl]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"profile.dat"];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];;
    
    
    if (jsonString) {
        jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    } else {
        jsonDict = [[NSMutableDictionary alloc] init];
    }
    
    
    if ([jsonDict objectForKey:@"id"]) {
        [formData setObject:[jsonDict objectForKey:@"id"] forKey:@"userid"];
    } else {
        [formData addEntriesFromDictionary:jsonDict];
    }
    
    if ([(HelpQuestionsViewController *)delegate alertId]) {
        [formData setObject:[(HelpQuestionsViewController *)delegate alertId] forKey:@"id"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:formData]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:formData
                                                           options:0
                                                             error:nil];
        
        [request setHTTPBody:jsonData];
    }
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([jsonDict objectForKey:@"id"])
            [(HelpQuestionsViewController *)delegate setAlertId:[jsonDict objectForKey:@"id"]];
    }];
    [task resume];
}


@end
