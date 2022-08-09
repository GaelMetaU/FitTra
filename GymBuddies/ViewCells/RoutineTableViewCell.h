//
//  RoutineTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "ParseAPIManager.h"
#import "AlertCreator.h"
#import "Routine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoutineTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

/**
 * Routine that gives content to the cell
 */
@property (strong, nonatomic) Routine *routine;

/**
 * Setting the cell content with a routine
 */
- (void)setCellContent:(Routine *)routine;

/**
 * Boolean to indicate if the user has liked the routine or not
 */
@property (nonatomic) BOOL isLiked;
@end

NS_ASSUME_NONNULL_END
