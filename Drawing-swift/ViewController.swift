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
  @IBOutlet weak var properties_View: UIView!
  @IBOutlet weak var black_Button: UIButton!
  @IBOutlet weak var blue_Button: UIButton!
  @IBOutlet weak var green_Button: UIButton!
  @IBOutlet weak var orange_Button: UIButton!
  @IBOutlet weak var lightGray_Button: UIButton!
  @IBOutlet weak var drawOrErase_Button: UIButton!
  
  private let BORDER_WIDTH: CGFloat = 5
  
  private var isDrawing: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupButtons()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupButtons() {
    for view in properties_View.subviews {
      if let button = view as? UIButton {
        if button != drawOrErase_Button {
          button.layer.borderColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1).cgColor
        }
      }
    }
    black_Button.layer.borderWidth = BORDER_WIDTH
  }
  
  private func selectedButtons(sender: UIButton) {
    for view in properties_View.subviews {
      if let button = view as? UIButton {
        if button != drawOrErase_Button {
          button.layer.borderWidth = (sender == button ? BORDER_WIDTH : 0)
        }
      }
    }
    drawingView.changeColor(color: sender.backgroundColor!)
  }

  @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
    drawingView.clear()
  }
  
  @IBAction func undoButtonPressed(_ sender: UIBarButtonItem) {
    drawingView.undo()
  }
  
  @IBAction func redoButtonPressed(_ sender: UIBarButtonItem) {
    drawingView.redo()
  }
  
  @IBAction func blackColorButtonPressed(_ sender: UIButton) {
    selectedButtons(sender: sender)
  }
  
  @IBAction func blueColorButtonPressed(_ sender: UIButton) {
    selectedButtons(sender: sender)
  }
  
  @IBAction func greenColorButtonPressed(_ sender: UIButton) {
    selectedButtons(sender: sender)
  }
  
  @IBAction func orangeColorButtonPressed(_ sender: UIButton) {
    selectedButtons(sender: sender)
  }
  
  @IBAction func lightGrayColorButtonPressed(_ sender: UIButton) {
    selectedButtons(sender: sender)
  }
  
  @IBAction func drawOrEraseButtonPressed(_ sender: UIButton) {
    isDrawing = !isDrawing
    drawOrErase_Button.isSelected = !isDrawing
    for view in properties_View.subviews {
      if let button = view as? UIButton {
        if button != sender {
          button.isHidden = !isDrawing
        }
      }
    }
    drawingView.drawOrErase(isDrawing: isDrawing)
  }
}

