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
@property (strong, nonatomic) Routine *routine;
@property (nonatomic) BOOL isLiked;

@end

NS_ASSUME_NONNULL_END
