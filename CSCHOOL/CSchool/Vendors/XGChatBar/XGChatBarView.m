//
//  XGChatBarView.m
//  XGChatBar
//
//  Created by mac on 15/11/24.
//  Copyright (c) 2015年 xin. All rights reserved.
//



#import "XGChatBarView.h"
#import "SDAutoLayout.h"
#import "UITextView+Placeholder.h"

@interface XGChatBarView()<UITextViewDelegate>

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIButton *sendButton;
@property (assign, nonatomic) CGRect keyboardFrame;
@property (assign, nonatomic, readonly) CGFloat screenHeight;
@property (assign, nonatomic, readonly) CGFloat bottomHeight;
@property (strong, nonatomic, readonly) UIViewController *rootViewController;
@property (copy, nonatomic) NSString *inputText;

@end
@implementation XGChatBarView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];


    
    self.sendButton.sd_layout
    .rightSpaceToView(self,8)
    .bottomSpaceToView(self,8)
    .heightIs(30)
    .widthIs(50);
    
    self.textView.sd_layout
    .leftSpaceToView(self,7)
    .rightSpaceToView(self.sendButton,8)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage:textView.text];
        return NO;
    }else if (text.length == 0){
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        if ([deleteText isEqualToString:@" "]) {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            NSString *subText;
            while (YES) {
                if (location == 0) {
                    return YES;
                }
                location -- ;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                if (([subText hasPrefix:@" "] && [subText hasSuffix:@" "])) {
                    return YES;
                }
                if (([subText hasPrefix:@"@"] && [subText hasSuffix:@" "])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            [self textViewDidChange:self.textView];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGRect textViewFrame = self.textView.frame;
    
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    NSLog(@"this is textSize  :%@",NSStringFromCGSize(textSize));
    CGFloat offset = 10;
    textView.scrollEnabled = (textSize.height + 0.1 > kMaxHeight-offset);
    textViewFrame.size.height = MAX(34, MIN(kMaxHeight, textSize.height));
    
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = self.screenHeight - self.bottomHeight - addBarFrame.size.height;
    //    self.frame = addBarFrame;
    [self setFrame:addBarFrame animated:NO];
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
    
}





#pragma mark - Private Methods

- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    [self textViewDidChange:self.textView];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self textViewDidChange:self.textView];
}

- (void)setup{
    
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:235/255.0f green:236/255.0f blue:238/255.0f alpha:1.0f];
    [self updateConstraintsIfNeeded];
    
    //FIX 修复首次初始化页面 页面显示不正确 textView不显示bug
    [self layoutIfNeeded];
}



- (void)showViewWithType:(BOOL)showType{
    if (showType) {
        self.textView.text = self.inputText;
        [self textViewDidChange:self.textView];
        self.inputText = nil;
    }
}


- (void)sendButtonAction:(UIButton *)sender{
    [self sendTextMessage:self.textView.text];
}

/**
 *  发送普通的文本信息,通知代理
 *
 *  @param text 发送的文本信息
 */
- (void)sendTextMessage:(NSString *)text{
    NSLog(@"%@",text);
    if (!text || text.length == 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
        [self.delegate chatBar:self sendMessage:text];
    }
    self.inputText = @"";
    self.textView.text = @"";
    [self setFrame:CGRectMake(0, self.screenHeight - self.bottomHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
    [self showViewWithType:YES];
}


- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.frame = CGRectZero;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
        _textView.placeholder = @"说些什么吧";
    }
    return _textView;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"发表" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        _sendButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
//        _sendButton.layer.borderWidth = .5f;
//        _sendButton.backgroundColor = [UIColor blueColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitleColor:Base_Orange forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (void)addAtNameMessage:(NSString *)nameString{
    NSString * tex = _textView.text;
    tex = [tex stringByAppendingString:[NSString stringWithFormat:@"@%@ ",nameString]];
    _textView.text = tex;
    [self textViewDidChange:self.textView];
}

- (CGFloat)screenHeight{
    return [[UIApplication sharedApplication] keyWindow].bounds.size.height-64;
}

- (CGFloat)bottomHeight{
    return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
}


#pragma mark - Getters

- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    NSLog(@"%f",frame.origin.y);
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            [self setFrame:frame];
        }];
    }else{
        [self setFrame:frame];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:frame:)]) {
        [self.delegate chatBarFrameDidChange:self frame:frame];
    }
}

@end
