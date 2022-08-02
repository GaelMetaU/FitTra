//
//  CommonValidations.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import "CommonValidations.h"

@implementation CommonValidations

+ (NSString *)standardizeUserAuthInput:(NSString *)input {
    if (input.length > 0) {
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return input;
}


+(NSString *)standardizeSearchTerm:(NSString *)term{
    return [[term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
}

@end
