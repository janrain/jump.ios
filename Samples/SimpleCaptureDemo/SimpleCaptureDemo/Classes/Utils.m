/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2016, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */



#import "AppDelegate.h"
#import "UIAlertController+JRAlertController.h"
#import "Utils.h"

Class getPluralClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@Element", upcaseFirst(key)];
    return NSClassFromString(className);
}

Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@", upcaseFirst(key)];
    return NSClassFromString(className);
}

NSString *upcaseFirst(NSString *string)
{
    if (!string) return nil;
    if (![string length]) return string;
    return [string stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:[[string substringToIndex:1] capitalizedString]];
}

@implementation Utils
+ (void)handleSuccessWithTitle:(NSString *)title message:(NSString *)message forVc:(UIViewController *)forVc
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [forVc.navigationController popViewControllerAnimated:YES];
    }];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message alertActions:okAction, nil];
    [forVc presentViewController:alertController animated:YES completion:nil];

    [appDelegate saveCaptureUser];
}

+ (void)handleFailureWithTitle:(NSString *)title message:(NSString *)message forVC:(UIViewController *)forVC
{
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message alertActions:dismissAction, nil];

    [forVC presentViewController:alertController animated:YES completion:nil];
}
@end
