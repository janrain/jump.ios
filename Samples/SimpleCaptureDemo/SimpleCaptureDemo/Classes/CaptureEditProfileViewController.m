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

#import "CaptureEditProfileViewController.h"
#import "JRCapture.h"
#import "AppDelegate.h"
#import "JRCaptureUser+Extras.h"
#import "Utils.h"
#import "JRPickerView.h"
#import "JRStandardFlowKeys.h"

@interface CaptureEditProfileViewController () <UITextFieldDelegate, JRCaptureDelegate, JRPickerViewDelegate>
@end

@implementation CaptureEditProfileViewController {

    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *firstNameField;
    __weak IBOutlet UITextField *middleNameField;
    __weak IBOutlet UITextField *lastNameField;
    __weak IBOutlet UITextField *displayNameField;
    __weak IBOutlet UITextField *emailField;
    __weak IBOutlet UITextField *birthdayField;
    __weak IBOutlet UITextField *genderField;
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *addressStreetLine1Field;
    __weak IBOutlet UITextField *addressStreetLine2Field;
    __weak IBOutlet UITextField *addressCityField;
    __weak IBOutlet UITextField *addressStateField;
    __weak IBOutlet UITextField *addressCountryField;
    __weak IBOutlet UITextField *addressPostalCodeField;
    __weak IBOutlet UISwitch *optInSwitch;
    __weak IBOutlet UILabel *optInLabel;
    __weak IBOutlet UIButton *updateButton;
    __weak IBOutlet UITextField *mobileField;
    
    JRPickerView *genderPicker;
    JRPickerView *addressStatePicker;
    JRPickerView *addressCountryPicker;
    UIDatePicker *birthdayPicker;

    UIView * activeField;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(320, updateButton.frame.origin.y + (updateButton.frame.size.height));

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    firstNameField.delegate = self;
    middleNameField.delegate = self;
    lastNameField.delegate = self;
    displayNameField.delegate = self;
    emailField.delegate = self;
    phoneField.delegate = self;
    addressStreetLine1Field.delegate = self;
    addressStreetLine2Field.delegate = self;
    addressCityField.delegate = self;
    addressStateField.delegate = self;
    addressCountryField.delegate = self;
    addressPostalCodeField.delegate = self;
    mobileField.delegate = self;
    
    [self setupBirthdayFieldInputView];
    
    genderPicker = [[JRPickerView alloc] initWithField:@"gender"];
    genderPicker.jrPickerViewDelegate = self;
    genderField.inputAccessoryView = [self setupInputAccessoryView];
    genderField.inputView = genderPicker;
    
    addressStatePicker = [[JRPickerView alloc] initWithField:@"addressState"];
    addressStatePicker.jrPickerViewDelegate = self;
    addressStateField.inputAccessoryView = [self setupInputAccessoryView];
    addressStateField.inputView = addressStatePicker;
    
    addressCountryPicker = [[JRPickerView alloc] initWithField:@"addressCountry"];
    addressCountryPicker.jrPickerViewDelegate = self;
    addressCountryField.inputAccessoryView = [self setupInputAccessoryView];
    addressCountryField.inputView = addressCountryPicker;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    JRCaptureUser *user = delegate.captureUser;

    firstNameField.text = user.givenName;
    middleNameField.text = user.middleName;
    lastNameField.text = user.familyName;
    displayNameField.text = user.displayName;
    emailField.text = user.email;
    birthdayField.text = [self stringfromDate:[NSDate date]];
    [birthdayPicker setDate:[NSDate date] animated:YES];
    if (user.birthday) {
        birthdayField.text = [self stringfromDate:user.birthday];
        [birthdayPicker setDate:user.birthday animated:YES];
    }
    genderField.text = [genderPicker textForValue:user.gender];
    phoneField.text = user.primaryAddress.phone;
    addressStreetLine1Field.text = user.primaryAddress.address1;
    addressStreetLine2Field.text = user.primaryAddress.address2;
    addressCityField.text = user.primaryAddress.city;
    addressStateField.text = [addressStatePicker textForValue:user.primaryAddress.stateAbbreviation];
    addressStateField.enabled = [self enableStateForCountry:user.primaryAddress.country];
    addressCountryField.text = [addressCountryPicker textForValue:user.primaryAddress.country];
    addressPostalCodeField.text = user.primaryAddress.zip;
    mobileField.text = user.primaryAddress.mobile;
    [optInSwitch setOn:[user.optIn getStatusBoolValue] animated:YES];
    optInLabel.text = [self textForOptInLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

#pragma mark - Helper methods

-(void)setupBirthdayFieldInputView
{
    birthdayField.inputAccessoryView = [self setupInputAccessoryView];
    
    birthdayPicker = [[UIDatePicker alloc] init];
    birthdayPicker.datePickerMode = UIDatePickerModeDate;
    birthdayPicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [birthdayPicker addTarget:self action:@selector(birthdayPickerChanged:) forControlEvents:UIControlEventValueChanged];
    birthdayField.inputView = birthdayPicker;
}

-(UIView *)setupInputAccessoryView {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPicker)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexibleSpace, doneButton];
    
    return toolbar;
}

-(NSString *)stringfromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM/dd/yyyy"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [dateFormatter stringFromDate:date];
}

-(BOOL)enableStateForCountry:(NSString *)country {
    if ([country isEqualToString:@""] || [country isEqualToString:@"US"] || country == nil) {
        return YES;
    }
    return NO;
}

-(NSString *)textForOptInLabel {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *archivedCaptureUser = [delegate.prefs objectForKey:kJRCaptureFlowKey];
    if (archivedCaptureUser) {
        NSDictionary *captureFlow = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        NSDictionary *fields = captureFlow[kFieldsKey];
        NSDictionary *optIn = fields[@"optIn"];
        
        return optIn[kLabelKey];
    }
    optInSwitch.hidden = YES;
    return @"";
}

#pragma mark - Actions

- (IBAction)updateProfileButtonPressed:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    JRCaptureUser *user = delegate.captureUser;

    user.givenName = firstNameField.text;
    user.middleName = middleNameField.text;
    user.familyName = lastNameField.text;
    user.displayName = displayNameField.text;
    user.email = emailField.text;
    user.birthday = birthdayPicker.date;
    user.gender = genderPicker.selectedValue;
    user.primaryAddress.phone = phoneField.text;
    user.primaryAddress.address1 = addressStreetLine1Field.text;
    user.primaryAddress.address2 = addressStreetLine2Field.text;
    user.primaryAddress.city = addressCityField.text;
    user.primaryAddress.stateAbbreviation = addressStatePicker.selectedValue;
    user.primaryAddress.country = addressCountryPicker.selectedValue;
    user.primaryAddress.zip = addressPostalCodeField.text;
    user.primaryAddress.mobile = mobileField.text;
    
    updateButton.enabled = NO;

    [JRCapture updateProfileForUser:user delegate:self];
}

-(void)birthdayPickerChanged:(UIDatePicker *)sender
{
    birthdayField.text = [self stringfromDate:sender.date];
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

#pragma mark - JRCaptureDelegate

- (void)updateUserProfileDidFailWithError:(NSError *)error
{
    [Utils handleFailureWithTitle:@"Profile not updated" message:nil forVC:self];
    updateButton.enabled = YES;
}

- (void)updateUserProfileDidSucceed
{
    [Utils handleSuccessWithTitle:@"Profile Updated" message:nil forVc:self];
    updateButton.enabled = YES;
}

#pragma mark - UITextFieldDelegate

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

#pragma mark - JRPickerViewDelegate
-(void)jrPickerView:(JRPickerView *)jrPickerView didSelectElement:(NSString *)element
{
    UITextField *textField;
    if ([jrPickerView isEqual:genderPicker]) {
        textField = genderField;
    } else if ([jrPickerView isEqual:addressStatePicker ]) {
        textField = addressStateField;
    } else if([jrPickerView isEqual:addressCountryPicker]){
        textField = addressCountryField;
        if (![jrPickerView.selectedValue isEqualToString:@"US"]) {
            addressStateField.text = @"";
            addressStateField.enabled = NO;
            addressStatePicker.selectedValue = addressStateField.text = @"";;
        } else {
            addressStateField.enabled = YES;
        }
    }
    
    textField.text = element;
}
@end
