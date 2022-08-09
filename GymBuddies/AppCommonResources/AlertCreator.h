//
//  AlertCreator.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertCreator : UIAlertController

/**
 * Generates an alert controller with a given title and message and a default ok action (Only dismisses the alert when
 * tapping the alert button)
 */
+ (UIAlertController *)createOkAlert:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
