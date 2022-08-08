//
//  DetailedPlaceView.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/3/22.
//

#import "DetailedPlaceView.h"

@implementation DetailedPlaceView

- (void)getPlaceInfo:(NSString *)placeID{
    if (![self.place.placeID isEqualToString:placeID]){
        GMSPlacesClient *placesClient = [GMSPlacesClient new];
        GMSPlaceField fields = (GMSPlaceFieldName|GMSPlaceFieldFormattedAddress|GMSPlaceFieldCoordinate);
        [placesClient fetchPlaceFromPlaceID:placeID placeFields:fields sessionToken:nil callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
            if (error == nil){
                [self setNewPlaceContent:result];
            }
        }];
    }
}


- (void)setNewPlaceContent:(GMSPlace *)newPlace{
    self.place = newPlace;
    self.placeName.text = self.place.name;
    self.fullAddress.text = self.place.formattedAddress;
    
    NSString *URLFormattedAddress = [self.place.formattedAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *googleMapsURLString = [NSString stringWithFormat:@"https://www.google.com/maps/place/%@", URLFormattedAddress];
    self.googleMapsURL = [NSURL URLWithString:googleMapsURLString];
}


- (IBAction)didTapVisitPlace:(id)sender {
    if (self.googleMapsURL != nil){
        [[UIApplication sharedApplication]openURL:self.googleMapsURL options:@{} completionHandler:nil];
    }
}

@end
