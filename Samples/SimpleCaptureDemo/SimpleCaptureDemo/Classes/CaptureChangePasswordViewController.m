/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2013, Janrain, Inc.

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

#import "CaptureChangePasswordViewController.h"
#import "JRCapture.h"
#import "AppDelegate.h"
#import "JRCaptureUser+Extras.h"
#import "Utils.h"
#import "UIAlertController+JRAlertController.h"

@interface CaptureChangePasswordViewController () <UITextFieldDelegate, UITextViewDelegate, JRCaptureDelegate>
@end

@implementation CaptureChangePasswordViewController {

    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *oldPasswordField;
    __weak IBOutlet UITextField *newPasswordField;
    __weak IBOutlet UITextField *confirmPasswordField;
    __weak IBOutlet UIButton *updateButton;

    UIView * activeField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(320, updateButton.frame.origin.y + (updateButton.frame.size.height));

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    oldPasswordField.delegate = self;
    newPasswordField.delegate = self;
    confirmPasswordField.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

- (IBAction)updateProfileButtonPressed:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    JRCaptureUser *user = delegate.captureUser;
    
    NSMutableDictionary *fieldData = [[ NSMutableDictionary alloc] init];
    [fieldData setObject:oldPasswordField.text forKey:@"currentPassword"];
    [fieldData setObject:newPasswordField.text forKey:@"newPassword"];
    [fieldData setObject:confirmPasswordField.text forKey:@"newPasswordConfirm"];
    
    updateButton.enabled = NO;
    NSString *errorMessage = [self validateFormFields];
    if(errorMessage.length > 0)
    {
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /**
             * Posts the provided form data to the provided endpoint with the provided form name.
             * NOTE: This method does not validate the provided data contents - errors will be returned
             * from the server-side api and must be handled by the integration developer.
             */
            [JRCapture postFormWithFormDataProvided:user
                                  toCaptureEndpoint:@"/oauth/update_profile_native"
                                       withFormName:@"changePasswordForm"
                                       andFieldData:fieldData
                                           delegate:self];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            updateButton.enabled = YES;
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Validation Error" message:errorMessage alertActions:cancelAction, continueAction, nil];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        /**
         * Posts the provided form data to the provided endpoint with the provided form name.
         * NOTE: This method does not validate the provided data contents - errors will be returned
         * from the server-side api and must be handled by the integration developer.
         */
        [JRCapture postFormWithFormDataProvided:user
                              toCaptureEndpoint:@"/oauth/update_profile_native"
                                   withFormName:@"changePasswordForm"
                                   andFieldData:fieldData
                                       delegate:self];
    }

}

//Simple form validation for demo purposes.
- (NSString *)validateFormFields
{
    NSMutableString *errorMessage = [[NSMutableString alloc] init];
    if(oldPasswordField.text.length == 0){
        [errorMessage appendString:@"Old Password is empty.\n"];
    }
    if(newPasswordField.text.length == 0){
        [errorMessage appendString:@"New Password is empty.\n"];
    }
    if(confirmPasswordField.text.length == 0){
        [errorMessage appendString:@"Confirm Password is empty.\n"];
    }
    if(![confirmPasswordField.text isEqualToString:newPasswordField.text]){
        [errorMessage appendString:@"New Passwords do not match.\n"];
    }
    return errorMessage;
    
}

- (void)updateUserProfileDidFailWithError:(NSError *)error
{
    [Utils handleFailureWithTitle:@"Password not updated" message:error.localizedFailureReason forVC:self];
    updateButton.enabled = YES;
}

- (void)updateUserProfileDidSucceed
{
    [Utils handleSuccessWithTitle:@"Password Updated" message:nil forVc:self];
    updateButton.enabled = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == activeField) activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == activeField) {
        activeField = nil;
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == activeField) activeField = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"] && textView == activeField) {
        activeField = nil;
        [textView resignFirstResponder];
    }

    return YES;
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;

    CGRect frame = self.view.frame;
    frame.size.height -= keyboardSize.height;
    CGPoint origin = activeField.frame.origin;
    CGPoint bottom = CGPointMake(origin.x, origin.y + activeField.frame.size.height);
    if (!CGRectContainsPoint(frame, origin) || !CGRectContainsPoint(frame, bottom )) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end
