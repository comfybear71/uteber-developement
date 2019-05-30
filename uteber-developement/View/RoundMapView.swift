//
//  RoundMapView.swift
//  uteber-developement
//
//  Created by Stu on 26/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit
import MapKit


class RoundMapView: MKMapView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 10.0
    }

}
