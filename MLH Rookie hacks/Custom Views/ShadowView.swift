//
//  ShadowView.swift
//  Shopper
//
//  Created by Phani Srikar on 10/02/19.
//  Copyright © 2019 Phani Srikar. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {
    
    override func prepareForInterfaceBuilder() {
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius = 18
       
    }
    
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius = 18
        super.awakeFromNib()
    }

}
