//
//  DetailedPlaceView.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/3/22.
//

#import "GooglePlaces/GooglePlaces.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailedPlaceView : UIView

/**
 * View's bottom constraint. Modifying it allows animations to take effect correclty
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

/**
 * After passing it a place ID from the Google Places API, retrieves the place's info to set the view's content
 */
- (void)getPlaceInfo:(NSString *)placeID;
@end

NS_ASSUME_NONNULL_END
