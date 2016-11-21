//
//  ViewController.swift
//  Drawing-swift
//
//  Created by Han Chen on 2016/11/21.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var drawingView: DrawingView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
    drawingView.clear()
  }
}

