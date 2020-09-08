//
//  NFCWriter.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import CoreNFC

class NFCWriter: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession? = nil
    private var message: NFCNDEFMessage? = nil
    
    func write(_ message: NFCNDEFMessage) {
        self.message = message
        beginSession()
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("A sessão foi invalida: \(error.localizedDescription)")
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("A sessão está ativa!")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This is never called when implementing `readerSession:didDetectTags`
    }
    
    @available(iOS 13.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "A TAG NFC Está vazio!")
            return
        }
        guard let message = self.message else {
            session.invalidate(errorMessage: "Mensagem inválida")
            return
        }
        
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Erro de conexão. Por favor, tente novamente.")
                return
            }
            self.write(message, to: tag)
        }
    }
    
    // MARK: - Private
    
    private func beginSession() {
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    @available(iOS 13.0, *)
    private func write(_ message: NFCNDEFMessage, to tag: NFCNDEFTag) {
        tag.queryNDEFStatus() { (status: NFCNDEFStatus, _, error: Error?) in
            guard status == .readWrite else {
                self.session?.invalidate(errorMessage: "Tag é inválida.")
                return
            }
            
            tag.writeNDEF(message) { (error: Error?) in
                if (error != nil) {
                    self.session?.invalidate(errorMessage: error?.localizedDescription ?? "Houve um erro!")
                }
                self.session?.alertMessage = "Mensagem salva com sucesso"
                self.session?.invalidate()
            }
        }
    }
}
