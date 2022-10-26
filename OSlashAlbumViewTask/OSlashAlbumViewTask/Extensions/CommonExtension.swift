//
//  CommonExtension.swift
//  OSlashAlbumViewTask
//
//  Created by Dilip on 25/10/22.
//

import UIKit

extension UIImageView {

 public func imageFromServerURL(urlString: String) {


        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
    
}
