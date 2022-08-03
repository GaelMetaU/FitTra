//
//  DetailedPlaceView.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/3/22.
//

#import "GooglePlaces/GooglePlaces.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailedPlaceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *fullAddress;
@property (strong, nonatomic) NSURL *googleMapsURL;
@property (strong, nonatomic) GMSPlace *place;
-(void)getPlaceInfo:(NSString *)placeID;
@end

NS_ASSUME_NONNULL_END
