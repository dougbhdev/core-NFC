//
//  UIView+extension.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    _ = views.map({ self.addSubview($0) })
  }
}
