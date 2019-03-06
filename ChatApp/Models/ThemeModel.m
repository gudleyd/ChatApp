//
//  ThemeModel.m
//  ChatApp
//
//  Created by Иван Лебедев on 04/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#import "ThemeModel.h"


@implementation ThemeModel


- (UIColor *)theme1 {
    return self->theme1;
}

- (UIColor *)theme2 {
    return self->theme2;
}

- (UIColor *)theme3 {
    return self->theme3;
}

- (void)setTheme1:(UIColor *)color {
    [color retain];
    [self->theme1 release];
    self->theme1 = color;
}

- (void)setTheme2:(UIColor *)color {
    [color retain];
    [self->theme2 release];
    self->theme2 = color;
}

- (void)setTheme3:(UIColor *)color {
    [color retain];
    [self->theme3 release];
    self->theme3 = color;
}

- (void)dealloc {
    [[self theme1] release];
    [[self theme2] release];
    [[self theme3] release];
    [super dealloc];
}

@end
