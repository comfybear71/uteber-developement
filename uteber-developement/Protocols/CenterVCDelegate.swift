//
//  CenterVCDelegate.swift
//  uteber-developement
//
//  Created by Stu on 25/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}


