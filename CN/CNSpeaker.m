#import "CNSpeaker.h"



@implementation CNSpeaker

+(NSString*)stringFromSpeakerArray:(NSArray*)speakerList
{
    NSString *speakerStr = @"";
    for(int i = 0; i < [speakerList count]; i++) {
        CNSpeaker *s = speakerList[i];
        speakerStr = [speakerStr stringByAppendingString:s.name];
        if(i != [speakerList count]-1) {
            speakerStr = [speakerStr stringByAppendingString:@", "];
        }
    }
    return speakerStr;
}

@end
