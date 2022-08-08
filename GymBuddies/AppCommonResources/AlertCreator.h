//
//  AlertCreator.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertCreator : UIAlertController
+ (UIAlertController *)createOkAlert:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
