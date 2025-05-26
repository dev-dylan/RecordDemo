#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LBTAudioRecorder.h"
#import "AudioPlayer.h"
#import "AudioFilePlayer.h"

@interface ViewController ()

@property (nonatomic, strong) LBTAudioRecorder *audioRecorder;
@property (nonatomic, strong) AudioFilePlayer *audioFilePlayer;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"录音";
    
    [self setupUI];
    [self checkPermission];
    
    self.audioRecorder = [[LBTAudioRecorder alloc] init];
    self.audioRecorder.delegate = self;
}

- (void)setupUI {
    // 状态标签
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 30)];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"准备录音";
    [self.view addSubview:self.statusLabel];
    
    // 时间标签
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 50)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:40];
    self.timeLabel.text = @"00:00";
    [self.view addSubview:self.timeLabel];
    
    // 录音按钮
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake((self.view.bounds.size.width - 100) / 2, 250, 100, 100);
    self.recordButton.layer.cornerRadius = 50;
    [self.recordButton setBackgroundColor:[UIColor redColor]];
    [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    // 录音按钮
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake((self.view.bounds.size.width - 100) / 2, 400, 100, 100);
    self.playButton.layer.cornerRadius = 50;
    [self.playButton setBackgroundColor:[UIColor redColor]];
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
}

- (void)checkPermission {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                self.statusLabel.text = @"麦克风权限已获取";
                self.recordButton.enabled = YES;
            } else {
                self.statusLabel.text = @"请在设置中允许麦克风权限";
                self.recordButton.enabled = NO;
            }
        });
    }];
}

- (void)playAudio {
//    // 假设您有一个录制好的音频文件路径
    NSString *recordedFilePath = self.filePath;
//    // 创建播放器并播放
//    AudioPlayer *player = [[AudioPlayer alloc] initWithAudioFilePath:recordedFilePath];
//    BOOL result = [player play];
//    NSLog(@"开始录音 ：%@", @(result));
    // 查找项目中的m4a文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:[@"1718873863_sample1" stringByDeletingPathExtension] ofType:@"m4a"];
    
    self.audioFilePlayer = [[AudioFilePlayer alloc] initWithFileName:recordedFilePath];
    // 开始播放
    BOOL result = [self.audioFilePlayer play];
    NSLog(@"result:%@",@(result));

}

- (void)recordButtonTapped:(UIButton *)button {
    if (!button.isSelected) {
        // 开始录音
        if ([self.audioRecorder startRecording]) {
            button.selected = YES;
            self.statusLabel.text = @"正在录音...";
            [self startUpdateTimer];
        }
    } else {
        // 停止录音
        [self.audioRecorder stopRecording];
        button.selected = NO;
        self.statusLabel.text = @"录音已停止";
        [self stopUpdateTimer];
    }
}

- (void)startUpdateTimer {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecordingInfo) userInfo:nil repeats:YES];
}

- (void)stopUpdateTimer {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)updateRecordingInfo {
    // 更新录制时间
    float currentTime = [self.audioRecorder currentRecordingTime];
    int minutes = (int)currentTime / 60;
    int seconds = (int)currentTime % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

#pragma mark - AudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(NSString *)filePath {
    self.statusLabel.text = @"录音完成并保存";
    NSLog(@"录音文件保存在: %@", filePath);
    self.filePath = filePath;
    // 在这里可以添加录音完成后的处理逻辑
    // 例如：显示一个提示，或者跳转到另一个界面播放录音
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录音完成"
                                                                            message:[NSString stringWithFormat:@"文件保存在：%@", filePath]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)audioRecorderDidFailWithError:(NSError *)error {
    self.statusLabel.text = @"录音失败";
    NSLog(@"录音错误: %@", error.localizedDescription);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录音失败"
                                                                            message:error.localizedDescription
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
