/**
 Shows a speaker's detail. It's a super simple screen.
 */

#import <UIKit/UIKit.h>
#import "CNSpeaker.h"



@interface CNSpeakerViewController : UIViewController

@property CNSpeaker *speaker;
@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *companyLabel;
@property IBOutlet UILabel *emailLabel;
@property IBOutlet UITextView *bioTextView;

@end
