/**
 Model that represents a speaker (of a presentation).
 */

#import <Foundation/Foundation.h>



@interface CNSpeaker : NSObject

@property NSNumber *speakerID;
@property NSString *name;
@property NSString *biography;
@property NSString *email;
@property NSString *company;

/** Convenience functions */
+ (NSString*)stringFromSpeakerArray:(NSArray*)speakerList;

@end
