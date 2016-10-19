//
//  ViewController.swift
//  LoadingAnimation
//
//  Created by huangbaoyu on 16/9/27.
//  Copyright © 2016年 chachong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    weak var loadingView:LoadingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    

        let loadingView = LoadingView.showLoadingWith(view: view)        
        self.loadingView = loadingView
       
    }
    
    @IBAction func hideLoadingView(_ sender: AnyObject) {
        
        loadingView.hideLoadingView()
      
    }



}

