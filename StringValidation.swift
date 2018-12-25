//
//  StringValidation.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 26/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import Foundation


extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty)
        {
            return true
        }
        return (self.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }
}


//func onlyBottomRounded (view : UIView) -> CAShapeLayer
//{
//    var maskPath : UIBezierPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight, cornerRadii: screenWidth * 0.01 , screenHeight * 0.01)
//    
//    
//}
//

//
//+(CAShapeLayer *)onlyBottomRounded:(UIView *)view
//{
//    
//    // Create the path (with only the top-left corner rounded)
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
//        byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
//        cornerRadii:CGSizeMake(ScreenWidth*0.01, ScreenWidth*0.01)];
//    // Create the shape layer and set its path
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    return maskLayer;
//}

//+(CAShapeLayer *)onlyTopRounded:(UIView *)view
//{
//    
//    // Create the path (with only the top-left corner rounded)
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
//        byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//        cornerRadii:CGSizeMake(ScreenWidth*0.01, ScreenWidth*0.01)];
//    // Create the shape layer and set its path
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    return maskLayer;
//}
