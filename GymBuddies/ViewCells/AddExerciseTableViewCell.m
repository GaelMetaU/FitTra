//
//  AddExerciseTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/14/22.
//

#import "AddExerciseTableViewCell.h"

static NSString * const kProfilePictureKey = @"profilePicture";

@implementation AddExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setExercise:(Exercise *)exercise{
    self.exerciseImage.file = exercise.image;
    self.bodyZoneIcon.file = exercise.bodyZoneTag.icon;
    self.authorProfilePicture.file = exercise.author[kProfilePictureKey];
    
    [self.exerciseImage loadInBackground];
    [self.bodyZoneIcon loadInBackground];
    [self.authorProfilePicture loadInBackground];
    
    self.authorProfilePicture.layer.cornerRadius = self.authorProfilePicture.frame.size.width/2;
    
    self.titleLabel.text = exercise.title;
}

@end
