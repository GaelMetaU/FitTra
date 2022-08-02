//
//  CommonValidations.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonValidations : NSObject
+ (NSString *)standardizeUserAuthInput:(NSString *)input;
+(NSString *)standardizeSearchTerm:(NSString *)term;
@end

NS_ASSUME_NONNULL_END
