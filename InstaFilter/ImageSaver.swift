//
//  ImageSaver.swift
//  InstaFilter
//
//  Created by A.f. Adib on 12/22/23.
//

import UIKit

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler : ((Error) -> Void)?
    
    func writePhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image : UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
       
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
