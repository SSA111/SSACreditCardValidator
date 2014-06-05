//
//  ViewController.m
//  SSACreditCardValidator
//
//  Created by Sebastian Andersen on 05/06/14.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

#import "ViewController.h"
#import "SSACreditCardValidator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    BOOL isValid;
    
    if (textField == self.luhnValidationTextField) {
        isValid = [self.luhnValidationTextField.text isValidCreditCardNumber];
        
        self.luhnLabel.text = [NSString stringWithFormat:@"Valid: %@", isValid && self.luhnValidationTextField.text.length > 0 ? @"✓" : @"✕"];
        self.luhnLabel.textColor = isValid ? [UIColor greenColor] : [UIColor redColor];
        
    }else if (textField == self.cardExpiryDateValidationTextField) {
        
        isValid = [self.cardExpiryDateValidationTextField.text isCardExpired];
        
        self.expiryLabel.text = [NSString stringWithFormat:@"Valid: %@", isValid && self.cardExpiryDateValidationTextField.text.length > 0 ? @"✕" : @"✓"];
        self.expiryLabel.textColor = isValid ?  [UIColor redColor] : [UIColor greenColor];
        
    }else if (textField == self.CVVValidationTextField) {
        
        isValid = [self.CVVValidationTextField.text isCVVValidWithCardNumber:self.luhnValidationTextField.text];
        
        self.ccvLabel.text = [NSString stringWithFormat:@"Valid: %@", isValid && self.CVVValidationTextField.text.length > 0 && self.luhnValidationTextField.text.length > 0 ? @"✓" : @"✕"];
        self.ccvLabel.textColor = isValid ? [UIColor greenColor] : [UIColor redColor] ;
        
    }else if (textField == self.getTypeTextField) {
        
        NSString *type = [self.getTypeTextField.text creditCardTypeString];
        self.typeFromCardNumberLabel.text = type;
        
    }else if (textField == self.maskCreditCardTextField) {
        NSString *maskedCC = [self.maskCreditCardTextField.text maskCreditCardNumber];
        self.maskedCreditCardLabel.text = maskedCC;
    }
    
    
    return [textField resignFirstResponder]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
