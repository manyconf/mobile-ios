/**
 Model that represents location of a conference.
 */

#import <Foundation/Foundation.h>



@interface CNLocation : NSObject

@property NSString *locationID;
@property NSString *name;
@property NSString *address;
@property NSString *zipCode;
@property NSString *city;
@property NSString *country;

// Return human-readable string excluding zipcode
- (NSString*)asString;

@end
