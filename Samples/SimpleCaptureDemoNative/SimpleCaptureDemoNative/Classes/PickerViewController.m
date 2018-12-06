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



#import "PickerViewController.h"


@implementation PickerViewController
{
    UIView *myPickerViewGroup;
    UIToolbar *pickerToolbar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    myPickerViewGroup = [[UIView alloc] initWithFrame:CGRectZero];
    myPickerViewGroup.backgroundColor = [UIColor whiteColor];
    myPickerViewGroup.opaque = YES;

    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleDone target:self
                                                     action:@selector(pickerDone)]];
    [pickerToolbar setItems:items animated:NO];
    [pickerToolbar sizeToFit];

    myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerToolbar.frame.size.height, 0, 0)];
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    [myDatePicker addTarget:self action:@selector(pickerChanged) forControlEvents:UIControlEventValueChanged];

    [myPickerViewGroup addSubview:myDatePicker];
    [myPickerViewGroup addSubview:pickerToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    myPickerViewGroup.frame = CGRectMake(0, self.view.window.frame.size.height, pickerToolbar.frame.size.width,
            myDatePicker.frame.size.height + pickerToolbar.frame.size.height);
}

- (void)slidePickerUp
{
    if (myPickerViewGroup.superview == nil)
   	{
   		[self.view.window addSubview:myPickerViewGroup];

        CGRect screenRect = [[UIScreen mainScreen] bounds];
   		CGSize pickerSize = myPickerViewGroup.frame.size;
   		CGRect startRect = CGRectMake(0.0,
   									  screenRect.origin.y + screenRect.size.height,
   									  pickerSize.width, pickerSize.height);
   		myPickerViewGroup.frame = startRect;

   		// compute the end frame
   		CGRect pickerRect = CGRectMake(0.0,
   									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
   									   pickerSize.width,
   									   pickerSize.height);

   		// start the slide up animation
        [UIView beginAnimations:@"slidePickerUp" context:nil];
   			[UIView setAnimationDuration:0.3];
   			myPickerViewGroup.frame = pickerRect;
   		[UIView commitAnimations];
   	}
}

- (void)slideDownDidStop
{
	[myPickerViewGroup removeFromSuperview];
}

- (void)slidePickerDown
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
   	CGRect endFrame = myPickerViewGroup.frame;
   	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;

   	// start the slide down animation
    [UIView beginAnimations:@"slidePickerDown" context:nil];
   		[UIView setAnimationDuration:0.3];

   		// we need to perform some post operations after the animation is complete
   		[UIView setAnimationDelegate:self];
   		[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];

   		myPickerViewGroup.frame = endFrame;
   	[UIView commitAnimations];
}

- (void)pickerChanged { }

- (void)pickerDone { }

@end
