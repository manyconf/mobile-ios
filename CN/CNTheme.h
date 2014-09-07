/**
 To support single-conference apps, we need some flexibility to change the look-and-feel beyond whatever
 the platform supports out-of-the-box.
 */

#import <Foundation/Foundation.h>



@interface CNTheme : NSObject

@property UIColor *plainTextColor;
@property UIColor *navbarBackgroundColor;
@property UIColor *navbarForegroundColor;
@property UIColor *navbarTintedForegroundColor;
@property UIColor *backgroundColor;
@property NSString *regularFontName;
@property NSString *boldFontName;
@property UIColor *emphasizedColor;
@property UIStatusBarStyle statusBarStyle;

+ (CNTheme *)current;
+ (void)markupTableView:(UITableView *)tableView;
+ (void)markupTableViewCell:(UITableViewCell *)cell high:(BOOL)high;

@end
