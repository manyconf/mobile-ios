#import "CNSpeaker.h"



@implementation CNSpeaker

- (NSString*)fullName
{
    NSString *name;
    if( ! [self.firstName isEqual:[NSNull null]]) {
        name = [NSString stringWithFormat:@"%@ ", self.firstName];
    }
    if( ! [self.lastName isEqual:[NSNull null]]) {
        name = [name stringByAppendingString:self.lastName];
    }
    return name;
}

+(NSString*)stringFromSpeakerArray:(NSArray*)speakerList
{
    NSString *speakerStr = @"";
    for(int i = 0; i < [speakerList count]; i++) {
        CNSpeaker *s = speakerList[i];
        speakerStr = [speakerStr stringByAppendingString:[s fullName]];
        if(i != [speakerList count]-1) {
            speakerStr = [speakerStr stringByAppendingString:@", "];
        }
    }
    return speakerStr;
}

@end
