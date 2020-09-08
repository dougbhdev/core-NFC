//
//  ViewController.swift
//  CocoaHeadsNFC
//
//  Created by Douglas  Goulart Nunes on 07/12/19.
//  Copyright © 2019 Douglas Nunes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let encoder = NFCMessageEncoder()
    private let decoder = NFCMessageDecoder()
    private let writer = NFCWriter()
    private let reader = NFCReader()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gravar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(writeTag), for: .touchUpInside)
        return button
    }()
    
    lazy var readerButton: UIButton = {
           let button = UIButton()
           button.setTitle("Ler", for: .normal)
           button.setTitleColor(.black, for: .normal)
           button.backgroundColor = .green
           button.layer.cornerRadius = 25
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(readerTag(_:)), for: .touchUpInside)
           return button
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubviews(writeButton, readerButton)
        configureConstraintElements()
        
    }
    
    // MARK: Method private
    private func configureConstraintElements() {
           writeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
           writeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
           writeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           writeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           
           readerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
           readerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
           readerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           readerButton.bottomAnchor.constraint(equalTo: writeButton.bottomAnchor, constant: 60).isActive = true
    }
    
    @objc func readerTag(_ sender: UIButton) {
        
        reader.read { message in
            let song = self.decoder.decode(message)
            print(song)
        }
        
    }
    
    
    @objc func writeTag(_ sender: UIButton) {
        
        var urlPath: String = String()
        
        let alert = UIAlertController(title: "NFC", message: "Selecione uma opção", preferredStyle: .actionSheet)

          alert.addAction(UIAlertAction(title: "Facetime", style: .default , handler:{ (UIAlertAction) in
                urlPath = "facetime://dougbhdev@gmail.com"
                self.callNFCWrite(urlPath: urlPath)
          }))

          alert.addAction(UIAlertAction(title: "SMS", style: .default , handler:{ (UIAlertAction) in
                urlPath = "sms:+5531992228990"
                self.callNFCWrite(urlPath: urlPath)
          }))

          alert.addAction(UIAlertAction(title: "E-mail", style: .default , handler:{ (UIAlertAction) in
              urlPath = "mailto:dougbhdev@gmail.com"
              self.callNFCWrite(urlPath: urlPath)
          }))
        
        alert.addAction(UIAlertAction(title: "Spotify", style: .default , handler:{ (UIAlertAction) in
            urlPath = "spotify:track:44pxxRrhiDGuHYP5HjadGF"
            self.callNFCWrite(urlPath: urlPath)
        }))
        
        alert.addAction(UIAlertAction(title: "Website URL", style: .default , handler:{ (UIAlertAction) in
            urlPath = "https://www.cocoaheads.com.br"
            self.callNFCWrite(urlPath: urlPath)
        }))
        
        alert.addAction(UIAlertAction(title: "Linkedin", style: .default , handler:{ (UIAlertAction) in
            urlPath = "https://www.linkedin.com/in/douglas-henrique-53943316/"
            self.callNFCWrite(urlPath: urlPath)
        }))
        
        alert.addAction(UIAlertAction(title: "google Maps", style: .default , handler:{ (UIAlertAction) in
            urlPath = "comgooglemaps://?center=-19.8993,-43.9570&zoom=14&views=traffic"
            self.callNFCWrite(urlPath: urlPath)
        }))

          alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction) in
              print("😎")
          }))
        

          self.present(alert, animated: true, completion: {
              print("😎")
          })
        
    }
    
    private func callNFCWrite(urlPath: String) {
                   
               if let url = URL(string: urlPath) {
                   
                   guard let message = encoder.message(with: [url]) else {
                       return
                   }
           
                   writer.write(message)
               }
    }


}

