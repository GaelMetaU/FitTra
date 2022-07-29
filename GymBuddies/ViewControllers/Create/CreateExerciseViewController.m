//
//  CreateExerciseViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import "CreateExerciseViewController.h"
#import "AVKit/AVKit.h"
#import "AVFoundation/AVFoundation.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "ParseAPIManager.h"
#import "CommonValidations.h"
#import "BodyZoneCollectionViewCell.h"
#import "BodyZone.h"
#import "AlertCreator.h"

static NSString * const kBodyZoneCollectionViewCellIdentifier = @"BodyZoneCollectionViewCell";

@interface CreateExerciseViewController ()
@property (strong, nonatomic) UIImagePickerController *mediaPicker;
@property (weak, nonatomic) IBOutlet PFImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) NSArray *bodyZones;
@property (weak, nonatomic) IBOutlet UICollectionView *bodyZoneCollectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *postProgressView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSString *exerciseTitle;
@property (strong, nonatomic) NSString *exerciseCaption;
@property (strong, nonatomic) PFFileObject *exerciseVideo;
@property (strong, nonatomic) BodyZone *exerciseBodyZoneTag;

@end

@implementation CreateExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleField.delegate = self;
    
    self.postProgressView.hidden = YES;
    // Media picker set up
    self.mediaPicker = [UIImagePickerController new];
    self.mediaPicker.delegate = self;
    self.mediaPicker.allowsEditing = YES;
    // Collection view set up
    self.bodyZoneCollectionView.dataSource = self;
    self.bodyZoneCollectionView.delegate = self;
    [self fetchBodyZones];
}


#pragma mark - Saving exercise query and validations

- (IBAction)didTapDone:(id)sender {
    self.doneButton.userInteractionEnabled = NO;
    self.postProgressView.hidden = NO;
    
    if(self.exerciseBodyZoneTag.title == nil){
        UIAlertController *alert = [AlertCreator createOkAlert:@"The exercise has no body zone" message:@"Pick a body zone for your exercise"];
        [self presentViewController:alert animated:YES completion:nil];
        self.postProgressView.hidden = YES;
        self.doneButton.userInteractionEnabled = YES;
        return;
    }
    // Sets the fields value to the posts, set default values if empty
    [self _setTitleValue];
    
    Exercise *exercise = [Exercise initWithAttributes:self.exerciseTitle author:[PFUser currentUser] video:self.exerciseVideo image:self.imagePreview.file bodyZoneTag:self.exerciseBodyZoneTag];
    // When uploading the object, it reasigns itself to include the objectID from Parse
    exercise = [ParseAPIManager postExercise:exercise progress:self.postProgressView completion:^(BOOL succeeded, NSError * _Nullable error) {
            if(!succeeded){
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error saving exercise" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            } else{
                [self.delegate didCreateExercise:exercise];
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.postProgressView.hidden = YES;
            self.doneButton.userInteractionEnabled = YES;
    }];
    

}


-(void)_setTitleValue{
    NSString *title = [CommonValidations standardizeUserAuthInput:self.titleField.text];
    if(title.length == 0){
        title = [NSString stringWithFormat:@"%@ Exercise", self.exerciseBodyZoneTag.title];
    }

    self.exerciseTitle = title;
}


#pragma mark - Tap gesture handler

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


-(void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark -Collection View Methods

-(void)fetchBodyZones{
    [ParseAPIManager fetchBodyZones:^(NSArray * _Nonnull elements, NSError * _Nonnull error) {
        if(elements == nil){
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading screen" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.bodyZones = elements;
            [self.bodyZoneCollectionView reloadData];
        }
    }];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BodyZoneCollectionViewCell *cell = [self.bodyZoneCollectionView dequeueReusableCellWithReuseIdentifier:kBodyZoneCollectionViewCellIdentifier forIndexPath:indexPath];
    BodyZone *bodyZone = self.bodyZones[indexPath.item];
    [cell setCellContent:bodyZone];
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bodyZones.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.bodyZoneCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.exerciseBodyZoneTag = self.bodyZones[indexPath.row];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.bodyZoneCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor systemBackgroundColor];
}


#pragma mark -Selecting media


- (IBAction)uploadVideo:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }
}


- (IBAction)uploadImage:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaPicker.mediaTypes = @[(NSString*)kUTTypeImage];
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString*)kUTTypeMovie] ||  [mediaType isEqualToString:(NSString*)kUTTypeAVIMovie] || [mediaType isEqualToString:(NSString*)kUTTypeVideo] || [mediaType isEqualToString:(NSString*)kUTTypeMPEG4]){
        NSURL *urlVideo = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *videoName = [urlVideo.lastPathComponent componentsSeparatedByString:@"."][1];
        NSString *videoExtension = urlVideo.pathExtension;
        NSString *videoFullName = [NSString stringWithFormat:@"%@.%@", videoName, videoExtension];;
        PFFileObject *video = [ParseAPIManager getPFFileFromURL:urlVideo videoName:videoFullName];
        self.exerciseVideo = video;
    } else {
        NSURL *urlImage = [info objectForKey:UIImagePickerControllerImageURL];
        NSString *imageName = urlImage.lastPathComponent;
        self.imagePreview.image = [info objectForKey:UIImagePickerControllerEditedImage];
        PFFileObject *image = [ParseAPIManager getPFFileFromImage:self.imagePreview.image imageName:imageName];
        self.imagePreview.file = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
