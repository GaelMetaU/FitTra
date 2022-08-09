//
//  RoutineDetailsViewController.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Routine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoutineDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

/**
 * The routine to be displayed in the view
 */
@property (strong, nonatomic) Routine *routine;

/**
 * Boolean to specify if the routine is liked by the user
 */
@property (nonatomic) BOOL isLiked;

@end

NS_ASSUME_NONNULL_END
