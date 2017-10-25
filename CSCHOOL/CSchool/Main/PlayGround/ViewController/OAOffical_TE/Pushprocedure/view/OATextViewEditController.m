//
//  OATextViewEditController.m
//  CSchool
//
//  Created by mac on 17/6/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OATextViewEditController.h"
#import "YYText.h"
#import "YYImage.h"
#import "UIView+YYAdd.h"

#define kSystemVersion YYDeviceSystemVersion()

#define kiOS7Later (kSystemVersion >= 7)

@interface OATextViewEditController ()<YYTextViewDelegate, YYTextKeyboardObserver,UITextViewDelegate>
@property (nonatomic, assign) YYTextView *textView;

@end

@implementation OATextViewEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    self.title = _placeholderText;
}
-(void)setMaxWordCount:(int)maxWordCount
{
    _maxWordCount = maxWordCount;
    if (!_maxWordCount) {
        self.maxWordCount = 10000;
    }
}
-(void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    if (_placeholderText.length==0||!_placeholderText) {
        _placeholderText = @"请输入正文...";
    }
}
-(void)setContentText:(NSString *)contentText{
    _contentText = contentText;
    
    self.textView.text = contentText;
}
-(void)createView
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" "];
    text.yy_font = [UIFont fontWithName:@"Times New Roman" size:16];
    text.yy_lineSpacing = 4;
    text.yy_firstLineHeadIndent = 20;
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = text;
    textView.text =_contentText;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        textView.height -= 64;
    }
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(_contentText.length, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];

}
- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}
- (void)edit:(UIBarButtonItem *)item {
    if (self.OAtextViewEditBlock) {
        self.OAtextViewEditBlock(self.textView.text);
    }
    
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark text view

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark textField的字数限制
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxWordCount )
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.maxWordCount];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
//    self.textView.text = [NSString stringWithFormat:@"%ld",MAX(0,self.maxWordCount  - existTextNum)];

}
#pragma mark 超过30字不能输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < self.maxWordCount ) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = self.maxWordCount - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        [ProgressHUD showError:[NSString stringWithFormat:@"最多输入%d个字",self.maxWordCount]];
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textView.text = [NSString stringWithFormat:@"%d",0];
        }
        return NO;
    }
}

#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
