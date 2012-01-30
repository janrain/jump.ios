
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRPhotos.h"
#import "JRPrimaryAddress.h"
#import "JRProfiles.h"
#import "JRStatuses.h"

@interface JRCaptureUser : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) NSDate *birthday;  
@property (nonatomic, copy) NSString *currentLocation;  
@property (nonatomic, copy) NSString *display;  
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *email;  
@property (nonatomic, copy) NSDate *emailVerified;  
@property (nonatomic, copy) NSString *familyName;  
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *givenName;  
@property (nonatomic, copy) NSDate *lastLogin;  
@property (nonatomic, copy) NSString *middleName;  
@property (nonatomic, copy) NSString *password;  
@property (nonatomic, copy) NSArray *photos; /* This is an array of JRPhotos */ 
@property (nonatomic, copy) JRPrimaryAddress *primaryAddress;  
@property (nonatomic, copy) NSArray *profiles; /* This is an array of JRProfiles */ 
@property (nonatomic, copy) NSArray *statuses; /* This is an array of JRStatuses */ 
- (id)init;
+ (id)captureUser;
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
@end