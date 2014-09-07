/**
 When CNWebserviceManager receives the data in JSON format, we use this class its methods to convert
 the data into brand new shiny CNConference objects.
 */

#import <Foundation/Foundation.h>
#import <CHOrderedDictionary.h>



@interface CNConferenceBuilder : NSObject

+ (CHOrderedDictionary *)conferencesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
