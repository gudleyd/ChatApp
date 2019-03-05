//
//  ThemeModel.h
//  ChatApp
//
//  Created by Иван Лебедев on 04/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

#ifndef ThemeModel_h
#define ThemeModel_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeModel : NSObject
{
    UIColor* theme1;
    UIColor* theme2;
    UIColor* theme3;
}

-(UIColor*) theme1;
-(UIColor*) theme2;
-(UIColor*) theme3;

-(void) setTheme1: (UIColor*) newColor;
-(void) setTheme2: (UIColor*) newColor;
-(void) setTheme3: (UIColor*) newColor;

@end


#endif /* ThemeModel_h */
