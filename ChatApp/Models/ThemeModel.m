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
    self->theme1 = color;
}

- (void)setTheme2:(UIColor *)color {
    self->theme2 = color;
}

- (void)setTheme3:(UIColor *)color {
    self->theme3 = color;
}
@end
