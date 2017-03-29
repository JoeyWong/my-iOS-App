//
//  ViewController.swift
//  Tetris
//
//  Created by Joey on 4/12/16.
//  Copyright © 2016 Joey. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,GameViewDelegate{

    
    
    let MARGINE: CGFloat = 10
    let BUTTON_SIZE: CGFloat = 48
    let BUTTON_ALPHA: CGFloat = 0.4
    let TOOLBAR_HEIGHT: CGFloat = 28
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var gameView: GameView!
    
    var bgMusicPlayer: AVAudioPlayer!
    var speedShow: UILabel!
    var scoreShow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rect = UIScreen.main.bounds
        screenWidth = rect.width
        screenHeight = rect.height
        
        self.addToolBar()
        
        gameView = GameView(frame: CGRect(x: rect.origin.x + MARGINE * 1 + 2,
            y: rect.origin.y + TOOLBAR_HEIGHT + MARGINE * 3,
            width: rect.size.width - MARGINE * 2,
            height: rect.size.height - TOOLBAR_HEIGHT - MARGINE * 4))
        
        gameView.delegate = self
        
        self.view.addSubview(gameView)
        

        
        
        gameView.startGame()
        
        
        self.view.backgroundColor = UIColor.white
       // self.addButton()
        
        //gameView.layer.borderWidth = 1
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.right(_:)))
        self.view.addGestureRecognizer(swipeGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.left(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.down(_:)))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDownGesture)
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.up(_:)))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUpGesture)

    }
    


    
    
    
    func addToolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: MARGINE * 2, width: screenWidth, height: TOOLBAR_HEIGHT))
        self.view.addSubview(toolBar)
        
        let speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: TOOLBAR_HEIGHT))
        speedLabel.text = "Speed:"
        let speedLabelItem = UIBarButtonItem(customView: speedLabel)
        
        speedShow = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: TOOLBAR_HEIGHT))
        speedShow.textColor = UIColor.red
        let speedShowItem = UIBarButtonItem(customView: speedShow)
        
        let scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: TOOLBAR_HEIGHT))
        scoreLabel.text = "Score:"
        let scoreLabelItem = UIBarButtonItem(customView: scoreLabel)
        
        scoreShow = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: TOOLBAR_HEIGHT))
        scoreShow.textColor = UIColor.red
        let scoreShowItem = UIBarButtonItem(customView: scoreShow)
        let  flexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [speedLabelItem, speedShowItem, flexItem, scoreLabelItem, scoreShowItem]
        
    }
    
    

    
    //改变方块方向
    func up(_ sender: AnyObject){
        gameView.rotate()
    }
    
    //方块落下
    func down(_ sender: AnyObject){
        gameView.moveDown()
    }
    
    //左移一格
    func left(_ sender: AnyObject){
        gameView.moveLeft()
    }
    
    //右移一格
    func right(_ sender: AnyObject){
        gameView.moveRight()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSpeed(_ speed: Int) {
        self.speedShow.text = "\(speed)"
        print("\(speed)")
    }
    
    func updateScore(_ score: Int) {
        self.scoreShow.text = "\(score)"
        print("\(score)")
    }

}

