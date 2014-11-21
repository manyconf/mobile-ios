/**
 Constants that are related to debugging and coding shortcuts
 */

//#define ANALYTICS       // Comment this if you want to switch off crashlytics

#ifdef ANALYTICS
#include <Crashlytics/Crashlytics.h>

#ifdef DEBUG
#define DLog(__FORMAT__, ...) CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(__FORMAT__, ...) CLSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif // DEBUG

#else

// If we're not using crashlytics:
#ifdef DEBUG
#define DLog(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...) 
#endif // DEBUG

#endif // ANALYTICS

// Convenience macros to compare floats. See also:
// http://stackoverflow.com/questions/1614533/strange-problem-comparing-floats-in-objective-c
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

#define NOT_OVERRIDDEN_EXC      [NSException exceptionWithName:NSInternalInconsistencyException \
                                    reason:[NSString stringWithFormat:@"You must override %@ in a subclass", \
                                    NSStringFromSelector(_cmd)] userInfo:nil]

// Convenience macros to distinguish devices

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_RETINA   ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LOG_DATE_FORMAT                 @"dd/MM/yyyy HH:mm:ss"

// Macros to turn debugging options on/off

#define DEBUG_VIEWS                     0