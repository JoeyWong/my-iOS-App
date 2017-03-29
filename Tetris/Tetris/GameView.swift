//
//  GameView.swift
//  Tetris
//
//  Created by Joey on 4/16/16.
//  Copyright © 2016 Joey. All rights reserved.
//
import UIKit
import AVFoundation


protocol GameViewDelegate {
    func updateScore(_ score: Int)
    func updateSpeed(_ speed: Int)
}

class GameView: UIView {
    let TETRIS_ROWS = 17
    let TETRIS_COLS = 10
    let CELL_SIZE: Int
    let STROKE_WIDTH: Double = 1.0
    let BASE_SPEED = 2.0
    var ctx: CGContext!
    var curScore: Int = 0
    var curSpeed = 1
    
    var curTimer:Timer!
    var delegate: GameViewDelegate!

    

    
    
    
    var image: UIImage!
    
    var currentFall: [Block]!
    
    
    let colors = [UIColor.white.cgColor,
                  UIColor.red.cgColor,
                  UIColor.green.cgColor,
                  UIColor.blue.cgColor,
                  UIColor.yellow.cgColor,
                  UIColor.magenta.cgColor,
                  UIColor.purple.cgColor,
                  UIColor.brown.cgColor]
    var blockArr: [[Block]]
    
    var tetris_status = [[Int]]()
        
    func initTetrisStatus(){
        let tmpRow = Array(repeating: 0, count: TETRIS_COLS)
        tetris_status = Array(repeating: tmpRow, count: TETRIS_ROWS)
    }
    
    func initBlock(){
        let rand = Int(arc4random()) % blockArr.count
        currentFall = blockArr[rand]
    }
    
    
    
    
    
//    var disPlayer:AVAudioPlayer!
    
    override init(frame: CGRect) {
        self.CELL_SIZE = Int(frame.size.width) / TETRIS_COLS

        self.blockArr = [
            [
                Block(x: TETRIS_COLS / 2 - 1, y: 0, color: 1),
                Block(x: TETRIS_COLS / 2, y: 0, color: 1),
                Block(x: TETRIS_COLS / 2, y: 1, color: 1),
                Block(x: TETRIS_COLS / 2 + 1, y: 1, color: 1)
            ],
            [
                Block(x: TETRIS_COLS / 2 + 1, y: 0, color: 2),
                Block(x: TETRIS_COLS / 2, y: 0, color: 2),
                Block(x: TETRIS_COLS / 2, y: 1, color: 2),
                Block(x: TETRIS_COLS / 2 - 1, y: 1, color: 2)
            ],
            [
                Block(x: TETRIS_COLS / 2 - 1, y: 0, color: 3),
                Block(x: TETRIS_COLS / 2, y: 0, color: 3),
                Block(x: TETRIS_COLS / 2 - 1, y: 1, color: 3),
                Block(x: TETRIS_COLS / 2, y: 1, color: 3)
            ],
            [
                Block(x: TETRIS_COLS / 2 - 1, y: 0, color: 4),
                Block(x: TETRIS_COLS / 2 - 1, y: 1, color: 4),
                Block(x: TETRIS_COLS / 2 - 1, y: 2, color: 4),
                Block(x: TETRIS_COLS / 2, y: 2, color: 4)
            ],
            [
                Block(x: TETRIS_COLS / 2, y: 0, color: 5),
                Block(x: TETRIS_COLS / 2, y: 1, color: 5),
                Block(x: TETRIS_COLS / 2, y: 2, color: 5),
                Block(x: TETRIS_COLS / 2 - 1, y: 2, color: 5)
            ],
            [
                Block(x: TETRIS_COLS / 2, y: 0, color: 6),
                Block(x: TETRIS_COLS / 2, y: 1, color: 6),
                Block(x: TETRIS_COLS / 2, y: 2, color: 6),
                Block(x: TETRIS_COLS / 2, y: 3, color: 6)
            ],
            [
                Block(x: TETRIS_COLS / 2, y: 0, color: 7),
                Block(x: TETRIS_COLS / 2 - 1, y: 1, color: 7),
                Block(x: TETRIS_COLS / 2, y: 1, color: 7),
                Block(x: TETRIS_COLS / 2 + 1, y: 1, color: 7)
            ],
        ]
        
        
        
        super.init(frame: frame)
        
//        let disMusicURL = NSBundle.mainBundle().URLForResource("dis", withExtension: "wav")
//        do{
//           try
//            disPlayer = AVAudioPlayer(contentsOfURL: disMusicURL!)
//        }catch{
//            print("error")
//        }
//        disPlayer.numberOfLoops = 0
        UIGraphicsBeginImageContext(self.bounds.size)
        ctx = UIGraphicsGetCurrentContext()
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(self.bounds)
        
        createCells(TETRIS_ROWS, cols: TETRIS_COLS, cellWidth: CELL_SIZE, cellHeight: CELL_SIZE)
        image = UIGraphicsGetImageFromCurrentImageContext()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCells(_ rows: Int, cols: Int, cellWidth: Int, cellHeight: Int){
        ctx.beginPath()
        
        for i in 0...TETRIS_ROWS
        {
            ctx.move(to: CGPoint(x: 0, y: CGFloat(i * CELL_SIZE)))
            ctx.addLine(to: CGPoint(x: CGFloat(TETRIS_COLS * CELL_SIZE), y: CGFloat(i * CELL_SIZE)))
        }
        
        for i in 0...TETRIS_COLS
        {
            ctx.move(to: CGPoint(x: CGFloat(i * CELL_SIZE), y: 0))
            ctx.addLine(to: CGPoint(x: CGFloat(i * CELL_SIZE), y: CGFloat(TETRIS_ROWS * CELL_SIZE)))
        }
        ctx.closePath()
        ctx.setStrokeColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor)
        ctx.setLineWidth(CGFloat(STROKE_WIDTH))
        ctx.strokePath()
    }
    
    override func draw(_ rect: CGRect) {
        var curCtx = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero)
    }
    
    func moveDown(){
        var canDown = true
        for i in 0...currentFall.count - 1{
            if currentFall[i].y >= TETRIS_ROWS - 1{
                canDown = false
                break
            }
            
            if tetris_status[currentFall[i].y + 1][currentFall[i].x] != 0{
                canDown = false
                break
            }
        }
        
        if canDown{
            self.drawBlock()
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(UIColor.white.cgColor)
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            for i in 0...currentFall.count - 1 {
                currentFall[i].y += 1
            }
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(colors[cur.color])
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))

            }
        }
        else{
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                if cur.y < 2 {
                    curTimer.invalidate()
                    let alert = UIAlertController(title: "GAME OVER", message: "RESTART?", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(UIAlertAction) -> Void in })
                    let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(UIAlertAction) -> Void in self.startGame()})
                    alert.addAction(cancelAction)
                    alert.addAction(yesAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    return
                }
                tetris_status[cur.y][cur.x] = cur.color
            }
            
            lineFull()
            initBlock()
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        self.setNeedsDisplay()
    }
    
    func lineFull() {
        for i in 0...TETRIS_ROWS - 1 {
            var flag = true
            for j in 0...TETRIS_COLS - 1 {
                if tetris_status[i][j] == 0 {
                    flag = false
                    break
                }
            }
            
            if flag {
                curScore += 100
                self.delegate?.updateScore(curScore)
                
                
                if curScore >= curSpeed * curSpeed * 500 {
                    curSpeed += 1
                    self.delegate?.updateSpeed(curSpeed)
                    
                    curTimer.invalidate()
                    curTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED / Double(curSpeed), target: self, selector: #selector(GameView.moveDown), userInfo: nil, repeats: true)
                }
                
                
                for j in ((0 + 1)...i).reversed()
                {
                    for k in 0...TETRIS_COLS - 1 {
                        tetris_status[j][k] = tetris_status[j-1][k]
                    }
                }
                
//                if !disPlayer.playing{
//                    disPlayer.play()
//                }
            }
            
        }
    }
    
    func drawBlock(){
        for i in 0...TETRIS_ROWS - 1{
            for j in 0...TETRIS_COLS - 1 {
                if tetris_status[i][j] != 0{
                    ctx.setFillColor(colors[tetris_status[i][j]])
                    ctx.fill(CGRect(x: CGFloat(Double(j * CELL_SIZE) + STROKE_WIDTH),
                        y: CGFloat(Double(i * CELL_SIZE) + STROKE_WIDTH),
                        width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                        height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
                }else{
                    ctx.setFillColor(UIColor.white.cgColor)
                    ctx.fill(CGRect(x: CGFloat(Double(j * CELL_SIZE) + STROKE_WIDTH),
                        y: CGFloat(Double(i * CELL_SIZE) + STROKE_WIDTH),
                        width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                        height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
                }
            }
        }
    }
    
    func moveLeft() {
        var canLeft = true
        for i in 0...currentFall.count - 1 {
            if currentFall[i].x <= 0 {
                canLeft = false
                break
            }
            if tetris_status[currentFall[i].y][currentFall[i].x - 1] != 0 {
                canLeft = false
                break
            }
        }
        
        if canLeft {
            self.drawBlock()
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(UIColor.white.cgColor)
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            for i in 0...currentFall.count - 1 {
                currentFall[i].x -= 1
            }
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(colors[cur.color])
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.setNeedsDisplay()
        }
    }
    
    func moveRight() {
        var canRight = true
        for i in 0...currentFall.count - 1 {
            if currentFall[i].x >= TETRIS_COLS - 1 {
                canRight = false
                break
            }
            if tetris_status[currentFall[i].y][currentFall[i].x + 1] != 0 {
                canRight = false
                break
            }
        }
        
        if canRight {
            self.drawBlock()
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(UIColor.white.cgColor)
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            for i in 0...currentFall.count - 1 {
                currentFall[i].x += 1
            }
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(colors[cur.color])
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.setNeedsDisplay()
        }
    }
    
    func rotate() {
        var canRotate = true
        for i in 0...currentFall.count - 1 {
            let preX = currentFall[i].x
            let preY = currentFall[i].y
            
            if i != 2 {
                let afterRotateX = currentFall[2].x + preY - currentFall[2].y
                let afterRotateY = currentFall[2].y + currentFall[i].x - preX
                
                if afterRotateX < 0 || afterRotateX > TETRIS_COLS - 1 ||
                afterRotateY < 0 || afterRotateY > TETRIS_ROWS - 1 ||
                    tetris_status[afterRotateY][afterRotateX] != 0 {
                    canRotate = false
                    break
                }
            }
        }
        
        if canRotate {
            self.drawBlock()
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(UIColor.white.cgColor)
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            for i in 0...currentFall.count - 1 {
                let preX = currentFall[i].x
                let preY = currentFall[i].y
                if i != 2 {
                    currentFall[i].x = currentFall[2].x + preY - currentFall[2].y
                    currentFall[i].y = currentFall[2].y + currentFall[2].x - preX
                }
            }
            for i in 0...currentFall.count - 1 {
                let cur = currentFall[i]
                ctx.setFillColor(colors[cur.color])
                ctx.fill(CGRect(x: CGFloat(Double(cur.x * CELL_SIZE) + STROKE_WIDTH),
                    y: CGFloat(Double(cur.y * CELL_SIZE) + STROKE_WIDTH),
                    width: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2),
                    height: CGFloat(Double(CELL_SIZE) - STROKE_WIDTH * 2)))
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.setNeedsDisplay()
        }
        
        
    }
    
    func startGame(){
        self.curSpeed = 1
        self.delegate.updateSpeed(self.curSpeed)
        
        print("\(curSpeed)")
        
        self.curScore = 0
        self.delegate.updateScore(self.curScore)
        
        
        curTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED / Double(curSpeed), target: self, selector: #selector(GameView.moveDown), userInfo: nil, repeats: true)
        initTetrisStatus()
        initBlock()
       
    }
}
