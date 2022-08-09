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
#import "DetailedPlaceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleMapsView : UIView <CLLocationManagerDelegate, GMSMapViewDelegate>

/**
 * Initiates the view content, loads the map and sets the necessary properties to track location
 */
- (void)setContent;
@end

NS_ASSUME_NONNULL_END
