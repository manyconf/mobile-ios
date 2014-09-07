#import "CNPresentation.h"
#import "DVConstants.h"



@implementation CNPresentation {
    NSDateFormatter *fmt;
}

- (id)init
{
    if (self = [super init]) {
        fmt = [[NSDateFormatter alloc] init];
        [fmt setDateStyle:NSDateFormatterNoStyle];
        [fmt setTimeStyle:NSDateFormatterShortStyle];
    }
    return self;
}


- (NSString*)timeDescription
{
    NSString *descr = @"";
    
    if(self.starttime != nil && self.endtime == nil) {
        descr = [NSString stringWithFormat:@"%@ %@",
                 NSLocalizedString(@"Starts at", @"Prefix for presentation start time"),
                 [fmt stringFromDate:self.starttime]];
    } else if(self.starttime == nil && self.endtime != nil) {
        descr = [NSString stringWithFormat:@"%@ %@",
                 NSLocalizedString(@"Ends at", @"Prefix for presentation end time"),
                 [fmt stringFromDate:self.endtime]];
    } else if(self.starttime != nil && self.endtime != nil) {
        descr = [NSString stringWithFormat:@"%@ %@ %@ %@",
                 NSLocalizedString(@"From", @"Prefix for presentation time, as in 'From xx:xx to xx:xx'"),
                 [fmt stringFromDate:self.starttime],
                 NSLocalizedString(@"to", @"Suffix for presentation time, as in 'From xx:xx to xx:xx'"),
                 [fmt stringFromDate:self.endtime]];
    } else {
        DLog("No start/endtime for presentation %@", self.title);
    }
    
    return descr;
}

@end
