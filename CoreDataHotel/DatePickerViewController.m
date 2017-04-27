//
//  DatePickerViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/25/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"

#import "AutoLayout.h"

@interface DatePickerViewController ()

@property(strong, nonatomic)UIDatePicker *startDate;
@property(strong, nonatomic)UIDatePicker *endDate;

@end

@implementation DatePickerViewController

- (void)loadView{
    [super loadView];
    
    [self setupDatePickers];
    [self setupDoneButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupDoneButton{
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupDatePickers{
    
    UILabel *startDateLabel = [[UILabel alloc]init];
    startDateLabel.text = @"Start Date";
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    
    self.startDate = [[UIDatePicker alloc]init];
    self.startDate.datePickerMode = UIDatePickerModeDate;
    
    UILabel *endDateLabel = [[UILabel alloc]init];
    endDateLabel.text = @"End Date";
    endDateLabel.textAlignment = NSTextAlignmentCenter;
    
    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDate;
    
    [self.view addSubview:startDateLabel];
    [self.view addSubview:self.startDate];
    [self.view addSubview:endDateLabel];
    [self.view addSubview:self.endDate];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat frameHeight = ((windowHeight - topMargin - statusBarHeight - statusBarHeight) / 2);
    
    NSDictionary *viewDictionary = @{@"startDate": self.startDate,
                                     @"endDate": self.endDate,
                                     @"startDateLabel": startDateLabel,
                                     @"endDateLabel": endDateLabel};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin],
                                        @"frameHeight": [NSNumber numberWithFloat:frameHeight],
                                        @"statusBarHeight": [NSNumber numberWithFloat:statusBarHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[startDateLabel(==statusBarHeight)][startDate(==frameHeight)][endDateLabel(==startDateLabel)][endDate(==startDate)]|";
    
    [AutoLayout leadingConstraintFrom:startDateLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:startDateLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:self.startDate toView:self.view];
    [AutoLayout trailingConstraintFrom:self.startDate toView:self.view];
    [AutoLayout leadingConstraintFrom:endDateLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:endDateLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:self.endDate toView:self.view];
    [AutoLayout trailingConstraintFrom:self.endDate toView:self.view];
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary
                               forMetricsDictionary:metricsDictionary
                                        withOptions:0
                                   withVisualFormat:visualFormatString];
    
    [startDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.startDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.endDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

- (void)doneButtonPressed{
    
    NSDate *startDate = self.startDate.date;
    NSDate *endDate = self.endDate.date;
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.endDate.date = [NSDate date];
        return;
    }
    if ([startDate timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.startDate.date = endDate;
        return;
    }
    
    AvailabilityViewController *availabilityController = [[AvailabilityViewController alloc]init];
    availabilityController.startDate = startDate;
    availabilityController.endDate = endDate;
    
    [self.navigationController pushViewController:availabilityController animated:YES];
    
}

@end
