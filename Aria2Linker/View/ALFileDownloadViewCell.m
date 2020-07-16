//
//  ALFileDownloadViewCell.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALFileDownloadViewCell.h"
#import "YLProgressBar.h"

@interface ALFileDownloadViewCell ()

@property (strong, nonatomic) UILabel *nameT, *sizeT, *remainingT, *speedT;
@property (strong, nonatomic) YLProgressBar *processView;

@end

@implementation ALFileDownloadViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ymColorWhite;
        if (!_nameT) {
            _nameT = [UILabel new];
            [_nameT setText:@" "];
            [self.contentView addSubview:_nameT];
            _nameT.numberOfLines = 2;
            _nameT.font = [UIFont systemFontOfSize:ymFontSizeBigger];
            [_nameT setTextColor:ymContentPrimaryTextColor];
            [_nameT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(ymScreen_left_padding);
                make.right.equalTo(self.contentView).offset(ymScreen_right_padding);
                make.top.equalTo(self.contentView).offset(ymScreen_top_padding);
            }];
        }
        [_nameT setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisHorizontal];
        if (!_sizeT) {
            _sizeT = [UILabel new];
            [_sizeT setText:@"无"];
            [self.contentView addSubview:_sizeT];
            _sizeT.font = [UIFont systemFontOfSize:ymFontSizeNormal];
            [_sizeT setTextColor:ymLabelColor];
            [_sizeT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameT);
                make.top.equalTo(_nameT.mas_baseline).offset(ymScreen_top_padding / 3);
            }];
        }

        if (!_processView) {
            _processView = [YLProgressBar new];
            _processView.progress = 0;
            [self.contentView addSubview:_processView];
            _processView.trackTintColor = ymColorBlueDark;
            _processView.type = YLProgressBarTypeRounded;
//            _processView.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeFixedRight;
            _processView.behavior = YLProgressBarBehaviorIndeterminate;
            _processView.stripesOrientation = YLProgressBarStripesOrientationVertical;
            [_processView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_nameT);
                make.top.equalTo(_sizeT.mas_bottom).offset(ymScreen_top_padding);
                make.height.equalTo(@6);
            }];
        }

        if (!_speedT) {
            _speedT = [UILabel new];
            _speedT.text = @" ";
            [self.contentView addSubview:_speedT];
            _speedT.font = [UIFont systemFontOfSize:ymFontSizeNormal];
            [_speedT setTextColor:ymContentPrimaryTextColor];
            [_speedT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameT);
                make.top.equalTo(_processView.mas_bottom).offset(ymScreen_top_padding / 2);
            }];
        }

        if (!_remainingT) {
            _remainingT = [UILabel new];
            _remainingT.text = @" ";
            [self.contentView addSubview:_remainingT];
            _remainingT.font = [UIFont systemFontOfSize:ymFontSizeNormal];
            [_remainingT setTextColor:ymContentPrimaryTextColor];
            [_remainingT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(ymScreen_right_padding);
                make.top.equalTo(_processView.mas_bottom).offset(ymScreen_top_padding / 2);
            }];
        }

        UIView *v = [UIView new];
        [self.contentView addSubview:v];
        v.backgroundColor = ymColorIngoreGrayLight;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@2);
            make.top.equalTo(_remainingT.mas_bottom).offset(ymScreen_top_padding);
            make.bottom.equalTo(self.contentView);
        }];
    }

    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    return self;
}

- (void)setActive:(TaskInfo *)taskInfo {
    NSString *filePath = [taskInfo.files[0].path lastPathComponent];
    NSString *uriPath = [taskInfo.files[0].uris count] > 0 ? [taskInfo.files[0].uris[0].uri lastPathComponent] : @"";
    _nameT.text = [CommonUtils stringIsNull:filePath] ? uriPath : filePath;
    _sizeT.text = [CommonUtils changeKMGB:taskInfo.totalLength];
    [_processView setProgress:taskInfo.totalLength == 0 ? 0 : (float) taskInfo.completedLength / taskInfo.totalLength
                     animated:NO];

    if ([taskInfo.status isEqualToString:@"active"]) {
        _speedT.text = [NSString stringWithFormat:@"%@/s", [CommonUtils changeKMGB:taskInfo.downloadSpeed]];
        _remainingT.text = [CommonUtils
            changeTimeFormat:taskInfo.downloadSpeed == 0
                                 ? 0
                                 : (taskInfo.totalLength - taskInfo.completedLength) / taskInfo.downloadSpeed];
    } else if ([taskInfo.status isEqualToString:@"paused"]) {
        _speedT.text = @" ";
        _remainingT.text = @"已暂停";
    } else {
        _speedT.text = @"";
        _remainingT.text = @"";
    }
}
@end
