/**
 All constants that are specific for this app. Doesn't contain constants that are related to debugging and coding
 shortcuts, they're located elsewhere.
 */

#ifndef CN_CNConstants_h
#define CN_CNConstants_h
#include "TargetConditionals.h"
#include "CNPrivateConstants.h"

// URLs

#if 1
#define HOSTNAME                            @"www.manyconf.com"
#define PORT                                @"80"
#define CONTEXT_ROOT                        @""
#else
#define HOSTNAME                            @"localhost"
#define PORT                                @"8080"
#define CONTEXT_ROOT                        @"/conference"
#endif
#define CONFERENCE_LIST_URL_IOS7            @"http://" HOSTNAME @":" PORT CONTEXT_ROOT @"/api/1.0/conferences.json?api_key=" API_KEY @"&sort=startdate&order=desc"

// Getting data

#define REFRESH_RATE                        10.0    // Get new data every x seconds

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
