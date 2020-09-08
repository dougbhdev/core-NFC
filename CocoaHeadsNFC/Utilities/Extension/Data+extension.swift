//
//  Data+extension.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import UIKit
import Foundation

extension Data {
    
    func decode(skipping bytes: Int) -> String {
        guard let message = String(data: self.advanced(by: bytes), encoding: .utf8) else {
            return ""
        }
        return message
    }
    
    func decode() -> String {
        guard let message = String(data: self, encoding: .utf8) else {
            return ""
        }
        return message
    }
}

