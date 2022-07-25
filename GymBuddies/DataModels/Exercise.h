//
//  Exercise.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import <Parse/Parse.h>
#import "BodyZone.h"

NS_ASSUME_NONNULL_BEGIN

@interface Exercise : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFFileObject *video;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) BodyZone *bodyZoneTag;
+(Exercise *) initWithAttributes:(NSString *)exerciseTitle
                          author:(PFUser *)exerciseAuthor
                           video:(PFFileObject *)exerciseVideo
                           image:(PFFileObject *)exerciseImage
                     bodyZoneTag:(BodyZone *)exerciseBodyZoneTag;
@end

NS_ASSUME_NONNULL_END
