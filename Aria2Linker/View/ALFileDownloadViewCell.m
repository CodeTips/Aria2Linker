//
//  ALFileDownloadViewCell.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALFileDownloadViewCell.h"
#import "ZZCircleProgress.h"

@interface ALFileDownloadViewCell ()

@property (strong, nonatomic) UILabel *nameT, *sizeT, *speedT;
@property (strong, nonatomic) ZZCircleProgress *processView;
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation ALFileDownloadViewCell

- (void)dealloc
{
    [self removeObservers];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ymColorWhite;
        @weakify(self);
        if (!_nameT) {
            _nameT = [UILabel new];
            [_nameT setText:@" "];
            [self.contentView addSubview:_nameT];
            _nameT.numberOfLines = 2;
            _nameT.font = [UIFont systemFontOfSize:ymFontSizeBigger];
            [_nameT setTextColor:ymContentPrimaryTextColor];
            [_nameT mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(ymScreen_left_padding);
                make.right.equalTo(self.contentView).offset(ymScreen_right_padding * 2 - 30);
                make.top.equalTo(self.contentView).offset(ymScreen_top_padding);
            }];
        }
        [_nameT setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisHorizontal];
        if (!_sizeT) {
            _sizeT = [UILabel new];
            [_sizeT setText:@"无"];
            [self.contentView addSubview:_sizeT];
            _sizeT.font = [UIFont systemFontOfSize:ymFontSizeSmallest];
            [_sizeT setTextColor:ymLabelColor];
            [_sizeT mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.nameT);
                make.width.mas_equalTo(self.contentView.width / 2);
                make.top.equalTo(self.nameT.mas_baseline).offset(ymScreen_top_padding);
            }];
        }

        if (!_speedT) {
            _speedT = [UILabel new];
            _speedT.textAlignment = NSTextAlignmentRight;
            _speedT.text = @" ";
            [self.contentView addSubview:_speedT];
            _speedT.font = [UIFont systemFontOfSize:ymFontSizeSmallest];
            [_speedT setTextColor:ymContentPrimaryTextColor];
            [_speedT mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.right.equalTo(self.nameT);
                make.width.mas_equalTo(self.contentView.width / 2);
                make.centerY.equalTo(self.sizeT);
            }];
        }

        UIView *v = [UIView new];
        [self.contentView addSubview:v];
        v.backgroundColor = ymColorIngoreGrayLight;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
            @strongify(self);
            make.top.equalTo(self.sizeT.mas_bottom).offset(ymScreen_top_padding);
            make.bottom.equalTo(self.contentView);
        }];
        
        if (!_processView) {
            _processView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            _processView.progress = 0;
            _processView.startAngle = -90;
            _processView.showPoint = NO;
            _processView.strokeWidth = 2;
            _processView.duration = 0;
            _processView.pathFillColor = ymColorBlueDark;
            _processView.pathBackColor = ymColorIngoreGrayLight;
            _processView.showProgressText = NO;
            _processView.increaseFromLast = YES;
            [self.contentView addSubview:_processView];
            [_processView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.nameT.mas_right).offset(ymScreen_padding_default);
                make.centerY.equalTo(self.nameT).offset(-(self.sizeT.height + 2 * ymScreen_top_padding)/ 2);
            }];
        }
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    return self;
}

- (void)setActive:(TaskInfo *)taskInfo {
    if (_active != taskInfo) {
        [self removeObservers];
        _active = taskInfo;
        _processView.progress = 0;
        [self addObservers];
    }
    
    NSString *filePath = [taskInfo.files[0].path lastPathComponent];
    NSString *uriPath = [taskInfo.files[0].uris count] > 0 ? [taskInfo.files[0].uris[0].uri lastPathComponent] : @"";
    _nameT.text = [CommonUtils stringIsNull:filePath] ? uriPath : filePath;
    _sizeT.text = [CommonUtils changeKMGB:taskInfo.totalLength];
    _speedT.text = @" ";
}

- (void)addObservers
{
    [_active addObserver:self forKeyPath:@"completedLength" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    [_active addObserver:self forKeyPath:@"downloadSpeed" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    [_active addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObservers
{
    [_active removeObserver:self forKeyPath:@"completedLength"];
    [_active removeObserver:self forKeyPath:@"downloadSpeed"];
    [_active removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"completedLength"]) {
        [_processView setProgress:_active.totalLength == 0 ? 0 : (float) _active.completedLength / _active.totalLength];
    }
    else if([keyPath isEqualToString:@"downloadSpeed"]){
        _speedT.text = [NSString stringWithFormat:@"%@/s", [CommonUtils changeKMGB:_active.downloadSpeed]];
    }
    else if([keyPath isEqualToString:@"status"]){
        if ([_active.status isEqualToString:@"paused"]) {
            _speedT.text = @" ";
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
