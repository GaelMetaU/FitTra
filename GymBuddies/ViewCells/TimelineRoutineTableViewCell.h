//
//  TimelineRoutineTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimelineRoutineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *authorUsername;

@end

NS_ASSUME_NONNULL_END
