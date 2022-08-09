//
//  CommonValidations.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonValidations : NSObject

/**
 * Receives the user input from an authentication text field, trims the string and returns it standardized
 */
+ (NSString *)standardizeUserAuthInput:(NSString *)input;

/**
 * Receives a terms and standardizes it for a search method, trims the string and converts all letters to lowercase
 */
+ (NSString *)standardizeSearchTerm:(NSString *)term;
@end

NS_ASSUME_NONNULL_END
