//
//  GoogleLicenseViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/3/22.
//

#import "GoogleLicenseViewController.h"
#import "GoogleMaps/GoogleMaps.h"

@interface GoogleLicenseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel1;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel2;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel3;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel4;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel5;
@end

@implementation GoogleLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *license = [GMSServices openSourceLicenseInfo];
    self.licenseLabel1.text = [license substringWithRange:NSMakeRange(0, 50000)];
    self.licenseLabel2.text = [license substringWithRange:NSMakeRange(50000, 50000)];
    self.licenseLabel3.text = [license substringWithRange:NSMakeRange(100000, 50000)];
    self.licenseLabel4.text = [license substringWithRange:NSMakeRange(150000, 50000)];
    self.licenseLabel5.text = [license substringWithRange:NSMakeRange(200000, 55596)];
}


@end
