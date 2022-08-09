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

/**
 * The exercise author
 */
@property (nonatomic, strong) PFUser *author;

/**
 * The exercise title
 */
@property (nonatomic, strong) NSString *title;

/**
 * The exercise video (if given on creation)
 */
@property (nonatomic, strong) PFFileObject *video;

/**
 * The exercise image view
 */
@property (nonatomic, strong) PFFileObject *image;

/**
 * The exercise body zone tag (required)
 */
@property (nonatomic, strong) BodyZone *bodyZoneTag;

/**
 * Initiation method
 */
+ (Exercise *) initWithAttributes:(NSString *)exerciseTitle
                          author:(PFUser *)exerciseAuthor
                           video:(PFFileObject *)exerciseVideo
                           image:(PFFileObject *)exerciseImage
                     bodyZoneTag:(BodyZone *)exerciseBodyZoneTag;
@end

NS_ASSUME_NONNULL_END
