#import "CNConferenceBuilder.h"
#import "CNConference.h"
#import "CNLocation.h"
#import "CNTrack.h"
#import "CNPresentation.h"
#import "CNSpeaker.h"
#import "DVConstants.h"
#import "NSData+dump.h"



@implementation CNConferenceBuilder

+ (CHOrderedDictionary *)conferencesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    DLog(@"entry");
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
//    NSMutableDictionary *conferences = [[NSMutableDictionary alloc] init];
    CHOrderedDictionary *conferences = [[CHOrderedDictionary alloc] init];
    
    if (localError != nil) {
        DLog(@"Error in JSON serialization: dumping");
        DLog(@"Dump:\n%@", [objectNotation dump]);
        *error = localError;
        return nil;
    }
    
    // take a look at all elements in the array
    for (id conferenceElement in parsedObject) {
        NSDictionary *conferenceDic = (NSDictionary*)conferenceElement;
    
        // Get conference basics
        CNConference *conference = [[CNConference alloc] init];
        conference.confID = [conferenceDic valueForKey:@"id"];
        conference.name = [conferenceDic valueForKey:@"name"];
        conference.logoURL = [conferenceDic valueForKey:@"logoUrl"];
        conference.shortURL = [conferenceDic valueForKey:@"shortUrl"];
        conference.website = [conferenceDic valueForKey:@"website"];
        conference.descr = [conferenceDic valueForKey:@"description"];
        conference.nTotalPresentations = 0;
        conference.tracks = @[];
        conference.speakers = [[NSMutableDictionary alloc] init];
        
        // Parse image links
        NSArray *teaserImages = [conferenceDic valueForKey:@"teaserImages"];
        conference.teaserImageLinks = teaserImages;
        DLog(@"Conference %d has %ld images", [conference.confID intValue], (long)[teaserImages count]);
        
        // Parse location
        NSArray *rawLocationDict = [conferenceDic valueForKey:@"location"];
        if(rawLocationDict != nil) {
            CNLocation *location = [[CNLocation alloc] init];
            location.locationID = [rawLocationDict valueForKey:@"id"];
            location.name = [rawLocationDict valueForKey:@"name"];
            location.address = [rawLocationDict valueForKey:@"address"];
            location.zipCode = [rawLocationDict valueForKey:@"zipCode"];
            location.city = [rawLocationDict valueForKey:@"city"];
            location.country = [rawLocationDict valueForKey:@"country"];
            conference.location = location;
        } else {
            conference.location = nil;
        }
        
        // Parse dates
        id startdateObj = [conferenceDic valueForKey:@"startdate"];
        if(startdateObj != [NSNull null]) {
            conference.startdate = [fmt dateFromString:startdateObj];
        }
        id enddateObj = [conferenceDic valueForKey:@"enddate"];
        if(enddateObj != [NSNull null]) {
            conference.enddate = [fmt dateFromString:enddateObj];
        }
        
        // Parse tracks
        NSArray *rawTrackArray = [conferenceDic valueForKey:@"tracks"];
        if(rawTrackArray != nil && [rawTrackArray count] > 0) {
            DLog(@"Found %ld tracks", (long)[rawTrackArray count]);
            NSMutableArray *parsedTrackArray = [[NSMutableArray alloc] init];
            
            for(id rawTrackElement in rawTrackArray) {
                NSDictionary *trackDic = (NSDictionary*)rawTrackElement;

                CNTrack *track = [[CNTrack alloc] init];
                track.trackID = [trackDic valueForKey:@"id"];
                track.name = [trackDic valueForKey:@"name"];
                track.descr = [trackDic valueForKey:@"description"];
                track.location = [trackDic valueForKey:@"location"];
                track.presentations = @[];
                
                // Parse presentations
                NSArray *rawPresentationArray = [trackDic valueForKey:@"presentations"];
                if(rawPresentationArray != nil && [rawPresentationArray count] > 0) {
                    DLog(@"Found %ld presentations", (long)[rawPresentationArray count]);
                    NSMutableArray *parsedPresentationArray = [[NSMutableArray alloc] init];
                    
                    for(id rawPresentationElement in rawPresentationArray) {
                        NSDictionary *presentationDic = (NSDictionary*)rawPresentationElement;
                        
                        CNPresentation *presentation = [[CNPresentation alloc] init];
                        presentation.presID = [presentationDic valueForKey:@"id"];
                        presentation.title = [presentationDic valueForKey:@"title"];
                        presentation.descr = [presentationDic valueForKey:@"description"];
                        presentation.type = [presentationDic valueForKey:@"type"];
                        presentation.speakers = @[];
                        
                        id starttimeObj = [presentationDic valueForKey:@"startTime"];
                        if(starttimeObj !=[NSNull null]) {
                            presentation.starttime = [fmt dateFromString:starttimeObj];
                        }
                        id endtimeObj = [presentationDic valueForKey:@"endTime"];
                        if(endtimeObj != [NSNull null]) {
                            presentation.endtime = [fmt dateFromString:endtimeObj];
                        }
                        
                        // Parse speakers
                        NSArray *rawSpeakerArray = [presentationDic valueForKey:@"speakers"];
                        if(rawSpeakerArray != nil && [rawSpeakerArray count] > 0) {
                            DLog(@"Found %ld speakers", (long)[rawSpeakerArray count]);
                            NSMutableArray *parsedSpeakerArray = [[NSMutableArray alloc] init];
                            
                            for(id rawSpeakerElement in rawSpeakerArray) {
                                NSDictionary *speakerDic = (NSDictionary*)rawSpeakerElement;
                                
                                CNSpeaker *speaker = [[CNSpeaker alloc] init];
                                speaker.speakerID = [speakerDic valueForKey:@"id"];
                                speaker.name = [speakerDic valueForKey:@"name"];
                                speaker.biography = [speakerDic valueForKey:@"biography"];
                                speaker.company = [speakerDic valueForKey:@"company"];
                                
                                [parsedSpeakerArray addObject:speaker];
                                [conference.speakers setObject:speaker forKey:speaker.speakerID];
                            }
                            presentation.speakers = parsedSpeakerArray;
                        }

                        
                        [parsedPresentationArray addObject:presentation];
                        [parsedPresentationArray sortUsingComparator:^(CNPresentation *p1, CNPresentation *p2) {
                            NSDate *date1 = p1.starttime;
                            NSDate *date2 = p2.starttime;
                            return [date1 compare:date2];
                        }];
                            conference.nTotalPresentations++;
                    }
                    // TODO sort presentations on start time
                    track.presentations = parsedPresentationArray;
                }
                [parsedTrackArray addObject:track];
            }
            conference.tracks = parsedTrackArray;
        }
        
        /*
        for (NSString *key in conferenceDic) {
            if ([conference respondsToSelector:NSSelectorFromString(key)]) {
                [conference setValue:[conferenceDic valueForKey:key] forKey:key];
            }
        }
         */
        [conferences setObject:conference forKey:conference.confID];
    }
    
    return conferences;
}
@end