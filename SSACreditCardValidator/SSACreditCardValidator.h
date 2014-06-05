//
//  SSACreditCardValidator.h
//
//  Created by Sebastian Andersen on 1/6/2014.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SSACreditCardType) {
    
    //Credit Cards
    SSACreditCardTypeAmex,
    SSACreditCardTypeVisa,
    SSACreditCardTypeMasterCard,
    SSACreditCardTypeDiscover,
    SSACreditCardTypeDinersClub,
    SSACreditCardTypeJCB,
    
    //Debit Cards
    SSACreditCardTypeDankort,
    SSACreditCardTypeMaestro,
    SSACreditCardTypeLaser,
    SSACreditCardTypeVisaElectron,
    SSACreditCardTypeSolo,
    SSACreditCardTypeSwitch,
    SSACreditCardTypeForbrugsforeningen,
    
    //Error
    SSACreditCardTypeUnsupported,
    SSACreditCardTypeInvalid
};

@interface SSACreditCardValidator : NSObject

+ (BOOL)isLuhnValidString:(NSString *)cardNumber forType:(SSACreditCardType)type;
+ (BOOL)isLuhnValidString:(NSString *)cardNumber;
+ (BOOL)isValidCardExpiry:(NSString *)expiryDate;
+ (BOOL)isValidCVV:(NSString *)CCV withCreditCardNumber:(NSString *)cardNumber;
+ (NSString *)maskCreditCardNumberWithString:(NSString *)string; 
+ (NSString *)creditCardTypeFromType:(SSACreditCardType)type;
+ (NSArray *)splitExpiryDateWithDate:(NSString *)date;
+ (SSACreditCardType)creditCardTypeFromString:(NSString *)cardNumber;

@end

@interface NSString (SSACreditCardValidator)

- (BOOL)isValidCreditCardNumber;
- (BOOL)isCardExpired;
- (BOOL)isCVVValidWithCardNumber:(NSString *)cardNumber;
- (NSString *)creditCardTypeString;
- (NSString *)maskCreditCardNumber;
- (NSArray *)splitExpiryDate;
- (SSACreditCardType)creditCardType;

@end


