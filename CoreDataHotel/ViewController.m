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
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    UIButton *lookupButton = [self createButtonWithTitle:@"Look Up"];
    
    browseButton.backgroundColor = [UIColor colorWithRed:0.99 green:0.1 blue:0.1 alpha:0.0];
    
//    [AutoLayout leadingConstraintFrom:browseButton toView:self.view];
//    [AutoLayout trailingConstraintFrom:browseButton toView:self.view];
//    
//    [AutoLayout equalHeightConstraintFromView:browseButton
//                                       toView:self.view
//                               withMultiplier:0.2];
    
    
    [AutoLayout leadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout trailingConstraintFrom:bookButton toView:self.view];
    
    [AutoLayout equalHeightConstraintFromView:bookButton
                                       toView:self.view
                               withMultiplier:0.2];
    
    
    
    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    [bookButton addTarget:self action:@selector(bookButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)browseButtonSelected{
    HotelsViewController *newHotelsView = [[HotelsViewController alloc]init];
    
    [self.navigationController pushViewController:newHotelsView animated:YES];
}

- (void)bookButtonSelected{
    
    DatePickerViewController *datePickerController = [[DatePickerViewController alloc] init];
    
    [self.navigationController pushViewController:datePickerController animated:YES];
    
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
