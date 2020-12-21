//
//  Extension.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation
import UIKit

extension UIStoryboard {

    static func instantiateViewController<T: UIViewController>(storyboardName: String = "Main", type: T.Type) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let className = NSStringFromClass(type).split(separator: ".").last!
        return storyboard.instantiateViewController(withIdentifier: String(className)) as? T
    }
}

fileprivate var imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    /// is used to download the images from the server using the URL and stores them in the NSCache
    /// object and returns if the same image is requested
    /// - Parameter urlString: url of the image to be downloaded
    public func setImage(urlString: String) {
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL,
                                   completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            if let data = data {
                DispatchQueue.main.async(execute: { () -> Void in
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: urlString as AnyObject)
                        self.image = image
                    } else {
                        self.image = UIImage(named: "Some dummy image")
                    }
                })
            }
        }).resume()
    }
}
