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
    weak var loadingViewForOC:LoadingViewForOC!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        //swift3写的
        let loadingView = LoadingView.showLoadingWith(view: view)
        self.loadingView = loadingView
        
        //OC写的
        //let loadingViewForOC = LoadingViewForOC.showLoading(with: view)
        //self.loadingViewForOC = loadingViewForOC
       
    }
    
    @IBAction func hideLoadingView(_ sender: AnyObject) {
        
        loadingView.hideLoadingView()
        
        //loadingViewForOC.hideLoadingView()
      
    }



}

