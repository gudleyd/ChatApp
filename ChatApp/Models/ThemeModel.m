//
//  ThemeModel.m
//  ChatApp
//
//  Created by Иван Лебедев on 04/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#import "ThemeModel.h"


@implementation ThemeModel


- (UIColor *)theme1
{
    return self->theme1;
}

- (UIColor *)theme2
{
    return self->theme2;
}

- (UIColor *)theme3
{
    return self->theme3;
}

- (void)setTheme1:(UIColor *)newColor
{
    [newColor retain];
    [self->theme1 release];
    self->theme1 = newColor;
}

- (void)setTheme2:(UIColor *)newColor
{
    [newColor retain];
    [self->theme2 release];
    self->theme2 = newColor;
}

- (void)setTheme3:(UIColor *)newColor
{
    [newColor retain];
    [self->theme3 release];
    self->theme3 = newColor;
}

- (id)initWithColors:(UIColor *)theme1Color c1:(UIColor *)theme2Color c2:(UIColor *)theme3Color
{
    self = [self init];
    [self setTheme1:theme1Color];
    [self setTheme2:theme2Color];
    [self setTheme3:theme3Color];
    
    return self;
}

@end
