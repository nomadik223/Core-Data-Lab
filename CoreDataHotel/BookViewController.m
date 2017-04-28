//
//  BookViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/26/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//


@import Crashlytics;

#import "BookViewController.h"
#import "AutoLayout.h"
#import "HotelServices.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"

@interface BookViewController ()

@property(strong, nonatomic)UITextField *firstNameField;
@property(strong, nonatomic)UITextField *lastNameField;
@property(strong, nonatomic)UITextField *emailField;

@end

@implementation BookViewController

- (void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupTextFields];
    [self setupDoneButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupDoneButton{
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

- (void)doneButtonPressed{
    
    [HotelServices saveNewReservationInRoom:self.selectedRoom
                                  startDate:self.startDate
                                    endDate:self.endDate
                                  firstName:self.firstNameField.text
                                   lastName:self.lastNameField.text
                                      email:self.emailField.text
                    andNavigationController:self.navigationController];
    
}

- (void)setupTextFields{
    
    UILabel *hotelName = [[UILabel alloc]init];
    hotelName.text = self.selectedRoom.hotel.name;
    hotelName.textAlignment = NSTextAlignmentCenter;
    
    UILabel *roomNumber = [[UILabel alloc]init];
    roomNumber.text = [NSString stringWithFormat:@"Room Number: %i", self.selectedRoom.number];
    roomNumber.textAlignment = NSTextAlignmentCenter;
    
    self.firstNameField = [[UITextField alloc]init];
    self.firstNameField.placeholder = @"First Name (Required)";
    self.firstNameField.keyboardType = UIKeyboardTypeDefault;
    
    self.lastNameField = [[UITextField alloc]init];
    self.lastNameField.placeholder = @"Last Name (Required)";
    self.lastNameField.keyboardType = UIKeyboardTypeDefault;
    
    self.emailField = [[UITextField alloc]init];
    self.emailField.placeholder = @"Email Address";
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [self.view addSubview:hotelName];
    [self.view addSubview:roomNumber];
    [self.view addSubview:self.firstNameField];
    [self.view addSubview:self.lastNameField];
    [self.view addSubview:self.emailField];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat frameHeight = ((windowHeight - topMargin) / 10);
    
    NSDictionary *viewDictionary = @{@"hotelName": hotelName,
                                     @"roomNumber": roomNumber,
                                     @"firstNameField": self.firstNameField,
                                     @"lastNameField": self.lastNameField,
                                     @"emailField": self.emailField};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin],
                                        @"frameHeight": [NSNumber numberWithFloat:frameHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[hotelName(==frameHeight)][roomNumber(==frameHeight)]-[firstNameField(==frameHeight)]-[lastNameField(==firstNameField)]-[emailField(==firstNameField)]";
    
    [AutoLayout leadingConstraintFrom:hotelName toView:self.view];
    [AutoLayout trailingConstraintFrom:hotelName toView:self.view];
    [AutoLayout leadingConstraintFrom:roomNumber toView:self.view];
    [AutoLayout trailingConstraintFrom:roomNumber toView:self.view];
    [AutoLayout leadingConstraintFrom:self.firstNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.firstNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:self.lastNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.lastNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:self.emailField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.emailField toView:self.view];
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary
                               forMetricsDictionary:metricsDictionary
                                        withOptions:0
                                   withVisualFormat:visualFormatString];
    
    [hotelName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [roomNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.lastNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

@end
