//
//  GCCountDownTimer.m
//  LanguageTest
//
//  Created by 崇 on 2018/4/10.
//  Copyright © 2018年 崇. All rights reserved.
//

#import "GCCountDownTimer.h"
#import <UIKit/UIKit.h>

typedef void(^EnterForegroundBlock)(void);
@interface GCCountDownTimer(){
    dispatch_source_t timer;
}

@property (nonatomic,copy) EnterForegroundBlock enterForegroundBlock;

@property (nonatomic,assign) BOOL goingOn;

@end

@implementation GCCountDownTimer

- (instancetype)init {
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    return self;
}

- (void)applicationDidEnterBackground {
    if (self.goingOn) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

- (void)applicationWillEnterForegroundNotification {
    if (self.enterForegroundBlock) {
        self.enterForegroundBlock();
    }
}

- (void)countDownTime:(NSString *)timeInterval handler:(void (^)(BOOL stop,NSString *day,NSString *hour,NSString *minute,NSString *second))handler enterForegroundBlock:(void (^)(void))enterForegroundBlock {
    
    if (!(timeInterval.length>0)) {
        timer = nil;
        return;
    }
    
    timer = nil;
    
    __block long long timeout = [timeInterval longLongValue] / 1000; //倒计时时间
    
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(self->timer);
                self->timer = nil;
                self.goingOn = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(YES,nil,nil,nil,nil);
                    }
                });
            }else{
                self.goingOn = YES;
                
                int days   = (int)(timeout/(3600*24));
                int hours  = (int)((timeout-days*24*3600)/3600);
                int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                int second = (int)(timeout-days*24*3600-hours*3600-minute*60);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *dayText;
                    NSString *hourText;
                    NSString *minuteText;
                    NSString *secondText;
                    
                    if(days>0){
                        dayText = [NSString stringWithFormat:@"%d",days];
                    }else{
                        dayText = @"";
                    }
                    
                    if (hours<10) {
                        hourText = [NSString stringWithFormat:@"0%d",hours];
                    }else{
                        hourText = [NSString stringWithFormat:@"%d",hours];
                    }
                    if (minute<10) {
                        minuteText = [NSString stringWithFormat:@"0%d",minute];
                    }else{
                        minuteText = [NSString stringWithFormat:@"%d",minute];
                    }
                    if (second<10) {
                        secondText = [NSString stringWithFormat:@"0%d",second];
                    }else{
                        secondText = [NSString stringWithFormat:@"%d",second];
                    }
                    
                    if (handler) {
                        handler(NO,dayText,hourText,minuteText,secondText);
                    }
                });
                timeout--;
            }
        });
        dispatch_resume(timer);
    }
    
    self.enterForegroundBlock = enterForegroundBlock;
}

@end
