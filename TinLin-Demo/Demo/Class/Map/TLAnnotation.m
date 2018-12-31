//
//  TLAnnotation.m
//  Demo
//
//  Created by Mac on 2018/12/5.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLAnnotation.h"

@implementation TLAnnotation

- (instancetype)initWithImage:(UIImage *)image Coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _image = image;
        _coordinate = coordinate;
        _title = @"TinLin HaHa";
        _subtitle = @"subtitle";
    }
    return self;
}

@end
