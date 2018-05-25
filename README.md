# GCCountDownTimer

一个进入后台不会停止的倒计时器。


****** 需要定义一个递归方法 ******

```
- (void)start {
    [UIView animateWithDuration:1 animations:^{
            // timeInterval是后台标准系统时间与目标时间的毫秒差
        [self.timer countDownTime:timeInterval handler:^(BOOL stop, NSString *day, NSString *hour, NSString *minute, NSString *second) {
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
