/**
 Shows the presentation details, such as name, speaker, description.
 */

#import <UIKit/UIKit.h>
#import "CNPresentation.h"
#import "CNTrack.h"



@interface CNPresentationViewController : UIViewController

@property CNPresentation *presentation;
@property CNTrack *track;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateAndLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateAndLocationLabelConstraint;

- (IBAction)speakerButtonTapped:(id)sender;

@end
