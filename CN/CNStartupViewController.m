#import "CNStartupViewController.h"
#import "CNAppDelegate.h"
#import "DVConstants.h"
#import "CNConstants.h"
#import "CNAppDelegate.h"
#import "ALToastView.h"
#import "CNConferenceDetailsViewController.h"
#import "CNConferenceListViewController.h"
#import "CNTheme.h"



@implementation CNStartupViewController {
    MBProgressHUD *hud;
    NSString *lastErrorMessage;
    BOOL navigationInProgress;
}

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
    [super viewDidLoad];
    DLog(@"entry");
    navigationInProgress = NO;
    
    [self updateLaunchImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serviceHandlerResult)
                                                 name:NOTIF_SERVICE_HANDLER_RESULT
                                               object:nil];

    // Initialization
    lastErrorMessage = nil;
    self.reloadButton.alpha = 0.f;
    self.reloadButton.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setGlobalAppearances];

}

// Theming that only needs to be set once
- (void)setGlobalAppearances
{
    // This sets the color of the back arrow in the navigation bar of the settings screens
    // On iPad, the background appearance UI only works if you set the navigation controller to have a black opaque bar
    [[UINavigationBar appearance] setTintColor:[CNTheme current].navbarForegroundColor];
    [[UINavigationBar appearance] setBarTintColor:[CNTheme current].navbarBackgroundColor];
    
    // Color of text in navbar
    NSDictionary *attr;
    attr = @{NSForegroundColorAttributeName:  [CNTheme current].navbarForegroundColor,
             NSFontAttributeName:             [UIFont fontWithName:[CNTheme current].boldFontName size:20.0],
             };
    [[UINavigationBar appearance] setTitleTextAttributes:attr];
    attr = @{NSForegroundColorAttributeName:  [CNTheme current].navbarTintedForegroundColor,
             NSFontAttributeName:             [UIFont fontWithName:[CNTheme current].regularFontName size:16.0],
             };

    // Set textcolor of back button in navbar
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Color of the chevron (back arrow) in navbar
    [[UINavigationBar appearance] setTintColor:[CNTheme current].navbarTintedForegroundColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"entry");
    [super viewDidAppear:YES];
    hud = [MBProgressHUD showHUDAddedTo:self.hudContainerView animated:YES];
    
    // To avoid the error "Unbalanced calls to begin/end appearance transitions for CNConferenceListViewController"
    [self performSelector:@selector(start) withObject:nil afterDelay:0.3];
}

- (void)start
{
    [[CNServiceHandler shared] fetchConferences];
}

- (void)hideHud
{
    DLog(@"entry");

//    [MBProgressHUD hideHUDForView:self.hudContainerView animated:YES];
    [hud hide:YES];
}

- (void)showReloadButtonWithDelay:(NSNumber*)delay
{
    DLog(@"entry delay=%f", [delay floatValue]);
    
    [UIView animateWithDuration:0.2 delay:[delay floatValue] options:0 animations:^{
        self.reloadButton.alpha = 1.0;
    } completion:^(BOOL finished){
        self.reloadButton.enabled = YES;
    }];
}

- (void)hideReloadButton
{
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.reloadButton.alpha = 0.0;
    } completion:^(BOOL finished){
        self.reloadButton.enabled = NO;
    }];
}

- (void)updateLaunchImage
{
    DLog(@"entry");
    // See also
    // http://stackoverflow.com/questions/19107543
    NSString *launchImage = @"LaunchImage";
    if(IS_IPHONE) {
        if([UIScreen mainScreen].bounds.size.height > 480.0f) {
            launchImage = @"LaunchImage-700-568h";
        } else {
            launchImage = @"LaunchImage-700";
        }
    } else {
        // iPad
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(IS_RETINA) {
            // Retina iPads
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                // portrait
                launchImage = @"LaunchImage-700-Portrait@2x~ipad.png";
            } else {
                // landscape
                launchImage = @"LaunchImage-700-Landscape@2x~ipad";
            }
            
        } else {
            // Non-retina iPads
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                // portrait
                launchImage = @"LaunchImage-700-Portrait~ipad";
            } else {
                // landscape
                launchImage = @"LaunchImage-700-Landscape~ipad";
            }
        }
    }
    UIImage *i = [UIImage imageNamed:launchImage];
    if(i == nil) {
        DLog(@"Can't find image %@", launchImage);
    }
    [self.launchImageView setImage:i];
}

// Necessary for iPad rotation
- (void)viewDidLayoutSubviews
{
    DLog(@"entry");
    [self updateLaunchImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User actions

- (IBAction)reloadButtonTapped:(id)sender
{
    DLog(@"entry");
    lastErrorMessage = nil;
    
    [[CNServiceHandler shared] fetchConferences];
    [self hideReloadButton];
}

#pragma mark - Service handler

// Service handler changed state
- (void)serviceHandlerResult
{
    @synchronized(self) {
        DLog(@"entry");
        if(navigationInProgress) {
            DLog(@"Navigation already in progress, any updates will be handled by other view controllers");
            return;
        }
        
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
        
        if([CNServiceHandler shared].error == nil) {
            if(!navigationInProgress) {
                navigationInProgress = YES;
            }
            [self performSelectorOnMainThread:@selector(continueNavigation) withObject:nil waitUntilDone:NO];
        } else {
            [self fetchingConferencesFailedWithError:[CNServiceHandler shared].error];
        }
    }
}

- (void)fetchingConferencesFailedWithError:(NSError *)error
{
    DLog(@"entry");
    DLog(@"%@",[error localizedDescription]);
    [self performSelectorOnMainThread:@selector(showErrorMessage:) withObject:[error localizedDescription] waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(showReloadButtonWithDelay:) withObject:@(2.0f) waitUntilDone:NO];
}

- (void)showErrorMessage:(NSString*)message
{
    DLog(@"entry");
    int maxLen = 40;
    NSString *shortMessage = message;
    if(message.length > maxLen) {
        shortMessage = [message substringToIndex:maxLen];
        shortMessage = [NSString stringWithFormat:@"%@...", shortMessage];
    }
    
    // Make sure we don't show the same error twice in a row
    if(lastErrorMessage != nil) {
        if(![message isEqualToString:lastErrorMessage]) {
            [ALToastView toastInView:self.navigationController.view withText:shortMessage];
        }
    }
    if(lastErrorMessage == nil) {
        [ALToastView toastInView:self.navigationController.view withText:shortMessage];
        lastErrorMessage = message;
    }
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)currentHud
{
    DLog(@"entry");
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
    hud = nil;
}

#pragma mark - Navigation

// See also:
// http://stackoverflow.com/questions/8680092/best-practice-on-showing-a-one-time-login-screen-w-storyboards
- (void)continueNavigation
{
    DLog(@"entry");
    if(SINGLE_CONF_APP) {
        DLog(@"Pushing user to single conference interface");
        [self performSegueWithIdentifier:@"CNConferenceDetailsViewController" sender:self];
    } else {
        DLog(@"Pushing user to standard interface");
        [self performSegueWithIdentifier:@"CNConferenceListViewController" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog(@"entry with identifier %@", segue.identifier);
}

- (void)dealloc
{
    DLog(@"entry");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
