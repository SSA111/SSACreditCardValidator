//
//  ViewController.h
//  SSACreditCardValidator
//
//  Created by Sebastian Andersen on 05/06/14.
//  Copyright (c) 2014 Sebastian Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, weak) IBOutlet UITextField *luhnValidationTextField;
@property (nonatomic, weak) IBOutlet UITextField *cardExpiryDateValidationTextField;
@property (nonatomic, weak) IBOutlet UITextField *CVVValidationTextField;
@property (nonatomic, weak) IBOutlet UITextField *getTypeTextField;
@property (nonatomic, weak) IBOutlet UITextField *maskCreditCardTextField;
@property (nonatomic, weak) IBOutlet UILabel *typeFromCardNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *maskedCreditCardLabel;
@property (nonatomic, weak) IBOutlet UILabel *luhnLabel;
@property (nonatomic, weak) IBOutlet UILabel *expiryLabel;
@property (nonatomic, weak) IBOutlet UILabel *ccvLabel;

@end
