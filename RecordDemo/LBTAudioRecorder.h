//
//  LBTAudioRecorder.h
//  starWay
//
//  Created by yypeng5 on 2025/4/21.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioRecorderDelegate <NSObject>
@optional
- (void)audioRecorderDidFinishRecording:(NSString *)filePath;
- (void)audioRecorderDidFailWithError:(NSError *)error;
- (void)audioRecorderEncodeErrorDidOccur:(NSError *)error;
@end

@interface LBTAudioRecorder : NSObject <AVAudioRecorderDelegate>

@property (nonatomic, weak) id<AudioRecorderDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *recordedFilePath;
@property (nonatomic, assign, readonly) BOOL isRecording;

- (instancetype)init;
- (BOOL)startRecording;
- (void)stopRecording;
- (float)currentRecordingTime;
- (float)averagePower;

@end
