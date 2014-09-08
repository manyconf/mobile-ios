#import "CNConferenceDetailsViewController.h"
#import "CNScheduleViewController.h"
#import "CNSpeakerListViewController.h"
#import "DVConstants.h"
#import "CNConstants.h"
#import "CNTheme.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CNServiceHandler.h"



@implementation CNConferenceDetailsViewController {
    BOOL addedObserver;
}

- (void)viewDidLoad
{
    DLog(@"entry");
    [super viewDidLoad];
    
    addedObserver = NO;
    
    if(self.conference == nil) {
        // We're arriving here because CNStartupViewController found that we're running as a
        // single-conference app.
        self.conference = [[CNServiceHandler shared].conferences objectForKey:[NSNumber numberWithLong:SINGLE_CONF_APP_ID]];
        DLog(@"Single-conference app showing conference %ld", [self.conference.confID longValue]);
    } else {
        // We're arriving here because CNConferenceListViewController set the appropriate conference
        // to display
        DLog(@"Displaying details of conference %ld", [self.conference.confID longValue]);
        [self loadLogo];
    }

    [self setTheme];
    [self displayData];
    
    if(DEBUG_VIEWS) {
        self.name.backgroundColor = [UIColor purpleColor];
        self.location.backgroundColor = [UIColor orangeColor];
        self.descriptionTextView.backgroundColor = [UIColor yellowColor];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(SINGLE_CONF_APP) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"entry");
    
    if(!addedObserver) {
        addedObserver = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataFromNetwork)
                                                     name:NOTIF_SERVICE_HANDLER_RESULT
                                                   object:nil];
    }
}

// Called in a background thread, when new data arrives
- (void)dataFromNetwork
{
    DLog(@"entry");
    
    CHOrderedDictionary *conferenceList;
    conferenceList = [CNServiceHandler shared].conferences;
    self.conference = [[CNServiceHandler shared].conferences objectForKey:[NSNumber numberWithLong:SINGLE_CONF_APP_ID]];
    [self performSelectorOnMainThread:@selector(displayData) withObject:nil waitUntilDone:NO];
}

// Can be called either from viewDidLoad, or when new data has arrived from the network
- (void)displayData
{
    DLog(@"entry");
    
    if([self.conference.name isEqual:[NSNull null]]) {
        self.name.text = @"";
        self.title = @"Conference details"; // This is a backup, it shouldn't actually happen
        
    } else {
        self.name.text = self.conference.name;
        self.title = self.conference.name;
    }
    
    if([self.conference.descr isEqual:[NSNull null]]) {
        self.descriptionTextView.text = @"";
    } else {
        self.descriptionTextView.text = self.conference.descr;
    }
    
    if([self.conference.location.locationID isEqual:[NSNull null]] || [[self.conference.location asString] length] == 0) {
        self.location.text = @"(Location to be determined)";
    } else {
        self.location.text = [self.conference.location asString];
    }
    
    
    if(SINGLE_CONF_APP) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateStyle:NSDateFormatterMediumStyle];
        self.simpleDateLabel.text = [fmt stringFromDate:self.conference.startdate];
    } else {
        // Separate day and month labels
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        self.dayOfMonthLabel.text = [dateFormatter stringFromDate:self.conference.startdate];
        [dateFormatter setDateFormat:@"MMM-yy"];
        NSString *monthAndYear = [dateFormatter stringFromDate:self.conference.startdate];
        self.monthAndYearLabel.text = [monthAndYear uppercaseString];
    }
    
    [self.tableView reloadData];
}

- (void)loadLogo
{
    DLog(@"entry");

    if([self.conference.logoURL isEqual:[NSNull null]] || self.conference.logoURL == nil) {
        DLog(@"Conference %ld doesn't have a logo image", [self.conference.confID longValue]);
        return;
    }

    NSString *imageURL = self.conference.logoURL;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:imageURL]
                   placeholderImage:[UIImage imageNamed:IMAGE_PLACEHOLDER]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if(error != nil) {
                                  DLog(@"Couldn't retrieve image with URL [ %@ ], description:\n%@",
                                       imageURL, [error localizedDescription]);
                              } else {
                                  DLog(@"Success retrieving image [ %@ ]", imageURL);
                              }
                          }];
}

- (void)setTheme
{
    DLog(@"entry");
    self.name.font = [UIFont fontWithName:[CNTheme current].regularFontName size:22.0];
    self.descriptionTextView.font = [UIFont fontWithName:[CNTheme current].regularFontName size:13.0];
    self.location.font = [UIFont fontWithName:[CNTheme current].regularFontName size:15.0];
    self.dayOfMonthLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:25.0];
    self.monthAndYearLabel.font = [UIFont fontWithName:[CNTheme current].boldFontName size:15.0];
    self.monthAndYearLabel.backgroundColor = [CNTheme current].emphasizedColor;
    
    [CNTheme markupTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.conference.speakers count] > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"entry");

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == 0) {
        DLog(@"Going to schedule");
        [self performSegueWithIdentifier:@"CNScheduleViewController" sender:self];
    } else if(indexPath.row == 1) {
        DLog(@"Going to speaker list");
        [self performSegueWithIdentifier:@"CNSpeakerListViewController" sender:self];
    } else {
        DLog(@"Weird indexPath received");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConferenceDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Theming
    [CNTheme markupTableViewCell:cell high:NO];
    
    if(indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Schedule", @"Button text on conference details screen that routes user to the list of presentations");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@ %d %@",
                                     self.conference.nTotalPresentations,
                                     NSLocalizedString(@"sessions in", @"Middle of sentence 'x sessions in x track(s)"),
                                     [self.conference.tracks count],
                                     NSLocalizedString(@"track(s)", @"End of sentence 'x sessions in x track(s)")
                                     ];
    } else if(indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Speaker list", @"Button text on conference details screen that routes user to the list of presentations");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",
                                     [self.conference.speakers count],
                                     NSLocalizedString(@"speakers", @"End of sentence '15 speakers'")
                                     ];
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog(@"entry %@", segue.identifier);
    
    if(SINGLE_CONF_APP) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if([@"CNScheduleViewController" isEqualToString:segue.identifier]) {
        CNScheduleViewController *scheduleVC = (CNScheduleViewController*)[segue destinationViewController];
        [scheduleVC setConference:self.conference];
    } else if([@"CNSpeakerListViewController" isEqualToString:segue.identifier]) {
        CNSpeakerListViewController *speakerVC = (CNSpeakerListViewController*)[segue destinationViewController];
        [speakerVC setConference:self.conference];
    } else {
        DLog(@"Unidentified segue %@", segue.identifier);
    }
    DLog(@"exit");
}

- (void)dealloc
{
    DLog(@"entry");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
