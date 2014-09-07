#import "CNConferenceListViewController.h"
#import "CNConferenceDetailsViewController.h"
#import "CNConference.h"
#import "CNConstants.h"
#import "DVConstants.h"
#import "CNTheme.h"
#import "CNServiceHandler.h"



@implementation CNConferenceListViewController {
    NSDateFormatter *dateFmt;
    BOOL addedObserver;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DLog(@"entry");

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    DLog(@"entry");
    [super viewDidLoad];

    addedObserver = NO;
    
    // We can assume the conference list has been loaded at this point
    self.conferenceList = [CNServiceHandler shared].conferences;

    // Initialize some objects
    dateFmt = [[NSDateFormatter alloc] init];
    [dateFmt setDateStyle:NSDateFormatterMediumStyle];
    
    self.title = @"List of conferences";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    [self setTheme];
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

- (void)setTheme
{
    [CNTheme markupTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataFromNetwork
{
    DLog(@"entry");
    
    self.conferenceList = [CNServiceHandler shared].conferences;
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
}

// Call this on the main thread
- (void)reload
{
    DLog(@"entry");
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog(@"entry");
    
    NSIndexPath *index = [self.tableView indexPathForCell:sender];
    CNConference *c = [self.conferenceList objectForKeyAtIndex:index.row];
    CNConferenceDetailsViewController *dvc = [segue destinationViewController];
    [dvc setConference:c];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conferenceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ConferenceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // Theming
    [CNTheme markupTableViewCell:cell high:YES];

    CNConference *c = [self.conferenceList objectForKeyAtIndex:indexPath.row];
    cell.textLabel.text = c.name;
    cell.detailTextLabel.text = [dateFmt stringFromDate:c.startdate];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)dealloc
{
    DLog(@"entry");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
