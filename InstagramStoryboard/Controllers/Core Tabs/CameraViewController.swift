//
//  CameraViewController.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Camera"
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    private func didTapTakePicture() {
        
    }
    
}
