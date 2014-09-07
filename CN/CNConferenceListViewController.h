/**
 Shows list of conferences. Uses the CNWebserviceManager to dispatch a request (for a list of conferences), and
 implements methods that get called by the CNWebserviceManager when the results come in.
 */

#import <UIKit/UIKit.h>
#import <CHOrderedDictionary.h>



@interface CNConferenceListViewController : UITableViewController

@property CHOrderedDictionary *conferenceList;

@end
