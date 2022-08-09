//
//  AlertCreator.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/15/22.
//

#import "AlertCreator.h"

@interface AlertCreator ()

@end

@implementation AlertCreator

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (UIAlertController *)createOkAlert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    return alert;
}

@end
