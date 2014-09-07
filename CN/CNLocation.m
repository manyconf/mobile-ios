#import "CNLocation.h"



@implementation CNLocation

- (NSString*)asString
{
    NSString *retval = @"";
    
    if(![self.name isEqual:[NSNull null]]) {
        retval = [retval stringByAppendingString:self.name];
        retval = [retval stringByAppendingString:@", "];
    }
    if(![self.address isEqual:[NSNull null]]) {
        retval = [retval stringByAppendingString:self.address];
        retval = [retval stringByAppendingString:@", "];
    }
    if(![self.city isEqual:[NSNull null]]) {
        retval = [retval stringByAppendingString:self.city];
        retval = [retval stringByAppendingString:@", "];
    }
    if(![self.country isEqual:[NSNull null]]) {
        retval = [retval stringByAppendingString:self.country];
        retval = [retval stringByAppendingString:@", "];
    }
    
    if([retval length] == 0) {
        // Location hasn't been filled in
    } else {
        // Strip the last comma and space
        retval = [retval substringToIndex:[retval length]-2];
    }
    
    return retval;
}

@end
