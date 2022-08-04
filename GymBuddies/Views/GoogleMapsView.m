//
//  GoogleMapsTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/20/22.
//

#import "GoogleMapsView.h"

static NSString * const kSearchParksActionTitle = @" Parks";
static NSString * const kSearchGymsActionTitle = @" Gyms";
static NSString * const kPlaceTypePark = @"park";
static NSString * const kPlaceTypeGym = @"gym";

static float const kMapCameraZoom = 13.0;

static double const kAnimationDuration = 0.3;
static NSString *kAnimationKeyPath = @"position.y";

static NSString * const kKeysFilePath = @"../Keys";
static NSString * const kPlistType = @"plist";
static NSString * const kGoogleMapsAPIKeyPath = @"googleAPIKey";
static NSString * const kNearbyPlacesSearchBaseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
static NSString * const kResultsKey = @"results";

static NSString * const kPlaceIdAttributeKey = @"place_id";
static NSString * const kGeometryAttributeKey = @"geometry";
static NSString * const kLocationAttributeKey = @"location";
static NSString * const kLatitudeAttributeKey = @"lat";
static NSString * const kLongitudeAttributeKey = @"lng";


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
    [self bringSubviewToFront:self.showLicenseButton];

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
        CLLocationDegrees latitude = [place[kGeometryAttributeKey][kLocationAttributeKey][kLatitudeAttributeKey] doubleValue];
        CLLocationDegrees longitude = [place[kGeometryAttributeKey][kLocationAttributeKey][kLongitudeAttributeKey] doubleValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.snippet = place[kPlaceIdAttributeKey];
        marker.map = self.map;
        [self.markers addObject:marker];
    }
}


#pragma mark - Place detailed view methods

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    [self.placeView getPlaceInfo:marker.snippet];
    [self animatePlaceView:YES];
    GMSCameraUpdate *cameraLookingAtMarker = [GMSCameraUpdate setTarget:marker.position];
    [self.map animateWithCameraUpdate:cameraLookingAtMarker];
    return YES;
}


-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self animatePlaceView:NO];
}


-(void)animatePlaceView:(BOOL)presentingView{
    if(!self.isShowingDetails && !presentingView){
        return;
    }
    
    double currentOriginPosition = self.placeView.frame.origin.y;
    double offset;
    double googleMapViewPadding;
    double newBottomConstraint;
    
    if(presentingView){
        if(self.isShowingDetails){
            offset = 50;
        } else{
            offset = -50;
        }
        googleMapViewPadding = 100;
        newBottomConstraint = 0;
    } else{
        offset = 150;
        googleMapViewPadding = 0;
        newBottomConstraint = -100;
    }
    // Setting animation properties
    CABasicAnimation *animateDetailedView = [CABasicAnimation animationWithKeyPath:kAnimationKeyPath];
    [animateDetailedView setToValue: [NSNumber numberWithDouble:currentOriginPosition + offset]];
    animateDetailedView.fillMode = kCAFillModeForwards;
    animateDetailedView.removedOnCompletion = NO;
    animateDetailedView.duration = kAnimationDuration;
    animateDetailedView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // Changing constraint to execute after animation ends so the user interaction is moved along with the view
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.placeView.bottomConstraint.constant = newBottomConstraint;
        [self.placeView setNeedsUpdateConstraints];
        [self.placeView layoutIfNeeded];
        
    }];
    [self.placeView.layer addAnimation:animateDetailedView forKey:kAnimationKeyPath];
    [CATransaction commit];
    // Moving map buttons
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.map.padding = UIEdgeInsetsMake(0, 0, googleMapViewPadding, 0);
    }];
    
    self.isShowingDetails = presentingView;
}


#pragma mark - Places data fetching

-(void)fetchPlacesNearby:(void (^)(NSArray * results, NSError * error))completion{
    // Retrieving Google API key
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysFilePath ofType:kPlistType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *googleAPIKey = [dict objectForKey:kGoogleMapsAPIKeyPath];
    
    [self getVisibleViewRadius];
    
    //Creating request URL using the keys, location and type of place to search
    NSString *baseURL = [NSString stringWithFormat: @"%@location=%f%%2C%f&radius=%f&key=%@&type=%@", kNearbyPlacesSearchBaseURL, self.mapCenterView.latitude, self.mapCenterView.longitude, self.searchRadius, googleAPIKey, self.currentPlaceTypeSearch];
    
    NSURL *URLRequest = [NSURL URLWithString:baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URLRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *places = [responseDictionary valueForKey:kResultsKey];
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
    
    [self getMapCenter:southWest northEast:northEast];
}


-(void)getMapCenter:(CLLocationCoordinate2D)southWest
          northEast:(CLLocationCoordinate2D)northEast{
        double swRadianLongitude = southWest.longitude * M_PI / 180;
        double neRadianLongitude = northEast.longitude * M_PI / 180;

        double swRadianLatitude = southWest.latitude * M_PI / 180;
        double neRadianLatitude = northEast.latitude * M_PI / 180;

        double longitudeDifference = neRadianLongitude - swRadianLongitude;

        double x = cos(neRadianLatitude) * cos(longitudeDifference);
        double y = cos(neRadianLatitude) * sin(longitudeDifference);

        double centerRadianLatitude = atan2( sin(swRadianLatitude) + sin(neRadianLatitude), sqrt((cos(swRadianLatitude) + x) * (cos(swRadianLatitude) + x) + y * y) );
        double centerRadianLongitude = swRadianLongitude + atan2(y, cos(swRadianLatitude) + x);

        double centerDegreesLatitude  = centerRadianLatitude * 180 / M_PI;
        double centerDegreesLongitude = centerRadianLongitude * 180 / M_PI;
    
    self.mapCenterView = CLLocationCoordinate2DMake(centerDegreesLatitude, centerDegreesLongitude);
}

@end
