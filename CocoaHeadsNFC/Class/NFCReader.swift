//
//  NFCReader.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import CoreNFC

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession? = nil
    private var message: NFCNDEFMessage? = nil
    private var successReading: ((NFCNDEFMessage) -> ())?
    
    func read(succes: ((NFCNDEFMessage) -> ())?) {
        beginSession()
        successReading = succes
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("A sessão foi invalida: \(error.localizedDescription)")
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("A sessão está ativa!")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {

        guard let message = messages.first else {
            self.session?.invalidate(errorMessage: "A TAG NFC Está vazio!")
            return
        }
        self.successReading?(message)
        self.session?.alertMessage = "TAG NFC Lida com sucesso!"
        self.session?.invalidate()
    }
    
    @available(iOS 13.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Não foi possível ler a tag")
            return
        }
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Erro de conexão. Por favor, tente novamente.")
                return
            }
            self.read(tag)
        }
    }
    
    // MARK: - Private
    
    private func beginSession() {
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    private func read(_ tag: NFCNDEFTag) {
        tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
            guard error == nil else {
                self.session?.invalidate(errorMessage: error!.localizedDescription)
                return
            }
            guard let message = message else {
                self.session?.invalidate(errorMessage: "Tag é inválida.")
                return
            }
            self.successReading?(message)
            self.session?.alertMessage = "TAG NFC Lida com sucesso!"
            self.session?.invalidate()
        }
    }
}
