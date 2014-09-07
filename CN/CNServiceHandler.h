/**
 Kicked off upon application startup as a singleton.
 
 Retrieves JSON from webservice and calls CNConferenceBuilder to do the parsing, or sets an error. Then uses an
 NSNotification to alert anybody interested.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CHOrderedDictionary.h>

#define CACHE_FILENAME          @"cache.json"


@interface CNServiceHandler : NSObject

@property NSError *error;
@property CHOrderedDictionary *conferences;

/** Create or return a singleton instance */
+ (CNServiceHandler*)shared;

/** View controllers call this to get all conferences. */
- (void)fetchConferences;

/** View controllers call this to get a bunch of conferences at the current coordinate. */
- (void)fetchConferencesAtCoordinate:(CLLocationCoordinate2D)coordinate;

@end

