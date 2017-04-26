//
//  ViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/24/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"
#import "DatePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLayout];
    
}

- (void)setupLayout{
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    UIButton *browseButton = [self createButtonWithTitle:@"Browse"];
    browseButton.backgroundColor = [UIColor colorWithRed:0.60 green:0.00 blue:0.00 alpha:1.0];
    
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    bookButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.60 blue:0.0 alpha:1.0];
    
    UIButton *lookupButton = [self createButtonWithTitle:@"Look Up"];
    lookupButton.backgroundColor = [UIColor colorWithRed:0.00 green:0.0 blue:0.60 alpha:1.0];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat buttonHeight = ((windowHeight - topMargin) / 3);
    
    NSDictionary *viewDictionary = @{@"browseButton": browseButton, @"bookButton": bookButton, @"lookupButton": lookupButton};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"buttonHeight": [NSNumber numberWithFloat:buttonHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[browseButton(==buttonHeight)][bookButton(==browseButton)][lookupButton(==browseButton)]|";
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
    [AutoLayout leadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout trailingConstraintFrom:browseButton toView:self.view];
    
    [AutoLayout leadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout trailingConstraintFrom:bookButton toView:self.view];
    
    [AutoLayout leadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout trailingConstraintFrom:lookupButton toView:self.view];
    
    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [bookButton addTarget:self action:@selector(bookButtonSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)browseButtonSelected{
    HotelsViewController *newHotelsView = [[HotelsViewController alloc]init];
    
    [self.navigationController pushViewController:newHotelsView animated:YES];
}

- (void)bookButtonSelected{
    DatePickerViewController *newDatePickerView = [[DatePickerViewController alloc]init];
    
    [self.navigationController pushViewController:newDatePickerView animated:YES];
}

- (UIButton *)createButtonWithTitle:(NSString *)title{
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:title forState:normal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:button];
    
    return button;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
