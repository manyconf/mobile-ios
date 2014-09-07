#import "CNSpeakerViewController.h"
#import "DVConstants.h"
#import "CNTheme.h"



@implementation CNSpeakerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameLabel.text = [self.speaker fullName];

    if([self.speaker.company isEqual:[NSNull null]]) {
        self.companyLabel.text = @"";
    } else {
        self.companyLabel.text = self.speaker.company;
    }

    if([self.speaker.biography isEqual:[NSNull null]]) {
        self.bioTextView.text = NSLocalizedString(@"No biography for this speaker",
                                                  @"Placeholder text for speaker screen");
    } else {
        self.bioTextView.text = self.speaker.biography;
    }
    
    if([self.speaker.email isEqual:[NSNull null]]) {
        self.emailLabel.text = @"";
    } else {
        self.emailLabel.text = self.speaker.email;
    }
    [self setTheme];
}

- (void)setTheme
{
    self.nameLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:30.0];
    self.companyLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:17.0];
    self.bioTextView.font = [UIFont fontWithName:[CNTheme current].regularFontName size:15.0];
    self.emailLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:17.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
