//
//  ImageDownloadManager.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 23/12/20.
//

import Foundation
import UIKit

class ImageDownloadManager {
    
    static var imageCache = NSCache<AnyObject, UIImage>()
    static var runningRequests = [String: URLSessionDataTask]()
    
    private init() {}
    
    static func getImage(urlString: String, completion: @escaping (_ imgUrl: String, _ image: UIImage?) -> Void) {
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            completion(urlString, imageFromCache)
            return
        }
        
        let task = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL,
                                              completionHandler: { (data, response, error) -> Void in
                                                
                                                defer { self.runningRequests.removeValue(forKey: urlString) }
                                                
                                                if let data = data {
                                                    DispatchQueue.main.async(execute: { () -> Void in
                                                        if let image = UIImage(data: data) {
                                                            self.imageCache.setObject(image, forKey: urlString as AnyObject)
                                                            completion(urlString, image)
                                                        } else {
                                                            completion(urlString, UIImage(named: "Some dummy image"))
                                                        }
                                                    })
                                                }
                                                
                                                guard let err = error as NSError?, err.code == NSURLErrorCancelled else {
                                                    completion(urlString, nil)
                                                    return
                                                }
                                                print(err.localizedDescription)
                                              })
        
        task.resume()
        runningRequests[urlString] = task
    }
    
    static func cancelRequestWith(url: String) {
        runningRequests[url]?.cancel()
        runningRequests.removeValue(forKey: url)
    }
}
