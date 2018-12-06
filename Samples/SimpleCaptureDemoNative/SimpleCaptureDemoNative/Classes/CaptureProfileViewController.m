/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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

 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRCaptureObject.h"
#import "JRCaptureUser+Extras.h"
#import "CaptureProfileViewController.h"
#import "AppDelegate.h"
#import "JRCapture.h"
#import "Utils.h"
#import "JRCaptureError.h"
#import "JRPickerView.h"
#import "JRStandardFlowKeys.h"

@interface CaptureProfileViewController () <UITextFieldDelegate, JRCaptureObjectDelegate, JRCaptureDelegate, JRPickerViewDelegate>

@property(nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCityTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressPostalCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressStateTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCountryTextField;

@property (weak, nonatomic) IBOutlet UISwitch *optInRegistrationSwitch;

@property (weak, nonatomic) IBOutlet UILabel *optInRegistrationLabel;

@property(weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end

@implementation CaptureProfileViewController
{
    UIDatePicker *birthdayPicker;
    
    JRPickerView *genderPicker;
    JRPickerView *statePicker;
    JRPickerView *countryPicker;
    
    UIView *activeField;
}

@synthesize emailTextField;
@synthesize displayNameTextField;
@synthesize firstNameTextField;
@synthesize middleNameTextField;
@synthesize lastNameTextField;
@synthesize birthdayTextField;
@synthesize genderTextField;
@synthesize mobileTextField;
@synthesize phoneTextField;
@synthesize address1TextField;
@synthesize address2TextField;
@synthesize addressCityTextField;
@synthesize addressPostalCodeTextField;
@synthesize scrollView;
@synthesize addressStateTextField;
@synthesize addressCountryTextField;
@synthesize optInRegistrationSwitch;
@synthesize optInRegistrationLabel;

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(320, optInRegistrationLabel.frame.origin.y + (optInRegistrationLabel.frame.size.height) + 40);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    emailTextField.delegate             = self;
    displayNameTextField.delegate       = self;
    firstNameTextField.delegate         = self;
    middleNameTextField.delegate        = self;
    lastNameTextField.delegate          = self;
    mobileTextField.delegate            = self;
    phoneTextField.delegate             = self;
    address1TextField.delegate          = self;
    address2TextField.delegate          = self;
    addressCityTextField.delegate       = self;
    addressPostalCodeTextField.delegate = self;
    
    [self setupBirthdayFieldInputView];
    
    genderPicker  = [self jrPickerViewForTextField:genderTextField andFlowField:@"gender"];
    statePicker   = [self jrPickerViewForTextField:addressStateTextField andFlowField:@"addressState"];
    countryPicker = [self jrPickerViewForTextField:addressCountryTextField andFlowField:@"addressCountry"];
    
    emailTextField.text       = appDelegate.captureUser.email;
    displayNameTextField.text = appDelegate.captureUser.displayName;
    firstNameTextField.text   = appDelegate.captureUser.givenName;
    middleNameTextField.text  = appDelegate.captureUser.middleName;
    lastNameTextField.text    = appDelegate.captureUser.familyName;
    
    birthdayTextField.text = [self stringfromDate:[NSDate date]];
    [birthdayPicker setDate:[NSDate date] animated:YES];
    if (appDelegate.captureUser.birthday) {
        birthdayTextField.text = [self stringfromDate:appDelegate.captureUser.birthday];
        [birthdayPicker setDate:appDelegate.captureUser.birthday animated:YES];
    }
    
    genderTextField.text            = [genderPicker textForValue:appDelegate.captureUser.gender];
    mobileTextField.text            = appDelegate.captureUser.primaryAddress.mobile;
    phoneTextField.text             = appDelegate.captureUser.primaryAddress.phone;
    address1TextField.text          = appDelegate.captureUser.primaryAddress.address1;
    address1TextField.text          = appDelegate.captureUser.primaryAddress.address2;
    addressCityTextField.text       = appDelegate.captureUser.primaryAddress.city;
    addressPostalCodeTextField.text = appDelegate.captureUser.primaryAddress.zip;
    addressStateTextField.text      = [statePicker textForValue:appDelegate.captureUser.primaryAddress.stateAbbreviation];
    addressCountryTextField.text    = [countryPicker textForValue:appDelegate.captureUser.primaryAddress.country];
    optInRegistrationLabel.text     = [self textForOptInLabel];
    
    if (appDelegate.isNotYetCreated || !appDelegate.captureUser){
        self.doneButton.title = @"Register";
    } else{
        self.doneButton.title = @"Update";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (appDelegate.isNotYetCreated == YES) {
        appDelegate.isNotYetCreated = NO;
        appDelegate.captureUser = nil;
        appDelegate.registrationToken = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
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

-(NSString *)textForOptInLabel {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *archivedCaptureUser = [delegate.prefs objectForKey:kJRCaptureFlowKey];
    if (archivedCaptureUser) {
        NSDictionary *captureFlow = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        NSDictionary *fields = captureFlow[kFieldsKey];
        NSDictionary *optIn = fields[@"optInRegistration"];
        
        return optIn[kLabelKey];
    }
    //    optInSwitch.hidden = YES;
    return @"";
}

-(void)setupBirthdayFieldInputView
{
    birthdayTextField.inputAccessoryView = [self setupInputAccessoryView];
    
    birthdayPicker = [[UIDatePicker alloc] init];
    birthdayPicker.datePickerMode = UIDatePickerModeDate;
    birthdayPicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [birthdayPicker addTarget:self action:@selector(birthdayPickerChanged:) forControlEvents:UIControlEventValueChanged];
    birthdayTextField.inputView = birthdayPicker;
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

#pragma mark - Actions
- (IBAction)doneButtonPressed:(id)sender
{
    appDelegate.captureUser.email       = emailTextField.text;
    appDelegate.captureUser.displayName = displayNameTextField.text;
    appDelegate.captureUser.givenName   = firstNameTextField.text;
    appDelegate.captureUser.middleName  = middleNameTextField.text;
    appDelegate.captureUser.familyName  = lastNameTextField.text;
    appDelegate.captureUser.birthday    = birthdayPicker.date;
    appDelegate.captureUser.gender      = genderPicker.selectedValue;
    
    JRPrimaryAddress *address = [[JRPrimaryAddress alloc] init];
    address.mobile   =  mobileTextField.text;;
    address.phone    = phoneTextField.text;
    address.address1 =  address1TextField.text;
    address.address2 = address2TextField.text;
    address.city     = addressCityTextField.text;
    address.zip      = addressPostalCodeTextField.text;
    address.stateAbbreviation = statePicker.selectedValue;
    address.country  = countryPicker.selectedValue;
    
    appDelegate.captureUser.primaryAddress = address;
    
    JROptIn *optIn = [JROptIn optIn];
    [optIn setStatusWithBool:optInRegistrationSwitch.isOn];
    if ([optIn getStatusBoolValue]) {
        appDelegate.captureUser.optIn = optIn;
    }
    
    if (appDelegate.isNotYetCreated) {
        [JRCapture registerNewUser:appDelegate.captureUser socialRegistrationToken:appDelegate.registrationToken
                       forDelegate:self];
    }
    
    self.doneButton.enabled = NO;
}

-(void)birthdayPickerChanged:(UIDatePicker *)sender
{
    birthdayTextField.text = [self stringfromDate:sender.date];
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

#pragma mark - JRCaptureObjectDelegate
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [Utils handleSuccessWithTitle:@"Profile updated" message:nil forVc:self];
    self.doneButton.enabled = YES;
}

- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [Utils handleFailureWithTitle:@"Profile not updated" message:nil foVC:self];
    self.doneButton.enabled = YES;
}

#pragma mark - JRCaptureDelegate
- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser
{
    appDelegate.isNotYetCreated = NO;
    appDelegate.captureUser = registeredUser;
    appDelegate.registrationToken = nil;
    [Utils handleSuccessWithTitle:@"Registration Complete" message:nil forVc:self];
}

- (void)registerUserDidFailWithError:(NSError *)error
{
    [error isJRMergeFlowError];
    if ([error isJRFormValidationError]) {
        NSDictionary *invalidFieldLocalizedFailureMessages = [error JRValidationFailureMessages];
        [Utils handleFailureWithTitle:@"Invalid Form Submission" message:[invalidFieldLocalizedFailureMessages description] foVC:self];
        
    }
    else {
        [Utils handleFailureWithTitle:@"Registration Failed" message:[error localizedDescription] foVC:self];
    }
    
    self.doneButton.enabled = YES;
}

#pragma mark - JRPickerViewDelegate
-(void)jrPickerView:(JRPickerView *)jrPickerView didSelectElement:(NSString *)element
{
    UITextField *textField;
    if ([jrPickerView isEqual:genderPicker]) {
        textField = genderTextField;
    } else if ([jrPickerView isEqual:statePicker ]) {
        textField = addressStateTextField;
    } else if([jrPickerView isEqual:countryPicker]){
        textField = addressCountryTextField;
        if (![jrPickerView.selectedValue isEqualToString:@"US"]) {
            addressStateTextField.text = @"";
            addressStateTextField.enabled = NO;
            statePicker.selectedValue = addressStateTextField.text = @"";;
        } else {
            addressStateTextField.enabled = YES;
        }
    }
    
    textField.text = element;
}
@end
