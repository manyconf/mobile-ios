#import "CNPresentationViewController.h"
#import "CNSpeaker.h"
#import "DVConstants.h"
#import "CNTheme.h"
#import "CNSpeakerViewController.h"



@interface CNPresentationViewController ()

@end

@implementation CNPresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    DLog(@"entry");
    [super viewDidLoad];
    
    NSDateFormatter *timeFmt = [[NSDateFormatter alloc] init];
    [timeFmt setTimeStyle:NSDateFormatterShortStyle];
    
    self.title = self.presentation.title;

    self.titleLabel.text = self.presentation.title;
    if([self.presentation.speakers count]) {
        NSString *speakerStr = [CNSpeaker stringFromSpeakerArray:self.presentation.speakers];
        [self.speakerButton setTitle:speakerStr forState:UIControlStateNormal];
    }
    
    if([self.presentation.descr isEqual:[NSNull null]]) {
        self.descriptionTextView.text = @"";
    } else {
        self.descriptionTextView.text = self.presentation.descr;
    }
    
    // Intelligently fill in the date and location field
    NSString *tmp = @"";
    if(self.presentation.starttime != nil) {
        tmp = [tmp stringByAppendingString:NSLocalizedString(@"From", "Start of the sentence 'from xx:xx to xx:xx'")];
        tmp = [tmp stringByAppendingString:@" "];
        tmp = [tmp stringByAppendingString:[timeFmt stringFromDate:self.presentation.starttime]];
        if(self.presentation.endtime != nil) {
            tmp = [tmp stringByAppendingString:@" "];
            tmp = [tmp stringByAppendingString:NSLocalizedString(@"to", "Middle of the sentence 'from xx:xx to xx:xx'")];
            tmp = [tmp stringByAppendingString:@" "];
            tmp = [tmp stringByAppendingString:[timeFmt stringFromDate:self.presentation.endtime]];
        }
    }
    if([self.track.location isEqual:[NSNull null]]) {
        DLog(@"No location for presentation %ld", [self.presentation.presID longValue]);
    } else {
        tmp = [NSString stringWithFormat:@"%@ @ %@", tmp, self.track.location];
    }
    
    DLog(@"dateAndLocation: %@", tmp);
    self.dateAndLocationLabel.text = tmp;
    [self setTheme];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![self.presentation.speakers count]) {
        self.dateAndLocationLabelConstraint.constant -= self.speakerButton.frame.size.height;
        self.speakerButton.hidden = YES;
    }

}

- (void)setTheme
{
    self.titleLabel.font = [UIFont fontWithName:[CNTheme current].regularFontName size:30.0];
//    self.descriptionLabel.font = [UIFont fontWithName:[CNTheme current].regularFontName size:13.0];
    self.descriptionTextView.font = [UIFont fontWithName:[CNTheme current].regularFontName size:13.0];
    self.dateAndLocationLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:15.0];
    self.speakerButton.titleLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:15.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speakerButtonTapped:(id)sender
{
    DLog(@"entry");
}


#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    DLog(@"entry %@", identifier);
    
    if(self.presentation.speakers == nil || [self.presentation.speakers count] == 0) {
        DLog(@"Cancelling segue");
        return NO;
    } else {
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog(@"entry %@", segue.identifier);
    
    CNSpeaker *s = self.presentation.speakers[0];

    CNSpeakerViewController *svc = [segue destinationViewController];
    svc.speaker = s;
}

@end
