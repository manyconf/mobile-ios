/**
 Model that represents a speaker (of a presentation).
 */

#import <Foundation/Foundation.h>



@interface CNSpeaker : NSObject

@property NSNumber *speakerID;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *biography;
@property NSString *email;
@property NSString *company;

/** Convenience functions */
- (NSString*)fullName;
+ (NSString*)stringFromSpeakerArray:(NSArray*)speakerList;

@end
