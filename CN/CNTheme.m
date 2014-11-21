#import "CNTheme.h"
#import "DVConstants.h"
#import "CNConstants.h"
#import "NSData+dump.h"



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
    DLog(@"entry");
    
    NSData *json = [CNTheme themeAsJSONData];
    NSDictionary *theme = [CNTheme themeFromJSONData:json];
    
    self.plainTextColor = [CNTheme colorFromHexString:theme[@"plainTextColor"]];
    self.navbarBackgroundColor = [CNTheme colorFromHexString:theme[@"navbarBackgroundColor"]];
    self.navbarForegroundColor = [CNTheme colorFromHexString:theme[@"navbarForegroundColor"]];
    self.navbarTintedForegroundColor = [CNTheme colorFromHexString:theme[@"navbarTintedForegroundColor"]];
    self.backgroundColor = [CNTheme colorFromHexString:theme[@"backgroundColor"]];
    if([@"default" isEqualToString:theme[@"statusBarStyle"]]) {
        self.statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    self.emphasizedColor = [CNTheme colorFromHexString:theme[@"emphasizedColor"]];
    
    if([theme[@"regularFontName"] length] == 0) {
        self.regularFontName = [UIFont systemFontOfSize:10.0].fontName;
    } else {
        [NSException raise:@"IllegalFontName" format:@"Font something other than system font not supported"];
    }
    if([theme[@"boldFontName"] length] == 0) {
        self.boldFontName = [UIFont boldSystemFontOfSize:10.0].fontName;
    } else {
        [NSException raise:@"IllegalFontName" format:@"Font something other than system font not supported"];
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

#pragma mark - Theme JSON parsing

+ (NSData*)themeAsJSONData
{
    DLog(@"entry");

    NSData *json = nil;
    NSString *bundle = [[NSBundle mainBundle]pathForResource:@"CNTheme" ofType:@"json"];
    NSError *error = nil;
    if(bundle != nil && [[NSFileManager defaultManager] fileExistsAtPath:bundle]) {
        json = [NSData dataWithContentsOfFile:bundle options:0 error:&error];
    } else {
        [NSException raise:@"ErrorReadingThemeFile" format:@"Underlying error: %@", [error localizedDescription]];
    }
    return json;
}

+ (NSString*)themeAsJSONString
{
    DLog(@"entry");

    NSString *json = @"";
    NSString *bundle = [[NSBundle mainBundle]pathForResource:@"CNTheme" ofType:@"json"];
    if(bundle != nil && [[NSFileManager defaultManager] fileExistsAtPath:bundle]) {
        NSError *error = nil;
        json = [NSString stringWithContentsOfFile:bundle encoding:NSUTF8StringEncoding error:&error];
        
    } else {
        [NSException raise:@"FileNotFound" format:@"JSON file with theme information was not found"];
    }
    return json;
}

+ (NSDictionary*)themeFromJSONData:(NSData*)json
{
    DLog(@"entry");

    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSError *localError = nil;
    dic = [NSJSONSerialization JSONObjectWithData:json options:0 error:&localError];
    
    if (localError != nil) {
        DLog(@"Error in JSON serialization: dumping");
        DLog(@"Dump:\n%@", [json dump]);
    }
    return dic;
}

+ (UIColor*)colorFromHexString:(NSString*)hexcolor
{
    DLog(@"Color string = %@", hexcolor);
    unsigned int colorNumber;
    NSScanner* scanner = [NSScanner scannerWithString:hexcolor];
    [scanner scanHexInt:&colorNumber];
    DLog(@"Color = 0x%06X", colorNumber);
    UIColor *color = UIColorFromRGB(colorNumber);
    return color;
}

@end
