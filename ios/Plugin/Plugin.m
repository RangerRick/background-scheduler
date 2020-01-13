#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(BackgroundScheduler, "BackgroundScheduler",
           CAP_PLUGIN_METHOD(schedule, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(finished, CAPPluginReturnPromise);
)
