#import "AWAppDelegate.h"
#import "AWViewController.h"

@implementation AWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	AWViewController *controller = [[AWViewController alloc] init];
	self.window.rootViewController = controller;
	[self.window makeKeyAndVisible];
    return YES;
}

@end
