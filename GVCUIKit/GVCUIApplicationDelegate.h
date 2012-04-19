/**
 * GVCUIApplicationDelegate
 * Date:  Thu Mar 1 20:31:21 EST 2012
 * Author: daspinall
 */

#import <UIKit/UIKit.h>

@interface GVCUIApplicationDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

- (NSString *)applicationName;
- (NSString *)applicationDocumentsPath;
- (NSURL *)applicationDocumentsURL;

- (NSArray *)applicationResourcesOfType:(NSString *)extension inDirectory:(NSString *)subfolder;
- (NSString *)applicationResourcePathForName:(NSString *)apath ofType:(NSString *)extension inDirectory:(NSString *)subfolder;

@end

