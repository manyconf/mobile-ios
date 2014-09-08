#import "CNTheme.h"
#import "DVConstants.h"
#import "CNConstants.h"



@implementation CNTheme

// Create singleton
// See also http://stackoverflow.com/questions/10066288
+ (CNTheme *)current
{
    static dispatch_once_t once;
    static CNTheme *shared;
    dispatch_once(&once, ^{ shared = [[self alloc] init]; });
    return shared;
}

- (id)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if(SINGLE_CONF_APP) {
        DLog(@"Loading singleconf theme");
        UIColor *darkgray = UIColorFromRGB(0x353534);
        UIColor *lightblue = UIColorFromRGB(0x00adf3);
        self.plainTextColor = darkgray;
        self.navbarBackgroundColor = darkgray;
        self.navbarTintedForegroundColor = lightblue;
        self.navbarForegroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.emphasizedColor = lightblue;
        self.regularFontName = [UIFont systemFontOfSize:10.0].fontName;
        self.boldFontName = [UIFont boldSystemFontOfSize:10.0].fontName;

    } else {
        DLog(@"Loading standard theme");
        self.plainTextColor = [UIColor blackColor];
        self.navbarBackgroundColor = UIColorFromRGB(0x42B5E8);
        self.navbarForegroundColor = [UIColor whiteColor];
        self.navbarTintedForegroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.emphasizedColor = UIColorFromRGB(0xff5b50);
        self.regularFontName = [UIFont systemFontOfSize:10.0].fontName;
        self.boldFontName = [UIFont boldSystemFontOfSize:10.0].fontName;
    }
    
}

+ (void)markupTableView:(UITableView *)tableView
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

+ (void)markupTableViewCell:(UITableViewCell *)cell high:(BOOL)high
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    if(high) {
        view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"tableviewcell_high_background"]];
    } else {
        view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"tableviewcell_background"]];
    }

    cell.backgroundView = view;
    cell.textLabel.font = [UIFont fontWithName:[CNTheme current].regularFontName size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:[CNTheme current].regularFontName size:12.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

@end
