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


#import "JRPickerView.h"
#import "AppDelegate.h"
#import "JRStandardFlowKeys.h"

@interface JRPickerView ()

@property(nonatomic, strong) NSMutableArray *options;

@end

@implementation JRPickerView {
    NSDictionary *_flow;
}

-(instancetype)initWithField:(NSString *)field {
    self = [super init];
    if (self) {
        _options = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSData *archivedCaptureUser = [delegate.prefs objectForKey:kJRCaptureFlowKey];
        if (archivedCaptureUser) {
            NSDictionary *captureFlow = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
            NSDictionary *fields = captureFlow[kFieldsKey];
            _flow = fields[field];

            _label = _flow[kLabelKey];
            _placeholder = _flow [kPlaceholderKey];
            _schemaId = _flow[kSchemeIdKey];

            for (NSDictionary *option in _flow[kOptionsKey]) {
                if (option[kDisabledKey]) {
                    continue;
                }
                [_options addObject:option];
            }
        }
    }
    return self;
}

-(NSString *)textForValue:(NSString *)value {
    for (NSDictionary *option in _options) {
        if ([value isEqualToString:option[kValueKey]]) {
            _selectedValue = value;
            _selectedText = option[kTextKey];
            return _selectedText;
        }
    }
    return @"";
}

-(NSString *)valueForText:(NSString *)text {
    for (NSDictionary *option in _options) {
        if ([text isEqualToString:option[kTextKey]]) {
            _selectedText = text;
            _selectedValue = option[kValueKey];
            return _selectedValue;
        }
    }
    return @"";
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.options.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *option = _options[row];
    return option[kTextKey];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *option = self.options[row];
    _selectedValue = option[kValueKey];
    _selectedText = option[kTextKey];
    [_jrPickerViewDelegate jrPickerView:self didSelectElement:_selectedText];
}


@end
