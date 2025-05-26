//
//  AudioPlayer.h
//  RecordDemo
//
//  Created by yypeng5 on 2025/4/22.
//

#import <Foundation/Foundation.h>
// 导入必要的框架
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSString *audioFilePath;

- (instancetype)initWithAudioFilePath:(NSString *)filePath;
- (BOOL)play;
- (void)pause;
- (void)stop;
- (void)setVolume:(float)volume;
- (float)getCurrentTime;
- (void)seekToTime:(float)time;

@end

NS_ASSUME_NONNULL_END
