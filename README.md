SSACreditCardValidator
======================

A simple creditcard validation class


![My image](https://github.com/SSA111/SSACreditCardValidator/blob/master/SSACreditCardValidator/Image.png)

 ```
 
+ (BOOL)isLuhnValidString:(NSString *)cardNumber forType:(SSACreditCardType)type;
+ (BOOL)isLuhnValidString:(NSString *)cardNumber;
+ (BOOL)isValidCardExpiry:(NSString *)expiryDate;
+ (BOOL)isValidCVV:(NSString *)CCV withCreditCardNumber:(NSString *)cardNumber;
+ (NSString *)maskCreditCardNumberWithString:(NSString *)string; 
+ (NSString *)creditCardTypeFromType:(SSACreditCardType)type;
+ (NSArray *)splitExpiryDateWithDate:(NSString *)date;
+ (SSACreditCardType)creditCardTypeFromString:(NSString *)cardNumber;
 
  ```