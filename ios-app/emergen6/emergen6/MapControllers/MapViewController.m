//
//  MapViewController.m
//  emergen6
//
//  Created by admin on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "UIView+XLFormAdditions.h"
#import <MapKit/MapKit.h>

#import "MapViewController.h"
#import "ServicesManager.h"



@interface MapAnnotation : NSObject  <MKAnnotation>
@end

@implementation MapAnnotation
@synthesize coordinate = _coordinate;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}
@end

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic) MKMapView * mapView;

@end

@implementation MapViewController

@synthesize rowDescriptor = _rowDescriptor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    if (self.rowDescriptor.value){
        [self.mapView setCenterCoordinate:((CLLocation *)self.rowDescriptor.value).coordinate];
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(((CLLocation *)self.rowDescriptor.value).coordinate, 800, 800)];
         [self.mapView setRegion:adjustedRegion animated:YES];
        self.title = [NSString stringWithFormat:@"%0.4f, %0.4f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude];
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = self.mapView.centerCoordinate;
        [self.mapView addAnnotation:annotation];
        
        
    }
}

-(MKMapView *)mapView
{
    if (_mapView) return _mapView;
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return _mapView;
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"annotation"];
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.draggable = YES;
    pinAnnotationView.animatesDrop = YES;
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding){
        self.rowDescriptor.value = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
        self.title = [NSString stringWithFormat:@"%0.4f, %0.4f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude];
    }
}

@end
