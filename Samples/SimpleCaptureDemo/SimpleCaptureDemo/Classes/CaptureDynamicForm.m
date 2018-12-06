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


#import "CaptureDynamicForm.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "JRCaptureError.h"
#import "JRCaptureUser+Extras.h"
#import "debug_log.h"
#import "JRPickerView.h"
#import "JRStandardFlowKeys.h"

static NSMutableDictionary *identifierMap = nil;

@interface CaptureDynamicForm () <UITextFieldDelegate ,JRCaptureDelegate, JRPickerViewDelegate>

@property(strong, nonatomic) JRCaptureUser *captureUser;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCityTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressPostalCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressStateTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCountryTextField;

@property (weak, nonatomic) IBOutlet UISwitch *optInRegistrationSwitch;

@property (weak, nonatomic) IBOutlet UILabel *optInRegistrationLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *registerButton;

@end

@implementation CaptureDynamicForm
{
    UIView *activeField;

    UIDatePicker *birthdatePicker;

    JRPickerView *genderPicker;
    JRPickerView *addressStatePicker;
    JRPickerView *addressCountryPicker;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.contentSize = CGSizeMake(320, self.optInRegistrationSwitch.frame.origin.y + (self.optInRegistrationSwitch.frame.size.height) + 48);

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    self.captureUser = [JRCaptureUser captureUser];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    self.firstNameTextField.delegate         = self;
    self.middleNameTextField.delegate        = self;
    self.lastNameTextField.delegate          = self;
    self.emailTextField.delegate             = self;
    self.displayNameTextField.delegate       = self;
    self.passwordTextField.delegate          = self;
    self.confirmPasswordTextField.delegate   = self;
    self.mobileTextField.delegate            = self;
    self.phoneTextField.delegate             = self;
    self.address1TextField.delegate          = self;
    self.address2TextField.delegate          = self;
    self.addressCityTextField.delegate       = self;
    self.addressPostalCodeTextField.delegate = self;

    [self setupBirthdateFieldInputView];

    [birthdatePicker setDate:[NSDate date] animated:YES];
    self.birthdateTextField.text = [self stringfromDate:birthdatePicker.date];

    genderPicker         = [self jrPickerViewForTextField:self.genderTextField andFlowField:@"gender"];
    addressStatePicker   = [self jrPickerViewForTextField:self.addressStateTextField andFlowField:@"addressState"];
    addressCountryPicker = [self jrPickerViewForTextField:self.addressCountryTextField andFlowField:@"addressCountry"];

    self.optInRegistrationLabel.text = [self textForOptInLabel];
}

#pragma mark - Helper methods
-(UIView *)setupInputAccessoryView {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPicker)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexibleSpace, doneButton];

    return toolbar;
}

-(void)setupBirthdateFieldInputView
{
    self.birthdateTextField.inputAccessoryView = [self setupInputAccessoryView];

    birthdatePicker = [[UIDatePicker alloc] init];
    birthdatePicker.datePickerMode = UIDatePickerModeDate;
    birthdatePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [birthdatePicker addTarget:self action:@selector(birthdayPickerChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthdateTextField.inputView = birthdatePicker;
}

-(NSString *)stringfromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM/dd/yyyy"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [dateFormatter stringFromDate:date];
}

-(JRPickerView *)jrPickerViewForTextField:(UITextField *)textField andFlowField:(NSString *)field {
    JRPickerView *jrPickerView = [[JRPickerView alloc] initWithField:field];
    jrPickerView.jrPickerViewDelegate = self;
    textField.inputAccessoryView = [self setupInputAccessoryView];
    textField.inputView = jrPickerView;
    return jrPickerView;
}

-(NSString *)textForOptInLabel {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *archivedCaptureUser = [delegate.prefs objectForKey:kJRCaptureFlowKey];
    if (archivedCaptureUser) {
        NSDictionary *captureFlow = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        NSDictionary *fields = captureFlow[kFieldsKey];
        NSDictionary *optIn = fields[@"optInRegistration"];

        return optIn[kLabelKey];
    }
    return @"";
}

#pragma mark - Action
- (IBAction)registerButtonPressed:(id)sender
{
    self.captureUser.givenName               = self.firstNameTextField.text;
    self.captureUser.middleName              = self.middleNameTextField.text;
    self.captureUser.familyName              = self.lastNameTextField.text;
    self.captureUser.email                   = self.emailTextField.text;
    self.captureUser.displayName             = self.displayNameTextField.text;
    self.captureUser.password                = self.passwordTextField.text;
    self.captureUser.primaryAddress.mobile   = self.mobileTextField.text;
    self.captureUser.primaryAddress.phone    = self.phoneTextField.text;
    self.captureUser.gender                  = genderPicker.selectedValue;
    self.captureUser.birthday                = birthdatePicker.date;
    self.captureUser.primaryAddress.address1 = self.address1TextField.text;
    self.captureUser.primaryAddress.address2 = self.address2TextField.text;
    self.captureUser.primaryAddress.city     = self.addressCityTextField.text;
    self.captureUser.primaryAddress.zip      = self.addressPostalCodeTextField.text;
    self.captureUser.primaryAddress.stateAbbreviation = addressStatePicker.selectedValue;
    self.captureUser.primaryAddress.country  = addressCountryPicker.selectedValue;

    if ([self.optInRegistrationSwitch isOn]) {
        [self.captureUser.optIn setStatusWithBool:self.optInRegistrationSwitch.isOn];
    }

    [JRCapture registerNewUser:self.captureUser socialRegistrationToken:nil forDelegate:self];
    self.registerButton.enabled = NO;
}

-(void)birthdayPickerChanged:(UIDatePicker *)sender
{
    self.birthdateTextField.text = [self stringfromDate:sender.date];
}

-(void)dismissPicker
{
    [self.view endEditing:YES];
}

#pragma mark - Notifications
- (void)keyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    CGRect frame = self.view.frame;
    frame.size.height -= keyboardSize.height;
    CGPoint origin = activeField.frame.origin;
    CGPoint bottom = CGPointMake(origin.x, origin.y + activeField.frame.size.height);
    if (!CGRectContainsPoint(frame, origin) || !CGRectContainsPoint(frame, bottom )) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - JRCaptureDelegate
- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser
{
    appDelegate.captureUser = registeredUser;
    [Utils handleSuccessWithTitle:@"Registration Complete" message:nil forVc:self];
    self.registerButton.enabled = YES;
}

- (void)captureDidSucceedWithCode:(NSString *)code
{
    DLog(@"Authorization Code: %@",code);
}

- (void)registerUserDidFailWithError:(NSError *)error
{
    if ([error isJRFormValidationError]){
        NSDictionary *invalidFieldLocalizedFailureMessages = [error JRValidationFailureMessages];
        [Utils handleFailureWithTitle:@"Invalid Form Submission"
                              message: [invalidFieldLocalizedFailureMessages description] forVC:self];
    }else{
        [Utils handleFailureWithTitle:@"Registration Failed" message:[error localizedDescription] forVC:self];
    }
    self.registerButton.enabled = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == activeField) {
        activeField = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == activeField) {
        activeField = nil;
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - JRPickerViewDelegate
-(void)jrPickerView:(JRPickerView *)jrPickerView didSelectElement:(NSString *)element
{
    UITextField *textField;
    if ([jrPickerView isEqual:genderPicker]) {
        textField = self.genderTextField;
    } else if ([jrPickerView isEqual:addressStatePicker]) {
        textField = self.addressStateTextField;
    } else if([jrPickerView isEqual:addressCountryPicker]){
        textField = self.addressCountryTextField;
        if (![jrPickerView.selectedValue isEqualToString:@"US"]) {
            self.addressStateTextField.text = @"";
            self.addressStateTextField.enabled = NO;
            addressStatePicker.selectedValue = self.addressStateTextField.text = @"";;
        } else {
            self.addressStateTextField.enabled = YES;
        }
    }

    textField.text = element;
}

@end
