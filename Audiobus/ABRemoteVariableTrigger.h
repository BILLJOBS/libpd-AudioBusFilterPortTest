//
//  ABRemoteVariableTrigger.h
//  Audiobus
//
//  Created by Michael Tyson on 30/08/2013.
//  Copyright (c) 2013 A Tasty Pixel. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif

#import "ABRemoteTrigger.h"
#import "ABVariableTrigger.h"

/*!
 * Remote variable trigger
 *
 *  This class provides a remote representation for triggers published by other peers
 *  which can take a range of values, represented by a slider or a dial. The value property
 *  can be modified, altering the state at the other end.
 */
@interface ABRemoteVariableTrigger : ABRemoteTrigger

@property (nonatomic, assign) float value;              //!< The current value
@property (nonatomic, readonly) float maximumValue;     //!< The maximum possible value
@property (nonatomic, readonly) float minimumValue;     //!< The minimum possible value
@property (nonatomic, retain, readonly) UIImage *maximumImage;    //!< Icon to be displayed at the maximum end of the slider (does not apply to dial display mode)
@property (nonatomic, retain, readonly) UIImage *minimumImage;    //!< Icon to be displayed at the minimum end of the slider (does not apply to dial display mode)
@property (nonatomic, retain, readonly) NSString *title;//!< The trigger title
@property (nonatomic, readonly) ABVariableTriggerDisplayType displayType; //!< How the trigger should be displayed

@end

    
#ifdef __cplusplus
}
#endif