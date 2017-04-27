//
//  AutoLayoutTests.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/26/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTests : XCTestCase

@property(strong, nonatomic)UIViewController *testController;
@property(strong, nonatomic)UIView *testView1;
@property(strong, nonatomic)UIView *testView2;

@end

@implementation AutoLayoutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testController = [[UIViewController alloc]init];
    self.testView1 = [[UIView alloc]init];
    self.testView2 = [[UIView alloc]init];
    
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    //tearing down properties
    self.testController = nil;
    self.testView1 = nil;
    self.testView2 = nil;
    
    [super tearDown];
}

- (void)testGenericConstraintFromToViewWithAttribute{
    
    id constraint = [AutoLayout genericConstraintFrom:self.testView1
                                               toView:self.testView2
                                        withAttribute:NSLayoutAttributeTop];
    
    XCTAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"constraint is not an instance of NSLayoutConstraint!");
    
    XCTAssertTrue([(NSLayoutConstraint *)constraint isActive], @"constraint was not activated.");
    
}

@end
