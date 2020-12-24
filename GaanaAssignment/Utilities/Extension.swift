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
