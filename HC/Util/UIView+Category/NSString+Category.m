//
//  NSString+Category.m
//  House
//
//  Created by apple on 2021/8/17.
//

#import "NSString+Category.h"

#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Category)


//去掉空格
- (NSString *)RemoveTheBlankSpace:(NSString *)spaceStr{
    return [spaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//姓名的隐藏
- (NSString *)getNameEncryption:(NSString *)name{
    if (name.length == 0) return @"";
    else if (name.length == 2) {
        return [NSString stringWithFormat:@"%@*",[name substringToIndex:1]];
    }
    else {
        NSString *string1 = [name substringToIndex:name.length-1];//截取掉下标之后的字符串
        NSString *string2 = [string1 substringFromIndex:1];//截取掉下标之前的字符串
        NSString *str = @"*";
        for (int i = 0; i < string2.length; i++) {
            if (i < 3 && i > 0) {
                str = [NSString stringWithFormat:@"*%@",str];
            }
        }
        NSString *strUrl = [name stringByReplacingOccurrencesOfString:string2 withString:str];
        return strUrl;
    }
}
//姓名的长度
- (NSString *)getNamelength:(NSString *)name{
    if (name.length == 0) return @"";
    else if (name.length > 4) {
        //截取掉下标之前的字符串
        return [NSString stringWithFormat:@"%@*",[name substringToIndex:4]];
    }
    return name;
}
//整10判断
+ (BOOL)isTheWholeTen:(NSString *)digital{
    if([digital containsString:@"."]){
        return NO;
    }else{
        NSLog(@"%@",[digital substringFromIndex:digital.length-1]);
        if ([[digital substringFromIndex:digital.length-1] isEqualToString:@"0"]) {
            return YES;
        }else{
            return NO;
        }
    }
}
// 将秒转换为时间,含天数
+ (NSString *)secondTransToDate:(NSInteger)totalSecond{
    NSInteger second = totalSecond % 60;
    NSInteger minute = (totalSecond / 60) % 60;
    NSInteger hours = (totalSecond / 3600) % 24;
    NSInteger days = totalSecond / (24*3600);
    //初始化
    NSString *secondStr = [NSString stringWithFormat:@"%ld",(long)second];
    NSString *minuteStr = [NSString stringWithFormat:@"%ld",(long)minute];
    NSString *hoursStr = [NSString stringWithFormat:@"%ld",(long)hours];
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)days];
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld",(long)second];
    }
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    if (hours < 10) {
        hoursStr = [NSString stringWithFormat:@"0%ld",(long)hours];
    }
    if (days < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)days];
    }
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    }
    if (days <= 0) {
        return [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minuteStr,secondStr];
    }
    return [NSString stringWithFormat:@"%@:%@:%@:%@",dayStr,hoursStr,minuteStr,secondStr];
}

+ (BOOL)isBlankString:(NSString *)aStr{
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    if ([aStr isEqualToString:@"(null)"]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}


+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum
{
    if (phoneNum.length==11) {
        NSMutableString *newStr = [NSMutableString stringWithString:phoneNum];
        NSRange range = NSMakeRange(3, 4);
        [newStr replaceCharactersInRange:range withString:@"*****"];
        return newStr;
    }
    return nil;
}
- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length {
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}
+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo
{
    NSMutableString *newStr = [NSMutableString stringWithString:accountNo];
    NSRange range = NSMakeRange(4, 8);
    if (newStr.length>12) {
        [newStr replaceCharactersInRange:range withString:@" **** **** "];
    }
    return newStr;
}

+ (NSString*) stringMobileFormat:(NSString *)mobile {
    if (mobile.length==11) {
        NSMutableString* value = [[NSMutableString alloc] initWithString:mobile];
        [value insertString:@"-" atIndex:3];
        [value insertString:@"-" atIndex:8];
        return value;
    }
    
    return nil;
}

+ (NSString*) stringChineseFormat:(double)value{
    
    if (value / 100000000 >= 1) {
        return [NSString stringWithFormat:@"%.2f亿",value/100000000];
    }
    else if (value / 10000 >= 1 && value / 100000000 < 1) {
        return [NSString stringWithFormat:@"%.2f万",value/10000];
    }
    else {
        return [NSString stringWithFormat:@"%.2f",value];
    }
}

+(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSMutableString *temp = [NSMutableString stringWithString:num];
    NSRange afterPointRange=NSMakeRange(num.length-3, 3);
    NSString * afterPoint=[temp substringWithRange:afterPointRange];
    [temp deleteCharactersInRange:afterPointRange];
    
    int count = 0;
    long long int a = temp.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:temp];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    [newstring insertString:afterPoint atIndex:newstring.length];
    return newstring;
}

-(CGFloat)heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

- (CGFloat) widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [self boundingRectWithSize:CGSizeMake(0, maxHeight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}

- (NSNumber*)toNumber
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number=[formatter numberFromString:self];
    return number;
}

/*抹除运费小数末尾的0*/
- (NSString *)removeUnwantedZero {
    
    if ([[self substringWithRange:NSMakeRange(self.length- 6, 6)] isEqualToString:@"000000"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-7)]; // 多一个小数点
    } else if ([[self substringWithRange:NSMakeRange(self.length- 3, 3)] isEqualToString:@"000"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-4)]; // 多一个小数点
    } else if ([[self substringWithRange:NSMakeRange(self.length- 2, 2)] isEqualToString:@"00"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-2)];
    } else if ([[self substringWithRange:NSMakeRange(self.length- 1, 1)] isEqualToString:@"0"]) {
        return [self substringWithRange:NSMakeRange(0, self.length-1)];
    } else {
        return self;
    }
}

//去掉前后空格
- (NSString *)trimmedString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
}

+ (NSString *)base64EncodeString:(NSString *)string {
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)base64DecodeString:(NSString *)string {
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

+  (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font ,NSParagraphStyleAttributeName:paragraphStyle}
                                           context:nil];
    return sizeToFit.size.height;
}

+ (CGFloat) widthForString:(NSString *)value fontSize:(CGFloat)fontSize andHight:(CGFloat)hight{
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, hight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font ,NSParagraphStyleAttributeName:paragraphStyle}
                                           context:nil];
    return sizeToFit.size.width;
    
}

- (BOOL)SJZL_isPhone {
    //手机号开头：13 14 15 17 18 @"^1+[34578]+\\d{9}"
    //手机号开头：1 + 10位 @"^1+\\d{10}"
    NSString *regex = @"1\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
//    if (self.length <= 0) {
//        CGSize sizee = CGSizeMake(0.01f, 0.01f);
//        return sizee;
//    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andlineSpacing:(CGFloat) lineSpaceing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineSpacing = lineSpaceing;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName : font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize originSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSString *test = @"我们";
    CGSize wordSize = [test sizeWithFont:font maxSize:maxSize];
    
    CGFloat selfHeight = [self sizeWithFont:font maxSize:maxSize].height;
    
    if (selfHeight <= wordSize.height) {
        
        CGSize newSize = CGSizeMake(originSize.width, font.pointSize);
        
        if (selfHeight == 0) {
            
            newSize = CGSizeMake(originSize.width, 0);
        }
        
        originSize = newSize;
    }
    
    return originSize;
}


#pragma mark - MD5加密 32位 大写
+ (NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [[NSString stringWithFormat:@"%@HengchUang33@",str] UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

@end
