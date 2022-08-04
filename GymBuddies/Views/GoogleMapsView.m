//
//  GoogleMapsTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/20/22.
//

#import "GoogleMapsView.h"

static NSString * const kPlaceTypePark = @"park";
static NSString * const kPlaceTypeGym = @"gym";
static float const kMapCameraZoom = 13.0;

static NSString * const kSearchParksActionTitle = @" Parks";
static NSString * const kSearchGymsActionTitle = @" Gyms";


@implementation GoogleMapsView


-(void)setContent{
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];
    
    // Setting map's properties
    self.map.settings.compassButton = YES;
    [self.map setMyLocationEnabled:YES];
    self.map.settings.myLocationButton = YES;
    self.map.delegate = self;
    self.currentPlaceTypeSearch = kPlaceTypePark;
    [self.map bringSubviewToFront:self.placeView];


    // Setting map's camera based on current location
    self.currentLocation = self.manager.location.coordinate;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude zoom:kMapCameraZoom];
    self.map.camera = camera;
    
    [self setPlaceTypeMenu];
    
    // Setting placed detailed view
    self.placeView.layer.cornerRadius = 15;
    self.isShowingDetails = NO;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location = [locations firstObject].coordinate;
    self.currentLocation = location;
}


#pragma mark - Button interaction

- (IBAction)didTapSearch:(id)sender {
    [self searchPlaces];
}


-(void)searchPlaces{
    [self fetchPlacesNearby:^(NSArray *results, NSError *error) {
        if(error == nil){
            self.placesResults = results;
        }
        [self placeMarkers];
    }];
}


-(void)setPlaceTypeMenu{
    UIAction *searchParks = [UIAction actionWithTitle:kSearchParksActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changePlaceTypeSearch:kSearchParksActionTitle workoutPlace:kPlaceTypePark];
    }];
    searchParks.state = UIMenuElementStateOn;
    
    UIAction *searchGyms = [UIAction actionWithTitle:kSearchGymsActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changePlaceTypeSearch:kSearchGymsActionTitle workoutPlace:kPlaceTypeGym];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects:searchParks, searchGyms, nil]];
    self.placeTypeSelectionMenu.menu = menu;
    self.placeTypeSelectionMenu.showsMenuAsPrimaryAction = YES;
}


-(void)changePlaceTypeSearch:(NSString *)actionTitle workoutPlace:(NSString *)workoutPlace{
    for(UIAction *action in self.placeTypeSelectionMenu.menu.children){
        if(action.title == actionTitle){
            self.currentPlaceTypeSearch = workoutPlace;
            [self.placeTypeSelectionMenu setTitle:actionTitle forState:UIControlStateNormal];
            action.state = UIMenuElementStateOn;
        } else {
            action.state = UIMenuElementStateOff;
        }
    }
}

#pragma mark - Map markers

-(void)placeMarkers{
    [self.map clear];
    [self.markers removeAllObjects];
    
    for(NSDictionary *place in self.placesResults){
        CLLocationDegrees latitude = [place[@"geometry"][@"location"][@"lat"] doubleValue];
        CLLocationDegrees longitude = [place[@"geometry"][@"location"][@"lng"] doubleValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.snippet = place[@"place_id"];
        marker.map = self.map;
        [self.markers addObject:marker];
    }
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    [self.placeView getPlaceInfo:marker.snippet];
    [self showDetails];
    return YES;
}


-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self dismissDetails];
}


-(void)showDetails{
    NSNumber *newPosition = [NSNumber new];

    if(self.isShowingDetails){
        newPosition = [NSNumber numberWithDouble:self.placeView.frame.origin.y+50];
    } else{
        newPosition = [NSNumber numberWithDouble:self.placeView.frame.origin.y-50];
    }
    
    CABasicAnimation *presentDetailedView = [CABasicAnimation animationWithKeyPath:@"position.y"];
    [presentDetailedView setToValue: newPosition];
    presentDetailedView.fillMode = kCAFillModeForwards;
    presentDetailedView.removedOnCompletion = NO;
    presentDetailedView.duration = 1;
    presentDetailedView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [UIView animateWithDuration:1 animations:^{
        self.map.padding = UIEdgeInsetsMake(0, 0, 100, 0);
    }];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.placeView.bottomConstraint.constant = 0;
        [self.placeView setNeedsUpdateConstraints];
        [self.placeView layoutIfNeeded];
        
    }];
    [self.placeView.layer addAnimation:presentDetailedView forKey:@"position.y"];
    [CATransaction commit];
    
    self.isShowingDetails = YES;
}


-(void)dismissDetails{
    if(!self.isShowingDetails){
        return;
    }
    
    NSNumber *newPosition = [NSNumber numberWithDouble:self.placeView.frame.origin.y+150];
    
    CABasicAnimation *dismissDetailedView = [CABasicAnimation animationWithKeyPath:@"position.y"];
    [dismissDetailedView setToValue: newPosition];
    dismissDetailedView.fillMode = kCAFillModeForwards;
    dismissDetailedView.removedOnCompletion = NO;
    dismissDetailedView.duration = 1;
    dismissDetailedView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [UIView animateWithDuration:1 animations:^{
        self.map.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.placeView.bottomConstraint.constant = -100;
        [self.placeView setNeedsUpdateConstraints];
        [self.placeView layoutIfNeeded];
        
    }];
    [self.placeView.layer addAnimation:dismissDetailedView forKey:@"position.y"];
    [CATransaction commit];

    self.isShowingDetails = NO;
}


#pragma mark - Places data fetching

-(void)fetchPlacesNearby:(void (^)(NSArray * results, NSError * error))completion{
    // Retrieving Google API key
    NSString *path = [[NSBundle mainBundle] pathForResource:@"../Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *googleAPIKey = [dict objectForKey:@"googleAPIKey"];
    
    [self getVisibleViewRadius];
    
    //Creating request URL using the keys, location and type of place to search
    NSString *baseURL = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f%%2C%f&radius=%f&key=%@&type=%@", self.currentLocation.latitude, self.currentLocation.longitude, self.searchRadius, googleAPIKey, self.currentPlaceTypeSearch];
    
    NSURL *URLRequest = [NSURL URLWithString:baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URLRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *places = [responseDictionary valueForKey:@"results"];
                completion(places, error);
            }
        });
            
    }];
    [dataTask resume];
}


-(void)getVisibleViewRadius{
    GMSVisibleRegion visibleRegion = [self.map.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    
    CLLocationCoordinate2D southWest = bounds.southWest;
    CLLocationCoordinate2D northEast = bounds.northEast;
    
    CLLocation *southWestLocation = [[CLLocation alloc]initWithLatitude:southWest.latitude longitude:southWest.longitude];
    CLLocation *northEastLocation = [[CLLocation alloc]initWithLatitude:northEast.latitude longitude:northEast.longitude];
    CLLocationDistance distance = [southWestLocation distanceFromLocation:northEastLocation];
    
    self.searchRadius = distance / 2;
    NSLog(@"%f", self.searchRadius);

}


@end
