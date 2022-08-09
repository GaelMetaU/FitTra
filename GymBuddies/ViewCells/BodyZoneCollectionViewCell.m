//
//  BodyZoneCollectionViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import "BodyZoneCollectionViewCell.h"

@interface BodyZoneCollectionViewCell ()
@property (weak, nonatomic) IBOutlet PFImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BodyZoneCollectionViewCell

-(void)setCellContent:(BodyZone *)bodyZone{
    _bodyZone = bodyZone;
    self.iconView.file = self.bodyZone.icon;
    [self.iconView loadInBackground];
    self.titleLabel.text = self.bodyZone.title;
}

-(void)setCellContentNoTitle:(BodyZone *)bodyZone{
    _bodyZone = bodyZone;
    self.iconView.file = self.bodyZone.icon;
    [self.iconView loadInBackground];
}

@end
