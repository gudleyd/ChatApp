//
//  ThemePickerViewController.m
//  ChatApp
//
//  Created by Иван Лебедев on 28/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#import "ThemePickerViewController.h"

@implementation ThemePickerViewController

-(void) customizeButton: (UIButton *) button
{
    [[button layer] setCornerRadius : 8];
    [[button layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[button layer] setBorderWidth:1];
    [button setBackgroundColor: [[[UIColor alloc] initWithRed:152.0 / 255.0 green:251.0 / 255.0 blue:152.0 / 255.0 alpha:1.0] autorelease]];
    [button setTitleColor:[UIColor blackColor] forState:normal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[ThemeModel alloc] init];
    [model setTheme1:[UIColor whiteColor]];
    [model setTheme2:[UIColor blackColor]];
    [model setTheme3:[[UIColor alloc] initWithRed:251.0/255.0 green:125.0/255.0 blue:251.0/255.0 alpha:1]];
    
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    theme1Button = [[UIButton alloc] init];
    theme2Button = [[UIButton alloc] init];
    theme3Button = [[UIButton alloc] init];
    closeButton = [[UIButton alloc] init];
    
    [theme1Button setTitle:@"Светлая Тема" forState: normal];
    [theme2Button setTitle:@"Темная Тема" forState: normal];
    [theme3Button setTitle:@"Необычная Тема" forState: normal];
    [closeButton setTitle:@"Закрыть" forState: normal];
    
    [self customizeButton:theme1Button];
    [self customizeButton:theme2Button];
    [self customizeButton:theme3Button];
    [self customizeButton:closeButton];
    
    [theme1Button addTarget:self action:@selector(setTheme1:) forControlEvents:UIControlEventTouchUpInside];
    [theme2Button addTarget:self action:@selector(setTheme2:) forControlEvents:UIControlEventTouchUpInside];
    [theme3Button addTarget:self action:@selector(setTheme3:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    
    stackView = [[UIStackView alloc] initWithArrangedSubviews:([[[NSArray alloc] initWithObjects:theme1Button, theme2Button, theme3Button, closeButton, nil] autorelease])];
    
    [[self view] addSubview:stackView];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:false];
    [stackView setAxis:UILayoutConstraintAxisVertical];
    [stackView setDistribution:UIStackViewDistributionFillEqually];
    [stackView setBackgroundColor:[[[UIColor alloc] initWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:205.0 / 255.0 alpha:1.0] autorelease]];
    
    [[[stackView heightAnchor] constraintEqualToAnchor:[[self view] heightAnchor] multiplier:0.4] setActive:true];
    [[[stackView widthAnchor] constraintEqualToAnchor:[[self view] widthAnchor] multiplier:0.6] setActive:true];
    
    [[[stackView centerXAnchor] constraintEqualToAnchor:[[self view] centerXAnchor]] setActive:true];
    [[[stackView centerYAnchor] constraintEqualToAnchor:[[self view] centerYAnchor]] setActive:true];
}

- (ThemeModel *)model {
    return self->model;
}

- (void)setModel:(ThemeModel *) model {
    [model retain];
    [self->model release];
    self->model = model;
}

- (void)setDelegate:(id<ThemePickerViewControllerDelegate>)delegateToSet {
    if (delegate != delegateToSet) {
        [delegateToSet retain];
        [self->delegate release];
        self->delegate = delegateToSet;
    }
}

-(void) close: (NSObject*) sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) setTheme1: (NSObject*) sender {
    [[self view] setBackgroundColor:[model theme1]];
    [[self delegate] themePickerViewController:self newTheme:[model theme1]];
}

-(void) setTheme2: (NSObject*) sender {
    [[self view] setBackgroundColor:[model theme2]];
    [[self delegate] themePickerViewController:self newTheme:[model theme2]];
}

-(void) setTheme3: (NSObject*) sender {
    [[self view] setBackgroundColor:[model theme3]];
    [[self delegate] themePickerViewController:self newTheme:[model theme3]];
}

- (void)dealloc {
    
    [self->closeButton release];
    [self->theme1Button release];
    [self->theme2Button release];
    [self->theme3Button release];
    [self->stackView release];
    
    [[self model] release];
    [super dealloc];
}

- (id<ThemePickerViewControllerDelegate>)delegate {
    return self->delegate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
