//
//  ViewController.m
//  UberBean
//
//  Created by Jenny Chang on 25/01/2019.
//  Copyright © 2019 Jenny Chang. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () < MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// current location
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = TRUE;
    
    MKPointAnnotation *myLabs = [[MKPointAnnotation alloc] init];
    myLabs.coordinate = CLLocationCoordinate2DMake(49.281422, -123.114626);
    [self.mapView addAnnotation:myLabs];
    
    //requests authorisation when app first downloads
    
    [self.locationManager requestWhenInUseAuthorization];

}

// if user authorises, then request location
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager requestLocation];
}

// MAKE MY PINS CUSTOM IF I WANT - DIFFERENT CATEGORIES, HOSPITALS, RESTAURANTS ETC.
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *anyView;
    if ([annotation isKindOfClass: [MKPointAnnotation class]])
    {
        //////// VIEW
        anyView = [mapView dequeueReusableAnnotationViewWithIdentifier: @"pinId"];
        if (!anyView)
        {
            // If an existing pin view was not available, create one.
            anyView = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"pinId"];
            anyView.canShowCallout = YES;
            anyView.image = [UIImage imageNamed:@"pin.png"];
            anyView.calloutOffset = CGPointMake(0, -32);
            UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
            
            [rightButton addTarget:self
                            action:@selector(myTempAction)
                  forControlEvents:UIControlEventTouchUpInside];
            
            
            anyView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"lhlLogo.png"]];
            anyView.leftCalloutAccessoryView = iconView;
        }
        else
        {
            anyView.annotation = annotation;
        }
    }
    return anyView;

}

-(void)myTempAction
{
    NSLog(@"entering more info");
}

// this tells the delegate that there is new info available
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    NSLog(@"update me when location has been updated");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"yo there is an error");
}

- (IBAction)goHere:(UIButton *)sender {
    MKCoordinateRegion myRegion;
    
    CLLocationCoordinate2D myCen = CLLocationCoordinate2DMake(49.281422, -123.114626);
    MKCoordinateSpan span = MKCoordinateSpanMake(200, 200);
    
    myRegion = MKCoordinateRegionMakeWithDistance(myCen, span.longitudeDelta, span.latitudeDelta);
    [self.mapView setRegion:myRegion animated:true];
}



@end
