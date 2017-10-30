//
//  JRGender.m
//  SimpleCaptureDemo
//
//  Created by Roberto Halgravez on 10/26/17.
//
//

#import "JRPickerView.h"
#import "AppDelegate.h"

@interface JRPickerView ()

@property(nonatomic, strong) NSMutableArray *options;

@end

@implementation JRPickerView {
    NSDictionary *_genderFlow;
}

-(instancetype)initWithField:(NSString *)field {
    self = [super init];
    if (self) {
        _options = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSData *archivedCaptureUser = [delegate.prefs objectForKey:@"JR_capture_flow"];
        if (archivedCaptureUser) {
            NSDictionary *captureFlow = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
            NSDictionary *fields = captureFlow[@"fields"];
            _genderFlow = fields[field]; //""gender" or "addressCountry"
            
            _label = _genderFlow[@"label"];
            _placeholder = _genderFlow [@"placeholder"];
            _schemaId = _genderFlow[@"schemeId"];
            
            for (NSDictionary *option in _genderFlow[@"options"]) {
                if (option[@"disabled"]) {
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
        if ([value isEqualToString:option[@"value"]]) {
            _selectedValue = value;
            _selectedText = option[@"text"];
            return _selectedText;
        }
    }
    return @"";
}

-(NSString *)valueForText:(NSString *)text {
    for (NSDictionary *option in _options) {
        if ([text isEqualToString:option[@"text"]]) {
            _selectedText = text;
            _selectedValue = option[@"value"];
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
    return option[@"text"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *option = self.options[row];
    _selectedValue = option[@"value"];
    _selectedText = option[@"text"];
    [_jrPickerViewDelegate jrPickerView:self didSelectElement:_selectedText];
}


@end
