//
//  ThemePickerViewController.h
//  ChatApp
//
//  Created by Иван Лебедев on 28/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"
#import "ThemesPickerViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemePickerViewController : UIViewController
{
    UIButton *theme1Button;
    UIButton *theme2Button;
    UIButton *theme3Button;
    UIButton *closeButton;

    ThemeModel *model;
    id<ThemePickerViewControllerDelegate> delegate;

    UIStackView *stackView;
}

-(ThemeModel *) model;
-(void) setModel: (ThemeModel*) newModel;
-(void) setDelegate: (id<ThemePickerViewControllerDelegate>) delegate;
-(id<ThemePickerViewControllerDelegate>) delegate;
-(void)dealloc;

@end

NS_ASSUME_NONNULL_END
