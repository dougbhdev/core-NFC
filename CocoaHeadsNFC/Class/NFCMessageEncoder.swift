//
//  NFCMessageEncoder.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import CoreNFC

class NFCMessageEncoder {
    
    func message(with url: URL) -> NFCNDEFMessage? {
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            return nil
        }
        return NFCNDEFMessage(records: [payload])
    }
    
    func message(with text: String) -> NFCNDEFMessage? {
        guard let payload = NFCNDEFPayload.wellKnownTypeTextPayload(
            string: text,
            locale: Locale(identifier: "pt_BR")) else {
            return nil
        }
        return NFCNDEFMessage(records: [payload])
    }
    
    func message(with url: URL, and text: String) -> NFCNDEFMessage? {
        guard let urlPayload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            return nil
        }
        guard let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
            string: text,
            locale: Locale(identifier: "pt_BR")) else {
            return nil
        }
        return NFCNDEFMessage(records: [urlPayload, textPayload])
    }
    
    func message(with texts: [String]) -> NFCNDEFMessage? {
        let payloads = self.payloads(from: texts)
        return (payloads.count > 0) ? NFCNDEFMessage(records: payloads) : nil
    }
    
    func message(with urls: [URL]) -> NFCNDEFMessage? {
        let payloads = self.payloads(from: urls)
        return (payloads.count > 0) ? NFCNDEFMessage(records: payloads) : nil
    }
    
    func message(with urls: [URL], and texts: [String]) -> NFCNDEFMessage? {
        let payloads = self.payloads(from: texts) + self.payloads(from: urls)
        return (payloads.count > 0) ? NFCNDEFMessage(records: payloads) : nil
    }
    
    // MARK: - Private
    
    func payloads(from texts: [String]) -> [NFCNDEFPayload] {
        return texts.compactMap { text in
            return NFCNDEFPayload.wellKnownTypeTextPayload(
                string: text,
                locale: Locale(identifier: "pt_BR")
            )
        }
    }
    
    func payloads(from urls: [URL]) -> [NFCNDEFPayload] {
        return urls.compactMap { url in
            return NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
        }
    }
}
