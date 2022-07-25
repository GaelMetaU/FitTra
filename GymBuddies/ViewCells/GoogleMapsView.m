//
//  GoogleMapsTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/20/22.
//

#import "GoogleMapsView.h"

static NSString * const PLACE_TYPE_PARK = @"park";
static NSString * const PLACE_TYPE_GYM = @"gym";
static float const MAP_CAMERA_ZOOM = 13.0;

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

    // Setting map's camera based on current location
    self.currentLocation = self.manager.location.coordinate;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude zoom:MAP_CAMERA_ZOOM];
    self.map.camera = camera;
    
    //Setting search button
    self.searchEnabledButton.changesSelectionAsPrimaryAction = YES;
    
    // Setting initial data
    [self setPlacesArrays];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location = [locations firstObject].coordinate;
    self.currentLocation = location;
}


#pragma mark - Map markers

-(void)placeMarkers:(BOOL)isGym{
    [self.map clear];
    [self.markers removeAllObjects];
    
    if(isGym){
        for(GMSPlace *gym in self.gymsDictionary){
            
            CLLocationDegrees latitude = gym.coordinate.latitude;
            CLLocationDegrees longitude = gym.coordinate.longitude;

            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];

            marker.title = gym.name;
            marker.snippet = gym.formattedAddress;
            marker.map = self.map;
            [self.markers addObject:marker];
        }
    } else {
        for(GMSPlace *park in self.parksDictionary){
            
            CLLocationDegrees latitude = park.coordinate.latitude;
            CLLocationDegrees longitude = park.coordinate.longitude;

            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];

            marker.title = park.name;
            marker.snippet = park.formattedAddress;
            marker.map = self.map;
            [self.markers addObject:marker];
        }
    }
}


-(NSURL *)createGoogleMapsLink{
    NSString *URLFormattedAddress = [self.currentSearchAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *googleMapsURLString = [NSString stringWithFormat:@"https://www.google.com/maps/place/%@", URLFormattedAddress];
    NSLog(@"%@",googleMapsURLString);
    return [NSURL URLWithString:googleMapsURLString];
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    self.currentSearchAddress = marker.snippet;
    NSLog(@"%@", self.currentSearchAddress);
    return NO;
}


- (IBAction)didTapSearch:(id)sender {
    NSURL *googleMapsURL =[self createGoogleMapsLink];
    NSLog(@"%@", googleMapsURL);
    [[UIApplication sharedApplication]openURL:googleMapsURL options:@{} completionHandler:nil];
}


- (IBAction)updateMarkers:(id)sender {
    if(self.searchEnabledButton.isSelected){
        [self placeMarkers:self.placesSegmentedControl.selectedSegmentIndex];
    }
}


#pragma mark - Places data fetching

-(void)setPlacesArrays{
    BOOL isGym = self.placesSegmentedControl.selectedSegmentIndex;

    //After fetching the places near the users, the markers are placed depending on the selected index of the segmented control
    [self fetchPlacesNearby:PLACE_TYPE_GYM completion:^(NSMutableArray * data) {
            self.gymsDictionary = data;
    }];
    [self fetchPlacesNearby:PLACE_TYPE_PARK completion:^(NSMutableArray * data) {
            self.parksDictionary = data;
    }];
    
    [self placeMarkers:isGym];
}


-(void)fetchPlacesNearby:(NSString *)placeType completion:(void(^)(NSMutableArray *))completion{
        
    // Retrieving Google API key
    NSString *path = [[NSBundle mainBundle] pathForResource:@"../Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *googleAPIKey = [dict objectForKey:@"googleAPIKey"];
    //Creating request URL using the keys, location and type of place to search
    NSString *baseURL = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f%%2C%f&radius=5000&key=%@&type=%@", self.currentLocation.latitude, self.currentLocation.longitude, googleAPIKey, placeType];
    
    NSURL *URLRequest = [NSURL URLWithString:baseURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URLRequest
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *parkDataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                    } else {
                                                        NSMutableArray *placesToReturn = [[NSMutableArray alloc]init];
                                                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        NSMutableArray *places = [responseDictionary valueForKey:@"results"];
                                                        for (NSDictionary *place in places){
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self getPlaceDetails:place completion:^(GMSPlace *result) {
                                                                    if(result != nil){
                                                                        [placesToReturn addObject:result];
                                                                    }
                                                                }];
                                                            });
                                                        }
                                                        return completion(placesToReturn);
                                                    }
                                                }];
    [parkDataTask resume];
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


- (IBAction)enableSearch:(id)sender {
    if(self.searchEnabledButton.isSelected){
        [self placeMarkers:self.placesSegmentedControl.selectedSegmentIndex];
    } else {
        [self.map clear];
    }
}
@end
