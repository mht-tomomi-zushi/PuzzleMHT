//
//  ViewController.swift
//  PuzzleMHT
//
//  Created by 図師ともみ on 2018/03/24.
//  Copyright © 2018年 おいもファクトリー All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {

    var skView : SKView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let sv = SKView(frame: CGRect(x:0, y:0,width: width,height: height))
        let ss = MainGameScene(size: sv.frame.size)
        
        sv.presentScene(ss)
        view.addSubview(sv)
    }

    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)));UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.all.rawValue)));UIInterfaceOrientationMask.all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

