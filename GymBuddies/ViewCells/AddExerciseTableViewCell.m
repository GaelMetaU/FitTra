//
//  AddExerciseTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/14/22.
//

#import "AddExerciseTableViewCell.h"

static NSString * const kProfilePictureKey = @"profilePicture";

@interface AddExerciseTableViewCell ()
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation AddExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setExercise:(Exercise *)exercise{
    _exercise = exercise;
    
    self.exerciseImage.file = self.exercise.image;
    self.bodyZoneIcon.file = self.exercise.bodyZoneTag.icon;
    self.authorProfilePicture.file = self.exercise.author[kProfilePictureKey];
    
    [self.exerciseImage loadInBackground];
    [self.bodyZoneIcon loadInBackground];
    [self.authorProfilePicture loadInBackground];
    
    self.authorProfilePicture.layer.cornerRadius = self.authorProfilePicture.frame.size.width/2;
    
    self.titleLabel.text = self.exercise.title;
}

@end
