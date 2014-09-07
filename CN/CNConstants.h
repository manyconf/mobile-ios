/**
 All constants that are specific for this app. Doesn't contain constants that are related to debugging and coding
 shortcuts, they're located elsewhere.
 */

#ifndef CN_CNConstants_h
#define CN_CNConstants_h
#include "TargetConditionals.h"
#include "CN_PrivateConstants.h"

// URLs

#if !(TARGET_IPHONE_SIMULATOR)
//#define HOSTNAME                            @"192.168.1.82"
#define HOSTNAME                            @"www.manyconf.com:80"
#else
#define HOSTNAME                            @"localhost:8080"
#define HOSTNAME                            @"www.manyconf.com:80"
#endif
#define BASE_URL                            @""
#define CONFERENCE_LIST_URL                 @"http://" HOSTNAME BASE_URL @"/api/1.0/conferences?api_key=" API_KEY

// Getting data

#define REFRESH_RATE                        80.0    // Get new data every 60 seconds

// Notification center

#define NOTIF_APPLICATION_DID_BECOME_ACTIVE     @"applicationDidBecomeActive"
#define NOTIF_SERVICE_HANDLER_RESULT            @"serviceHandlerResult"

// Constants for conference-specific app

#define SINGLE_CONF_APP                     NO
#define SINGLE_CONF_APP_ID                  3
#define SINGLE_CONF_APP_THEME               @"opendata"

// User interface stuff

#define OPENSANS_SEMIBOLD_FONT      @"OpenSans-Semibold"
#define OPENSANS_LIGHT_FONT         @"OpenSans-Light"
#define OPENSANS_REGULAR_FONT       @"OpenSans"
#define OPENSANS_BOLD_FONT          @"OpenSans-Bold"
#define OPENSANS_LIGHT_ITALIC_FONT  @"OpenSansLight-Italic"

#define IMAGE_PLACEHOLDER           @"image_not_loaded.png"

#endif
