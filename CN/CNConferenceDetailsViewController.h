/**
 Shows details of one conference. Gets the conference from the CNConferenceListViewController. Details include
 name, description, date, and a button to go to the next screen (containing a list of presentations).
 */

#import <UIKit/UIKit.h>
#import "CNConference.h"



@interface CNConferenceDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property CNConference *conference;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UILabel *startEndDate;
@property (weak, nonatomic) IBOutlet UILabel *dayOfMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpleDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAndYearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;

@end
