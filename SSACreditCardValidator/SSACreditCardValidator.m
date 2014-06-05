//
//  SSACreditCardValidator.m
//
//  Created by Sebastian Andersen on 1/6/2014.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

#import "SSACreditCardValidator.h"

@interface NSString (SSACreditCardValidator_Private)

- (NSString *)forValidation;

@end

@implementation NSString (SSACreditCardValidator_Private)

- (NSString *)forValidation {
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

@end

@implementation NSString (SSACreditCardValidator)


- (BOOL)isValidCreditCardNumber {
    return [SSACreditCardValidator isLuhnValidString:self];
}

- (BOOL)isCardExpired {
    
    return [SSACreditCardValidator isValidCardExpiry:self];
    
}

- (BOOL)isCVVValidWithCardNumber:(NSString *)cardNumber {
    
    return [SSACreditCardValidator isValidCVV:self withCreditCardNumber:cardNumber];
}

- (NSString *)maskCreditCardNumber {
    
    return [SSACreditCardValidator maskCreditCardNumberWithString:self];
    
}
- (NSArray *)splitExpiryDate {
    
    return [SSACreditCardValidator splitExpiryDateWithDate:self];
}

- (NSString *)creditCardTypeString {
    
    return [SSACreditCardValidator creditCardTypeFromType:[self creditCardType]];
}


- (SSACreditCardType)creditCardType {
    return [SSACreditCardValidator creditCardTypeFromString:self];
}

@end


@implementation SSACreditCardValidator

+ (SSACreditCardType)creditCardTypeFromString:(NSString *)cardNumber {
    BOOL valid = [cardNumber isValidCreditCardNumber];
    if (!valid) {
        return SSACreditCardTypeInvalid;
    }
    
    NSString *formattedString = [cardNumber forValidation];
    if (formattedString == nil || formattedString.length < 9) {
        return SSACreditCardTypeInvalid;
    }
    
    NSArray *enums = @[@(SSACreditCardTypeAmex), @(SSACreditCardTypeDinersClub), @(SSACreditCardTypeDiscover), @(SSACreditCardTypeJCB), @(SSACreditCardTypeMasterCard), @(SSACreditCardTypeVisa), @(SSACreditCardTypeLaser), @(SSACreditCardTypeVisaElectron), @(SSACreditCardTypeDankort), @(SSACreditCardTypeMaestro), @(SSACreditCardTypeSolo), @(SSACreditCardTypeSwitch), @(SSACreditCardTypeForbrugsforeningen)];

    __block SSACreditCardType type = SSACreditCardTypeInvalid;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SSACreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [SSACreditCardValidator predicateForType:_type];
        if ([predicate evaluateWithObject:formattedString]) {
            type = _type;
            *stop = YES;
        }
    }];

    return type;
}

+ (NSPredicate *)predicateForType:(SSACreditCardType) type {
    if (type == SSACreditCardTypeInvalid || type == SSACreditCardTypeUnsupported) {
        return nil;
    }
    NSString *regex = nil;
    switch (type) {
        case SSACreditCardTypeAmex:
            regex = @"^3[47][0-9]{5,}$";
            break;
        case SSACreditCardTypeDinersClub:
            regex = @"^3(?:0[0-5]|[68][0-9])[0-9]{4,}$";
            break;
        case SSACreditCardTypeDiscover:
            regex = @"^6(?:011|5[0-9]{2})[0-9]{3,}$";
            break;
        case SSACreditCardTypeJCB:
            regex = @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$";
            break;
        case SSACreditCardTypeMasterCard:
            regex = @"^5[1-5][0-9]{5,}$";
            break;
        case SSACreditCardTypeVisa:
            regex = @"^4[0-9]{6,}$";
            break;
        case SSACreditCardTypeDankort:
            regex = @"^5019\\d{12}$";
            break;
        case SSACreditCardTypeMaestro:
            regex = @"^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$";
            break;
        case SSACreditCardTypeLaser:
            regex = @"^(6304|6706|6771|6709)\\d{8}(\\d{4}|\\d{6,7})?$";
            break;
        case SSACreditCardTypeVisaElectron:
            regex = @"^(4026|417500|4508|4844|491(3|7))";
            break;
        case SSACreditCardTypeSolo:
            regex = @"^6767\\d{12}(\\d{2,3})?$";
            break;
        case SSACreditCardTypeForbrugsforeningen:
            regex = @"^600722\\d{10}$";
            break;
        case SSACreditCardTypeSwitch:
            regex = @"^6759\\d{12}(\\d{2,3})?$";
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
}

+ (BOOL)isLuhnValidString:(NSString *)cardNumber
{
    NSString *formattedString = [cardNumber forValidation];
    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;

}

+ (BOOL)isLuhnValidString:(NSString *)cardNumber forType:(SSACreditCardType)type {
    return [SSACreditCardValidator creditCardTypeFromString:cardNumber] == type;
}


+ (NSPredicate *)predicateForExpiry {
    
    NSString *regex = @"^((0[1-9])|(1[0-2]))\\/((2009)|(20[1-2][0-9]))$";
    
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

}


+ (NSString *)creditCardTypeFromType:(SSACreditCardType)type {
    
    if (type == SSACreditCardTypeInvalid || type == SSACreditCardTypeUnsupported) {
        return nil;
    }
    NSString *name = nil;
    switch (type) {
        case SSACreditCardTypeAmex:
            name = @"Amex";
            break;
        case SSACreditCardTypeDinersClub:
            name = @"DinersClub";
            break;
        case SSACreditCardTypeDiscover:
            name = @"Discover";
            break;
        case SSACreditCardTypeJCB:
            name = @"JCB";
            break;
        case SSACreditCardTypeMasterCard:
            name = @"MasterCard";
            break;
        case SSACreditCardTypeVisa:
            name = @"Visa";
            break;
        case SSACreditCardTypeDankort:
            name = @"Dankort";
            break;
        case SSACreditCardTypeMaestro:
            name = @"Maestro";
            break;
        case SSACreditCardTypeLaser:
            name = @"Laser";
            break;
        case SSACreditCardTypeVisaElectron:
            name = @"Visa Electron";
            break;
        case SSACreditCardTypeSolo:
            name = @"Solo";
            break;
        case SSACreditCardTypeForbrugsforeningen:
            name = @"Forbrugsforeningen";
            break;
        case SSACreditCardTypeSwitch:
            name = @"Switch";
            break;
        case SSACreditCardTypeInvalid:
            name = @"Invalid";
            break;
        case SSACreditCardTypeUnsupported:
            name = @"Unsupported";
            break;
        default:
            name = @"Unsupported";
            break;
    }
    
    return name;
    
}

+ (BOOL)isValidCardExpiry:(NSString *)expiryDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/yyyy"];
 
    NSPredicate *predicate = [SSACreditCardValidator predicateForExpiry];
    if ([predicate evaluateWithObject:expiryDate]) {
        
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([[dateFormatter dateFromString:expiryDate] compare:[dateFormatter dateFromString:currentDate]] == NSOrderedDescending  || [[dateFormatter dateFromString:expiryDate] compare:[dateFormatter dateFromString:currentDate]] == NSOrderedSame) {
   
            return NO;
           
        }else if ([[dateFormatter dateFromString:expiryDate] compare:[dateFormatter dateFromString:currentDate]] == NSOrderedAscending) {
            
            return YES;
        }
 
    }

    return YES;
   
}


+ (NSString *)maskCreditCardNumberWithString:(NSString *)cardNumber {
    
    NSString *formattedString = [cardNumber forValidation];
    if (formattedString == nil || formattedString.length < 9) {
        return nil;
    }
    
    NSString *maskedNumber;
    NSRange subStringRange = NSMakeRange(0,[formattedString length]-4);
    maskedNumber = [formattedString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[formattedString substringToIndex:subStringRange.length]] withString:[@"" stringByPaddingToLength:subStringRange.length withString:@"X" startingAtIndex:0]];
    
    return maskedNumber;
    
}


+ (NSArray *)splitExpiryDateWithDate:(NSString *)date {
    
    NSMutableString *expDateAndMonth = [date mutableCopy];
    [expDateAndMonth replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, expDateAndMonth.length)];
    NSString *expYear;
    NSString *expMonth;
    if (expDateAndMonth.length == 6) {
        expYear = [expDateAndMonth substringWithRange:NSMakeRange(2, 4)];
        expMonth = [expDateAndMonth substringWithRange:NSMakeRange(0, 2)];
    }
    
    return expYear && expMonth ? @[expMonth, expYear] : nil;
    
}

+ (BOOL)isValidCVV:(NSString *)CCV withCreditCardNumber:(NSString *)cardNumber {
    
    
    NSString *ccvForValidation = [CCV stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    SSACreditCardType cardType = [SSACreditCardValidator creditCardTypeFromString:cardNumber];
    
    if (cardType == SSACreditCardTypeAmex) {
        if (ccvForValidation.length == 4) {
            return YES;
        }else {
            return NO;
        }
    }else {
        if (ccvForValidation.length == 3) {
            return  YES;
        }else {
            return NO;
        }
        
    }
   
    return NO;
    
}


@end