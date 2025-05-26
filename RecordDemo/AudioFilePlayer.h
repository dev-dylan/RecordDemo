//
//  AudioFilePlayer.h
//  RecordDemo
//
//  Created by yypeng5 on 2025/4/22.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AudioFilePlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

// 初始化并播放项目中的音频文件
- (instancetype)initWithFileName:(NSString *)fileName;
- (BOOL)play;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
