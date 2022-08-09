//
//  BodyZone.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface BodyZone : PFObject<PFSubclassing>

/**
 * The body zone title
 */
@property (nonatomic, strong) NSString *title;

/**
 * The body zone icon
 */
@property (nonatomic, strong) PFFileObject *icon;
@end

NS_ASSUME_NONNULL_END
