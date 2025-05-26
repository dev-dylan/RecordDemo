//
//  AudioFilePlayer.m
//  RecordDemo
//
//  Created by yypeng5 on 2025/4/22.
//

#import "AudioFilePlayer.h"

@implementation AudioFilePlayer

- (instancetype)initWithFileName:(NSString *)filePath {
    self = [super init];
    if (self) {
        // 设置AVAudioSession
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
        if (sessionError) {
            NSLog(@"设置音频会话失败: %@", sessionError.localizedDescription);
        }
        
        [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
        if (sessionError) {
            NSLog(@"激活音频会话失败: %@", sessionError.localizedDescription);
        }
                
        if (!filePath) {
            NSLog(@"找不到音频文件: %@", filePath);
            return nil;
        }
        
        // 创建文件URL
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        // 初始化播放器
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        
        if (error) {
            NSLog(@"创建音频播放器失败: %@", error.localizedDescription);
            return nil;
        }
        
        // 设置代理
        self.audioPlayer.delegate = self;
        
        // 预加载音频
        [self.audioPlayer prepareToPlay];
    }
    return self;
}

- (BOOL)play {
    return [self.audioPlayer play];
}

- (void)pause {
    [self.audioPlayer pause];
}

- (void)stop {
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = 0;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"音频播放完成");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"音频解码出错: %@", error.localizedDescription);
}

@end
