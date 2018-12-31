//
//  RichTextViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "RichTextViewController.h"

@interface RichTextViewController ()

@end

@implementation RichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testHtml];
}

#pragma mark - UILabel 显示HTML富文本

-(void)testHtml{
    NSString *html=@"<div style=\"text-align: center;\"><b><font size=\"7\">歪？来拿红包了喂</font></b></div><div style=\"text-align: center;\"><font size=\"5\"><span style=\"color: rgb(57, 181, 74);\"><u><b><i>嗯哼</i></b></u></span></font></div><div style=\"text-align: left;\"><font size=\"5\"><span style=\"color: rgb(57, 181, 74);\"><u><b><i>66666</i></b></u></span></font></div><div style=\"text-align: right;\"><b><i><span style=\"color: rgb(71, 186, 254);\"><u><font size=\"7\">456799494</font></u></span></i></b></div><div style=\"text-align: center;\"><b><font size=\"4\"><span style=\"color: rgb(237, 35, 8);\">哈哈哈哈我的心情是好开心哈哈你自己知道吧哈哈哈哈哈哈</span></font></b></div>";
    html = [self changeHtmlStrFontSize:html];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [self _fixHtmlStrItalicFont:html AttributedString:attrStr];
    
    UILabel * myLabel = [[UILabel alloc] init];
    myLabel.attributedText = attrStr;
    myLabel.numberOfLines=0;
    myLabel.frame=CGRectMake(20, TLTopMargin(84.f), [UIScreen mainScreen].bounds.size.width-40, 150);
    [myLabel sizeToFit];
    [self.view addSubview:myLabel];
    NSLog(@"%.2f",myLabel.frame.size.height);

    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, MAXFLOAT);
    CGRect rect = [attrStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    NSLog(@"height::%.2f",rect.size.height);
}

#pragma mark - 辅助方法

/* 计算NSData的大小 */
- (void)_calulateFileSize:(NSData *)data {
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"data length is 【 %.3f 】【 %@ 】",dataLength,typeArray[index]);
}

-(void)_fixHtmlStrItalicFont:(NSString *)htmlStr AttributedString:(NSMutableAttributedString *)attributedString{
    
    /* 需要查找的字符串，加入正则 */
    NSString *searchStr = @"<i>.*?</i>";
    /* 第一次查找 */
    NSRange range = [htmlStr rangeOfString:searchStr options:NSRegularExpressionSearch range:NSMakeRange(0, htmlStr.length)];
    /* 循环查找 */
    while (range.location != NSNotFound) {
        /*  */
        NSInteger location = range.location + range.length;
        /* 取得文本的内容 */
        NSString *textContent = [htmlStr substringWithRange:range];
        /* 过滤html标签 */
        textContent = [self filterHTML:textContent];
        /* 取得内容字符串在attributedString.string中的位置 */
        NSRange textContentRange = [attributedString.string rangeOfString:textContent];
        /* 添加倾斜度 */
        [attributedString addAttribute:NSObliquenessAttributeName value:@.2 range:textContentRange];
        /* 继续查找后面的字符串 */
        range = [htmlStr rangeOfString:searchStr options:NSRegularExpressionSearch range:NSMakeRange(location, htmlStr.length - location)];
    }
}

/* 加大字体大小 */
-(NSString *)changeHtmlStrFontSize:(NSString *)htmlStr{
    
    /* 创建一份可变的字符串 */
    NSMutableString *newHtmlStr = [NSMutableString stringWithString:htmlStr];
    /* 需要查找的字符串 */
    NSString *searchStr = @"font.size=\".\"";
    /* 第一次查找 */
    NSRange range = [newHtmlStr rangeOfString:searchStr options:NSRegularExpressionSearch range:NSMakeRange(0, newHtmlStr.length)];
    /* 循环查找 */
    while (range.location != NSNotFound) {
        NSInteger location = range.location + range.length - 2;
        /* 取出后面的一位字符 */
        NSString *fontSizeStr = [newHtmlStr substringWithRange:NSMakeRange(location, 1)];
        if ([self isPureInt:fontSizeStr]) {
            /* 字符里面是整形 */
            NSInteger fontSize = [fontSizeStr integerValue];
            /* 字体大小加一 */
            NSString *str = [NSString stringWithFormat:@"%zd",fontSize+1];
            /* 替换字符串 */
            [newHtmlStr replaceCharactersInRange:NSMakeRange(location, 1)  withString:str];
        }
        /* 继续查找后面的字符串 */
        range = [newHtmlStr rangeOfString:searchStr options:NSRegularExpressionSearch range:NSMakeRange(location, newHtmlStr.length-location)];
    }
    return [NSString stringWithFormat:@"%@",newHtmlStr];
}

/* 判断是否为整形 */
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/* 判断是否为浮点形 */
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/* 过滤HTML标签 */
-(NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

@end
