//
//  GCCountDownTimer.h
//
//  Created by 崇 on 2018/4/10.
//  Copyright © 2018年 崇. All rights reserved.
//

/*
 
****** 需要定义一个递归方法 ******
 
 - (void)start {
 // 模拟网络请求
 [UIView animateWithDuration:1 animations:^{
     [self.timer countDownTime:@"10000" handler:^(BOOL stop, NSString *day, NSString *hour, NSString *minute, NSString *second) {
         if (stop) {
            NSLog(@"倒计时停止");
         }
         else{
            NSLog(@"还剩 %@天 %@:%@:%@",day,hour,minute,second);
         }
     } enterForegroundBlock:^{
            [self start];
         }];
     }];
 }
 */

#import <Foundation/Foundation.h>

@interface GCCountDownTimer : NSObject

- (void)countDownTime:(NSString *)timeInterval handler:(void (^)(BOOL stop,NSString *day,NSString *hour,NSString *minute,NSString *second))handler enterForegroundBlock:(void (^)(void))enterForegroundBlock;
@end
