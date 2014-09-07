/**
 This is the first screen that the user sees. It's here mainly to provide a fork in the navigation; depending on
 whether we run a (client-branded) single-conference app, or our ManyConf client.
 
 Also takes care of global theming of the app.
 */

#import <UIKit/UIKit.h>
#import "CNServiceHandler.h"
#import "MBProgressHUD.h"
#import <CHOrderedDictionary.h>



@interface CNStartupViewController : UIViewController <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIView *hudContainerView;

- (IBAction)reloadButtonTapped:(id)sender;

@end
