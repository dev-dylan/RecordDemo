//
//  LBTAudioRecorder.m
//  starWay
//
//  Created by yypeng5 on 2025/4/21.
//

#import <UIKit/UIKit.h>
#import "LBTAudioRecorder.h"

@interface LBTAudioRecorder ()

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSString *recordedFilePath;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) NSDate *startTime;

@end

@implementation LBTAudioRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAudioSession];
    }
    return self;
}

- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    
    // 设置录音会话
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        NSLog(@"设置AVAudioSession类别时出错: %@", error.localizedDescription);
        return;
    }
    
    // 激活会话
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"激活AVAudioSession时出错: %@", error.localizedDescription);
        return;
    }
}

- (BOOL)startRecording {
    if (self.isRecording) {
        return NO;
    }
    
    // 创建录音文件保存路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [NSString stringWithFormat:@"recording_%ld.m4a", (long)[[NSDate date] timeIntervalSince1970]];
    self.recordedFilePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.recordedFilePath];
    
    // 设置录音参数
    NSDictionary *settings = @{
        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        AVSampleRateKey: @44100.0f,
        AVNumberOfChannelsKey: @2,
        AVEncoderAudioQualityKey: @(AVAudioQualityHigh)
    };
    
    // 初始化录音器
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
    if (error) {
        NSLog(@"初始化录音器时出错: %@", error.localizedDescription);
        if ([self.delegate respondsToSelector:@selector(audioRecorderDidFailWithError:)]) {
            [self.delegate audioRecorderDidFailWithError:error];
        }
        return NO;
    }
    
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    
    // 准备录音
    [self.audioRecorder prepareToRecord];
    
    // 开始录音
    if ([self.audioRecorder record]) {
        self.isRecording = YES;
        self.startTime = [NSDate date];
        return YES;
    } else {
        NSLog(@"开始录音失败");
        return NO;
    }
}

- (void)stopRecording {
    if (self.isRecording && self.audioRecorder) {
        [self.audioRecorder stop];
        self.isRecording = NO;
    }
}

- (float)currentRecordingTime {
    if (self.isRecording && self.startTime) {
        return [[NSDate date] timeIntervalSinceDate:self.startTime];
    }
    return 0.0f;
}

- (float)averagePower {
    if (self.isRecording && self.audioRecorder) {
        [self.audioRecorder updateMeters];
        return [self.audioRecorder averagePowerForChannel:0];
    }
    return -160.0f; // 静默值
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    self.isRecording = NO;
    
    if (flag) {
        if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:)]) {
            [self.delegate audioRecorderDidFinishRecording:self.recordedFilePath];
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"AudioRecorderErrorDomain" code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"录音未能成功完成"
        }];
        if ([self.delegate respondsToSelector:@selector(audioRecorderDidFailWithError:)]) {
            [self.delegate audioRecorderDidFailWithError:error];
        }
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    if ([self.delegate respondsToSelector:@selector(audioRecorderEncodeErrorDidOccur:)]) {
        [self.delegate audioRecorderEncodeErrorDidOccur:error];
    }
}

@end
