//
//  AudioPlayer.m
//  RecordDemo
//
//  Created by yypeng5 on 2025/4/22.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

- (instancetype)initWithAudioFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _audioFilePath = filePath;
        [self setupAudioPlayer];
    }
    return self;
}

- (void)setupAudioPlayer {
    NSURL *url = [NSURL fileURLWithPath:self.audioFilePath];
    NSError *error = nil;
    
    // 初始化AVAudioPlayer
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"音频播放器初始化失败: %@", error.localizedDescription);
        return;
    }
    
    // 设置委托
    self.audioPlayer.delegate = self;
    
    // 预加载音频文件
    [self.audioPlayer prepareToPlay];
}

- (BOOL)play {
    return [self.audioPlayer play];
}

- (void)pause {
    [self.audioPlayer pause];
}

- (void)stop {
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = 0.0;
}

- (void)setVolume:(float)volume {
    // 音量范围 0.0 - 1.0
    self.audioPlayer.volume = volume;
}

- (float)getCurrentTime {
    return self.audioPlayer.currentTime;
}

- (void)seekToTime:(float)time {
    self.audioPlayer.currentTime = time;
}

#pragma mark - AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"音频播放完成");
    // 可以在这里添加播放完成后的处理逻辑
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"音频解码错误: %@", error.localizedDescription);
}

@end
