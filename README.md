SSACreditCardValidator
======================

A simple creditcard validation class


![My image](https://github.com/SSA111/SSACreditCardValidator/blob/master/SSACreditCardValidator/Image.png?raw=true)


## VALIDATION METHODS

```
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

```

##Thanks
[Luhn Validation Code](https://github.com/MaxKramer/ObjectiveLuhn)

##License
This project is licensed under the MIT license.
