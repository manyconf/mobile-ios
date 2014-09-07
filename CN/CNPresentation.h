/**
 Model that represents a presentation.
 */

#import <Foundation/Foundation.h>



@interface CNPresentation : NSObject

@property NSNumber *presID;
@property NSString *title;
@property NSString *description;
@property NSString *type;
@property NSDate *starttime;
@property NSDate *endtime;
@property NSArray *speakers;

/** Human-readable description of the start/endtime, i.e. From xx:xx to yy:yy */
- (NSString*)timeDescription;

@end
