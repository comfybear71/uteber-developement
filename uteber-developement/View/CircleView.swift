//
//  CircleView.swift
//  uteber-developement
//
//  Created by Stu on 25/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    @IBInspectable var borderColor: UIColor?{
        didSet{
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor
    }

}
