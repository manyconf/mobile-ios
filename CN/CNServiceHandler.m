#import "CNServiceHandler.h"
#import "CNConferenceBuilder.h"
#import "DVConstants.h"
#import "CNConstants.h"



@implementation CNServiceHandler

// Create singleton
// See also http://stackoverflow.com/questions/10066288
+ (CNServiceHandler *)shared
{
    static dispatch_once_t once;
    static CNServiceHandler *shared;
    dispatch_once(&once, ^{ shared = [[self alloc] init]; });
    return shared;
}

- (void)fetchConferences
{
    DLog(@"entry");
    [self fetchConferencesAtCoordinate:kCLLocationCoordinate2DInvalid];
}

- (void)fetchConferencesAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    DLog(@"entry");
    
    [self dataFromCache];
    [self startRepeatingTimer];
}

// See also:
// http://stackoverflow.com/questions/1449035/how-do-i-use-nstimer
- (void)startRepeatingTimer
{
    DLog(@"entry");
    NSDate *now = [NSDate date];
    NSTimer *t = [[NSTimer alloc] initWithFireDate:now
                                          interval:REFRESH_RATE
                                            target:self
                                          selector:@selector(dataFromNetwork)
                                          userInfo:nil repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:t forMode:NSDefaultRunLoopMode];
}

- (void)dataFromCache
{
    DLog(@"entry");
    // If there's a cache, go get it
    if([self cacheExists]) {
        NSData *cachedData = [self readFromCache];
        [self receivedConferenceJSON:cachedData];
    }
}

- (void)dataFromNetwork
{
    // As soon as we're on iOS 8, use the following code
    /*
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = @"http";
    components.host = HOSTNAME;
    components.path = CONFERENCE_LIST_URL;
    
    NSArray *params = @[
                        [[NSURLQueryItem alloc] initWithName:@"api_key" value:API_KEY],
                        [[NSURLQueryItem alloc] initWithName:@"sort" value:@"startdate"],  // or @"dateCreated"
                        [[NSURLQueryItem alloc] initWithName:@"order" value:@"asc"],   // or @"desc"
                        [[NSURLQueryItem alloc] initWithName:@"max" value:@"25"],
                        [[NSURLQueryItem alloc] initWithName:@"offset" value:@"0"],
                        ];
    
    components.queryItems = params;
    NSURL *url = [components URL];
     */
    NSURL *url = [[NSURL alloc] initWithString:CONFERENCE_LIST_URL_IOS7];
    
    DLog(@"Sending request to URL [%@]", [url absoluteString]);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Groovy screws up the JSON if we pass this
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.error = nil;
    
    // Continue getting fresh data
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            DLog(@"Error getting data from URL: %@", error);
            self.error = error;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SERVICE_HANDLER_RESULT object:nil];
        } else {
            DLog(@"Success getting data from URL, starting parsing");
            [self receivedConferenceJSON:data];
            [self dumpToCache:data];
        }
    }];
}

- (void)dumpToCache:(NSData *)data
{
    DLog(@"entry");
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    
    [data writeToFile:path atomically:YES];
    
    NSError *err;
    BOOL retval = NO;
    
    // Remove old cache file
    if([self cacheExists]) {
        DLog(@"Removing old cache file");
        retval = [[NSFileManager defaultManager] removeItemAtPath:[self cacheFileName] error:&err];
        if(retval != YES) {
            DLog(@"Unable to delete file [%@], error: %@", [self cacheFileName], [err localizedDescription]);
            return;
        }
    }
    
    // Move new cache into place
    retval = [[NSFileManager defaultManager] moveItemAtPath:path toPath:[self cacheFileName] error:&err];
    if(retval != YES) {
        DLog(@"Unable to move file: %@", [err localizedDescription]);
        DLog(@"Source: %@", path);
        DLog(@"Destination: %@", [self cacheFileName]);
    } else {
        DLog(@"Moved cachefile from %@ to %@", path, [self cacheFileName]);
    }
}

- (float)cacheAge
{
    NSDictionary* attributesDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[self cacheFileName] error:NULL];
    NSDate* date = [attributesDictionary objectForKey: NSFileCreationDate];
    
    float ageInSeconds = fabs([date timeIntervalSinceNow]);
    DLog(@"cache age: %f", ageInSeconds);
    return ageInSeconds;
}

- (BOOL)cacheExists
{
    DLog(@"entry");
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self cacheFileName]] == NO)
    {
        DLog(@"Cache file doesn't exist");
        return NO;
    } else {
        // http://stackoverflow.com/questions/7363125
        NSDictionary* attributesDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[self cacheFileName] error:NULL];
        NSDate* date = [attributesDictionary objectForKey: NSFileCreationDate];
        NSInteger size = [[attributesDictionary objectForKey:NSFileSize] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:LOG_DATE_FORMAT];
        NSString* dateStr = [dateFormatter stringFromDate:date];
        
        DLog(@"Cache file (size %ld bytes) created %@ (%f seconds ago)", (long)size, dateStr,
             fabs([date timeIntervalSinceNow]));
        
        return YES;
    }
}

- (NSData*)readFromCache
{
    DLog(@"entry");
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self cacheFileName]];
    return data;
}

- (NSString*)cacheFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], CACHE_FILENAME];
    return filePath;
}

#pragma mark - MeetupCommunicatorDelegate

- (void)receivedConferenceJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    CHOrderedDictionary *conferences = [CNConferenceBuilder conferencesFromJSON:objectNotation error:&error];
    
    self.error = error;
    self.conferences = conferences;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SERVICE_HANDLER_RESULT object:nil];
}

@end
