/**
 Model that represents a conference.
 */

#import <Foundation/Foundation.h>
#import "CNLocation.h"



@interface CNConference : NSObject

@property NSNumber *confID;
@property NSString *name;
@property NSString *logoURL;
@property NSString *shortURL;
@property NSString *website;
@property NSString *descr;
@property NSDate *startdate;
@property NSDate *enddate;
@property CNLocation *location;
@property NSArray *tracks;
@property NSArray *teaserImageLinks;
@property NSMutableDictionary *speakers;        /** shortcut property, a collection of all speakers across all tracks */
@property int nTotalPresentations;  /** pre-calculated: total number of presentations across all tracks */
@property NSString *shortUrl;

@end
