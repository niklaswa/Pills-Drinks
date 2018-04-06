//
//  Extensions.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
