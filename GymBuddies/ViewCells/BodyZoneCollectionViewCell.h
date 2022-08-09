//
//  BodyZoneCollectionViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "BodyZone.h"

NS_ASSUME_NONNULL_BEGIN

@interface BodyZoneCollectionViewCell : UICollectionViewCell

/**
 * Body zone that gives content to the cell
 */
@property (nonatomic, strong) BodyZone *bodyZone;

/**
 * Setting the cell content with an image view and a title
 */
- (void)setCellContent:(BodyZone *)bodyZone;

/**
 * Setting the cell content with an image view only
 */
- (void)setCellContentNoTitle:(BodyZone *)bodyZone;

@end

NS_ASSUME_NONNULL_END
