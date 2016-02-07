//
//  CLLocationValueTrasformer.m
//  emergen6
//
//  Created by admin on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CLLocationValueTrasformer.h"

@implementation CLLocationValueTrasformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    CLLocation * location = (CLLocation *)value;
    return [NSString stringWithFormat:@"%0.4f, %0.4f", location.coordinate.latitude, location.coordinate.longitude];
}

@end
