//
//  NFCMessageDecoder.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import CoreNFC

enum PayloadType: String {
    case text = "T"
    case uri = "U"
    case unkown
    
    init(rawValue: String) {
        switch rawValue {
        case "U": self = .uri
        case "T": self = .text
        default: self = .unkown
        }
    }
}

class NFCMessageDecoder {
    
    func decode(_ message: NFCNDEFMessage) -> [String] {
        return message.records.compactMap { record in
            return self.decode(record)
        }
    }
    
    private func decode(_ record: NFCNDEFPayload) -> String? {
        let type = PayloadType(rawValue: record.type.decode())
        switch type {
        case .uri:
            return record.wellKnownTypeURIPayload()?.absoluteString
        case .text:
            return record.wellKnownTypeTextPayload().0
        default:
            return nil
        }
    }
}
