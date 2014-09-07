#import "CNScheduleViewController.h"
#import "CNPresentationViewController.h"
#import "CNTrack.h"
#import "CNPresentation.h"
#import "DVConstants.h"
#import "CNSpeaker.h"
#import "CNTheme.h"



@interface CNScheduleViewController ()

@end

@implementation CNScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    DLog(@"entry");
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Schedule", "Title of the schedule screen");
    [self setTheme];
}

- (void)setTheme
{
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
    // Return the number of sections.
    return [self.conference.tracks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CNTrack *t = self.conference.tracks[section];
    NSInteger nRows = [t.presentations count];

    return nRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PresentationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [CNTheme markupTableViewCell:cell high:NO];
    
    NSInteger nTrack = indexPath.section;
    NSInteger nPresentation = indexPath.row;

    // Some sanity checking
    if(nTrack > [self.conference.tracks count]) {
        DLog(@"Track count %ld too high", (long)nTrack);
        return nil;
    }
    
    // Everything's OK, continue
    CNTrack *t = self.conference.tracks[nTrack];
    
    NSArray *presentations = t.presentations;
    if(nPresentation > [presentations count]) {
        DLog(@"Presentations count %ld too high", (long)nPresentation);
        return nil;
    }
    
    CNPresentation *p = presentations[nPresentation];
    
    cell.textLabel.text = p.title;
    cell.detailTextLabel.text = [p timeDescription];

    /*
    // See if we have speakers
    if([p.speakers count] == 0) {
        cell.detailTextLabel.text = @"";
    } else {
        // Concatenate all speakers
        cell.detailTextLabel.text = [CNSpeaker stringFromSpeakerArray:p.speakers];
        cell.detailTextLabel.text = [p timeDescription];
    }
    */
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Sanity checking
    if(section > [self.conference.tracks count]) {
        return nil;
    }
    
    NSString *sectionTitle;
    CNTrack *t = self.conference.tracks[section];
    
    sectionTitle = t.name;
    if((id)t.location != [NSNull null] && [t.location length] > 0) {
        sectionTitle = [sectionTitle stringByAppendingString:@", "];
        sectionTitle = [sectionTitle stringByAppendingString:t.location];
    }
    return sectionTitle;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForCell:sender];
    CNTrack *t = self.conference.tracks[index.section];
    CNPresentation *p = t.presentations[index.row];
    CNPresentationViewController *pvc = [segue destinationViewController];
    [pvc setPresentation:p];
    [pvc setTrack:t];
}

@end
