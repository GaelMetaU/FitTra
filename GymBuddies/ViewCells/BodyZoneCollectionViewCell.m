//
//  BodyZoneCollectionViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/13/22.
//

#import "BodyZoneCollectionViewCell.h"

@implementation BodyZoneCollectionViewCell

-(void)setCellContent:(BodyZone *)bodyZone{
    _bodyZone = bodyZone;
    self.iconView.file = self.bodyZone.icon;
    [self.iconView loadInBackground];
    self.titleLabel.text = self.bodyZone.title;
}

@end
