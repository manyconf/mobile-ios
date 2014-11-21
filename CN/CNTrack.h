/**
 Model that represents a track (of a conference).
 */

#import <Foundation/Foundation.h>



@interface CNTrack : NSObject

@property NSNumber *trackID;
@property NSString *name;
@property NSString *descr;
@property NSString *location;
@property NSString *type;     // workshop, presentation, etc
@property NSArray *presentations;

@end
