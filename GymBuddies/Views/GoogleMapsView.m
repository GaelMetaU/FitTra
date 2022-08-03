//
//  GoogleMapsTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/20/22.
//

#import "GoogleMapsView.h"

static NSString * const kPlaceTypePark = @"park";
static NSString * const kPlaceTypeGym = @"gym";
static float const MAP_CAMERA_ZOOM = 13.0;

static NSString * const kSearchParksActionTitle = @" Parks";
static NSString * const kSearchGymsActionTitle = @" Gyms";

static double const k500MetersRadius = 500;
static NSString * const k500MetersActionTitle = @"500m";
static double const k1000MetersRadius = 1000;
static NSString * const k1000MetersActionTitle = @"1km";
static double const k2000MetersRadius = 2000;
static NSString * const k2000MetersActionTitle = @"2km";
static double const k3000MetersRadius = 3000;
static NSString * const k3000MetersActionTitle = @"3km";
static double const k4000MetersRadius = 4000;
static NSString * const k4000MetersActionTitle = @"4km";
static double const k5000MetersRadius = 5000;
static NSString * const k5000MetersActionTitle = @"5km";


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
    self.searchRadius = k500MetersRadius;

    // Setting map's camera based on current location
    self.currentLocation = self.manager.location.coordinate;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude zoom:MAP_CAMERA_ZOOM];
    self.map.camera = camera;
    
    [self setPlaceTypeMenu];
    
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
        NSLog(@"tap");
        if(error == nil){
            self.placesResults = results;
        }
        [self placeMarkers];
    }];
}
//- (IBAction)didTapVisitPlace:(id)sender {
//    NSURL *googleMapsURL =[self createGoogleMapsLink];
//    NSLog(@"%@", googleMapsURL);
//    [[UIApplication sharedApplication]openURL:googleMapsURL options:@{} completionHandler:nil];
//}


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


-(void)setSearchRadiusMenu{
    UIAction *searchRadius500 = [UIAction actionWithTitle:k500MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k500MetersActionTitle radius:k500MetersRadius];
    }];
    
    UIAction *searchRadius1000 = [UIAction actionWithTitle:k1000MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k1000MetersActionTitle radius:k1000MetersRadius];
    }];
    
    UIAction *searchRadius2000 = [UIAction actionWithTitle:k2000MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k2000MetersActionTitle radius:k2000MetersRadius];
    }];
    
    UIAction *searchRadius3000 = [UIAction actionWithTitle:k3000MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k3000MetersActionTitle radius:k3000MetersRadius];
    }];
    
    UIAction *searchRadius4000 = [UIAction actionWithTitle:k4000MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k4000MetersActionTitle radius:k4000MetersRadius];
    }];
    
    UIAction *searchRadius5000 = [UIAction actionWithTitle:k5000MetersActionTitle image:nil identifier:nil handler:^(UIAction *action){
        [self changeSearchRadius:k5000MetersActionTitle radius:k5000MetersRadius];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects: searchRadius500, searchRadius1000, searchRadius2000, searchRadius3000, searchRadius4000, searchRadius5000, nil]];
    self.distanceSelectionMenu.showsMenuAsPrimaryAction = YES;
    self.distanceSelectionMenu.menu = menu;
}


-(void)changeSearchRadius:(NSString *)actionTitle radius:(double)radius{
    for(UIAction *action in self.placeTypeSelectionMenu.menu.children){
        if(action.title == actionTitle){
            self.searchRadius = radius;
            [self.distanceSelectionMenu setTitle:actionTitle forState:UIControlStateNormal];
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
        marker.title = place[@"name"];
        //marker.snippet = park.formattedAddress;
        marker.map = self.map;
        [self.markers addObject:marker];
    }
}


//-(NSURL *)createGoogleMapsLink{
//    NSString *URLFormattedAddress = [self.currentSearchAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *googleMapsURLString = [NSString stringWithFormat:@"https://www.google.com/maps/place/%@", URLFormattedAddress];
//    NSLog(@"%@",googleMapsURLString);
//    return [NSURL URLWithString:googleMapsURLString];
//}


//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
//    return NO;
//}


#pragma mark - Places data fetching

-(void)fetchPlacesNearby:(void (^)(NSArray * results, NSError * error))completion{
    // Retrieving Google API key
    NSString *path = [[NSBundle mainBundle] pathForResource:@"../Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *googleAPIKey = [dict objectForKey:@"googleAPIKey"];
    
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


-(void)getPlaceDetails:(NSDictionary *)place completion:(void (^)(GMSPlace *))completion{
    GMSPlacesClient *placesClient = [GMSPlacesClient new];
    GMSPlaceField fields = (GMSPlaceFieldName|GMSPlaceFieldFormattedAddress|GMSPlaceFieldCoordinate);
    [placesClient fetchPlaceFromPlaceID:place[@"place_id"] placeFields:fields sessionToken:nil callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil);
            }
            if (result != nil) {
                return completion(result);
            }
    }];
}


@end
