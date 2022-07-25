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
@property (weak, nonatomic) IBOutlet PFImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BodyZone *bodyZone;
-(void)setCellContent:(BodyZone *)bodyZone;
@end

NS_ASSUME_NONNULL_END
