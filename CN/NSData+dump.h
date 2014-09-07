/**
 Use this Objective-C category on NSData to print a nice hex dump of incoming binary data. Useful when you get an
 opaque error from the JSON parser CNConferenceBuilder.
 */

#import <Foundation/Foundation.h>



@interface NSData (dump)

- (NSString *)dump;

@end
