//
//  ExerciseDetailsViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "ExerciseDetailsViewController.h"
#import "Parse/PFImageView.h"

static NSString * const kProfilePictureKey = @"profilePicture";

@interface ExerciseDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTitle;
@property (weak, nonatomic) IBOutlet UILabel *authorUsername;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *bodyZoneTitle;
@end

@implementation ExerciseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setExercise:self.exercise];
}


-(void)setExercise:(Exercise *)exercise{
    _exercise = exercise;
    
    self.exerciseImage.file = self.exercise.image;
    [self.exerciseImage loadInBackground];
    
    if(self.exercise.author[kProfilePictureKey]){
        self.authorProfilePicture.file = self.exercise.author[kProfilePictureKey];
        self.authorProfilePicture.layer.cornerRadius = self.authorProfilePicture.frame.size.width/2;
        [self.authorProfilePicture loadInBackground];
    }
    
    self.bodyZoneIcon.file = self.exercise.bodyZoneTag.icon;
    [self.bodyZoneIcon loadInBackground];
    
    self.exerciseTitle.text = self.exercise.title;
    self.authorUsername.text = self.exercise.author.username;
    self.bodyZoneTitle.text = self.exercise.bodyZoneTag.title;
    
}


@end
