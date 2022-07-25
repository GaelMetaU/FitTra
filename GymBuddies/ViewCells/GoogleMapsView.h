//
//  GoogleMapsView.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"
#import "GooglePlaces/GooglePlaces.h"
#import "CoreLocation/CoreLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleMapsView : UIView <CLLocationManagerDelegate, GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *map;
@property (weak, nonatomic) IBOutlet UISegmentedControl *placesSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *searchAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *searchEnabledButton;
@property (strong, nonatomic) NSString *currentSearchAddress;
@property (strong, nonatomic) CLLocationManager *manager;
@property CLLocationCoordinate2D currentLocation;
@property NSString *currentMarkerPlaceName;
@property (strong, nonatomic) NSMutableArray *parksDictionary;
@property (strong, nonatomic) NSMutableArray *gymsDictionary;
@property (strong, nonatomic) NSMutableArray *markers;
-(void)setContent;
@end

NS_ASSUME_NONNULL_END
