#import "CNSpeakerListViewController.h"
#import "CNSpeakerViewController.h"
#import "CNSpeaker.h"
#import "DVConstants.h"
#import "CNTheme.h"



@implementation CNSpeakerListViewController

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
    
    self.title = NSLocalizedString(@"Speakers", "Title of the speaker list screen");
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conference.speakers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"entry");
    static NSString *CellIdentifier = @"SpeakerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [CNTheme markupTableViewCell:cell high:NO];
    
    CNSpeaker *s = self.conference.speakers.allValues[indexPath.row];
    
    cell.textLabel.text = [s fullName];
    
    if([s.company isEqual:[NSNull null]]) {
        cell.detailTextLabel.text = @"";
    } else {
        cell.detailTextLabel.text = s.company;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog(@"entry");

    NSIndexPath *index = [self.tableView indexPathForCell:sender];

    CNSpeaker *s = self.conference.speakers.allValues[index.row];
    CNSpeakerViewController *svc = [segue destinationViewController];
    [svc setSpeaker:s];
}

@end
