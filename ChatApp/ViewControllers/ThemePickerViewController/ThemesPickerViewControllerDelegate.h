//
//  ThemesPickerViewControllerDelegate.h
//  ChatApp
//
//  Created by Иван Лебедев on 04/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThemePickerViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemePickerViewControllerDelegate <NSObject>

- (void)themePickerViewController :(ThemePickerViewController*) controller newTheme:(UIColor *)newTheme;

@end

NS_ASSUME_NONNULL_END
