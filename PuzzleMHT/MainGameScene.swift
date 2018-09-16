//
//  MainGameScene.swift
//  PuzzleMHT
//
//  Created by 図師ともみ on 2018/03/24.
//  Copyright © 2018年 おいもファクトリー All rights reserved.
//

import UIKit
import SpriteKit

let NumColumns = 6
let NumRows = 8

class MainGameScene: SKScene {
    var board = SKSpriteNode()
    let boardLayer = SKNode()
    let shapeLayer = SKNode()
    
    let textLayer = SKNode()
    let strLayer = SKNode()
    
    let score = SKLabelNode()
    
    var tileArrayPos = Array(repeating: Array(repeating: CGPoint(), count: NumRows), count: NumColumns)
    var touchedNode = SKNode()
    var moveActionFlag = false
    var scorePoint = 0
    var tileSize:CGFloat = 0
    var textFieldPosition = CGPoint(x:20, y:-30)
    var boardLayerPosition = CGPoint(x:20, y:-80)

    override init(size:CGSize){
        super.init(size: size)
        
        backgroundColor = #colorLiteral(red: 0.000291686767, green: 0.8956640363, blue: 0.8927263618, alpha: 1)
        anchorPoint = CGPoint(x:0, y:1.0)
        
        addChild(boardLayer)
        addChild(textLayer)

        tileSize = size.width/7
        let margin = floor(tileSize/4)
        boardLayerPosition = CGPoint(x:margin, y:-80)
        textFieldPosition = CGPoint(x:margin, y: -20)
        board = SKSpriteNode(color:UIColor.white,size:CGSize(width:CGFloat(NumColumns)*tileSize, height:CGFloat(NumRows)*tileSize))
        board.name = "board"
        board.anchorPoint = CGPoint(x:0, y:1.0)
        board.position = boardLayerPosition
        
        let textfield = SKSpriteNode(color:UIColor.white,size:CGSize(width:CGFloat(NumColumns)*tileSize,height: 80))
        textfield.position = textFieldPosition
        textfield.anchorPoint = CGPoint(x:0, y:1.0)
        
        score.fontColor = UIColor.black
        score.horizontalAlignmentMode = .center
        score.position = CGPoint(x:textfield.position.x*8, y:textfield.position.y-30)
        textfield.addChild(score)
        
        strLayer.position = textFieldPosition
        strLayer.addChild(textfield)
        textLayer.addChild(strLayer)
        
        shapeLayer.position = boardLayerPosition
        shapeLayer.addChild(board)
        boardLayer.addChild(shapeLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        initMakeTile()
        
    }
    
    //タイルの初期化
    func randomColor()->UIColor{
        //0:red,1:green,2:blue,3:yellow
        let rnd = arc4random()%4
        var color:UIColor!
        switch rnd{
        case 0:
            color = UIColor.red
        case 1:
            color = UIColor.green
        case 2:
            color = UIColor.blue
        case 3:
            color = UIColor.yellow
        default:
            break
        }
        return color
    }
    
    
    //タイルの初期化
    func initMakeTile(){
        
        for  i in 0..<NumColumns{
            for  j in 0..<NumRows{
                let sprite = makeTileOne()
                sprite.position = CGPoint(x:CGFloat(i)*tileSize,y:-CGFloat(j)*tileSize)
                tileArrayPos[i][j] = sprite.position
                
                board.addChild(sprite)
            }
        }
        
    }
    
    
    //タイルの初期化
    func makeTileOne()->SKSpriteNode{
        let sprite = SKSpriteNode()
        
        sprite.anchorPoint = CGPoint(x:0, y:1.0)
        sprite.alpha *= 0.8
        sprite.color = randomColor()
        sprite.size = CGSize(width:tileSize-1, height:tileSize-1)
        
        if sprite.color == .red {
            sprite.texture = SKTexture(imageNamed: "icon_puzzle_01.jpg")
        } else if sprite.color == .yellow {
            sprite.texture = SKTexture(imageNamed: "icon_puzzle_02.jpg")
        } else if sprite.color == .blue {
            sprite.texture = SKTexture(imageNamed: "icon_puzzle_03.jpg")
        } else if sprite.color == .green {
            sprite.texture = SKTexture(imageNamed: "icon_puzzle_04.jpg")
        }
        
        return sprite
    }
    
    //タイルの移動
    func moveTile(node:SKNode){
        let touchedAction = SKAction.move(to: node.position, duration: 0.08)
        let passeagedAction = SKAction.move(to: touchedNode.position, duration: 0.08)
        
        moveActionFlag = true
        touchedNode.run(touchedAction, completion: {self.moveActionFlag = false})
        node.run(passeagedAction, completion: {self.moveActionFlag = false})
    }
    
    func searchNode(pos:CGPoint)->SKSpriteNode{
        let node = self.atPoint(CGPoint(x:pos.x+tileSize,y:pos.y-4*tileSize))
        return node as! SKSpriteNode
    }
    
    
    func searchEmpty(node:SKSpriteNode)-> Int{
        
        var count = 0
        if(node.name != "board"){
            for k in Int(-1*node.position.y/tileSize)..<NumRows{
                let sprite = searchNode(pos: tileArrayPos[Int(node.position.x/tileSize)][k])
                if(sprite.name == "board"){
                    count+=1
                }
            }
        }
        
        return count
    }
    
    func insertArray( arrayA:inout [SKNode],arrayB:[SKNode]){
        for node in arrayB{
            arrayA.append(node)
        }
    }
    
    func deleteColumns( array:inout [SKNode]){
        
        var deleteColumnsArray = Array(arrayLiteral:SKNode())
        
        for i in 0..<NumColumns{
            var color = searchNode(pos: tileArrayPos[i][0]).color
            var count = 0
            
            for j in 0..<NumRows{
                let node = searchNode(pos: tileArrayPos[i][j])
                if(color == node.color){
                    deleteColumnsArray.append(node)
                    count+=1
                    
                }else{
                    if(count >= 3){
                        insertArray(arrayA: &array, arrayB: deleteColumnsArray)
                    }
                    deleteColumnsArray.removeAll()
                    deleteColumnsArray.append(node)
                    color = node.color
                    count = 1
                }
                
            }
            
            if(count >= 3){
                insertArray(arrayA: &array, arrayB: deleteColumnsArray)
            }
            deleteColumnsArray.removeAll()
        }
    }
    
    func deleteRows( array:inout [SKNode]){
        
        var deleteRowsArray = Array(arrayLiteral:SKNode())
        
        for  j in 0..<NumRows{
            var color = searchNode(pos: tileArrayPos[0][j]).color
            var count = 0
            
            for i in 0..<NumColumns{
                let node = searchNode(pos: tileArrayPos[i][j])
                if(color == node.color){
                    deleteRowsArray.append(node)
                    count+=1
                    
                }else{
                    if(count >= 3){
                        insertArray(arrayA: &array, arrayB: deleteRowsArray)
                    }
                    deleteRowsArray.removeAll()
                    deleteRowsArray.append(node)
                    color = node.color
                    count = 1
                }
                
            }
            
            if(count >= 3){
                insertArray(arrayA: &array, arrayB: deleteRowsArray)
            }
            deleteRowsArray.removeAll()
        }
    }
    //タイルの消去と落ちる処理
    func dropTile(completion:@escaping ()->()){
        
        for i in 0..<NumColumns{
            for j in 0..<NumRows{
                let k = searchEmpty(node: searchNode(pos: tileArrayPos[i][j]))
                if(k != 0){
                    let sprite = searchNode(pos: tileArrayPos[i][j])
                    let action = SKAction.move(to: tileArrayPos[i][j+k], duration: 0.1)
                    sprite.run(action)
                }
            }
        }
        
        run(SKAction.wait(forDuration: 0.2), completion: completion)
    }
    
    func makeTileInEmpty(completion:@escaping ()->()){
        
        var emptyList = Array(repeating:0, count:NumColumns)
        for i in 0..<NumColumns{
            var count = 0
            for j in 0..<NumRows{
                if(searchNode(pos: tileArrayPos[i][j]).name == "board"){
                    count+=1
                    scorePoint += 100
                }
            }
            emptyList[i] = count
        }
        var i = 0
        for k in emptyList{
            for j in  0..<k{
                let sprite = makeTileOne()
                board.addChild(sprite)
                let action = SKAction.move(to: tileArrayPos[i][j], duration: 0.1)
                sprite.run(action)
            }
            i+=1
        }
        run(SKAction.wait(forDuration: 0.2), completion: completion)
    }
    
    //タイルの消去と落ちる処理
    func deleteAndDropTile(){
        
        var deleteTileArray = Array(arrayLiteral:SKNode())
        deleteTileArray.removeAll()
        deleteColumns(array: &deleteTileArray)
        deleteRows(array: &deleteTileArray)
        
        if(deleteTileArray.isEmpty){
            moveActionFlag = false
            return
        }
        
        board.removeChildren(in: deleteTileArray)
        
        dropTile(){
            self.makeTileInEmpty(){
                self.deleteAndDropTile()
            }
        }
        
    }
    
    //タッチ操作
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            touchedNode = self.atPoint(location)
            for node in self.board.children{
                if(touchedNode == node as NSObject && !moveActionFlag){
                    touchedNode.alpha *= 0.5
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let passagedNode = self.atPoint(location)
            for node in self.board.children{
                if(passagedNode == node as NSObject && touchedNode != passagedNode && !moveActionFlag){
                    moveTile(node: passagedNode)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let endedNode = self.atPoint(location)
            for node in self.board.children{
                if(endedNode == node as NSObject && !moveActionFlag){
                    moveActionFlag = true
                    deleteAndDropTile()
                    touchedNode.alpha *= 2
                }
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        score.text = "Score : \(scorePoint)"
    }
}
