//
//  ServicesManager.h
//  emergen6
//
//  Created by yann breleur on 16/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicesManager : NSObject

+(NSString*)getApiUrl:(NSString *)forType;

+(void)saveUserWithData:(NSMutableDictionary *)jsonProfile AndDelegate:(id)delegate;

+(void)sendFormWithData:(NSMutableDictionary *)formData  AndDelegate:(id)delegate;

@end
