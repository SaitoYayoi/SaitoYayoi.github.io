//
//  MailViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/4/4.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var str = "2020年7月29日 星期三 \n...\n这将会是My Planet的最后一个版本\n终究是烂尾了\nAnyway...\n晚安..."
    let text = UILabel()
    var i = 1
    let returnHomeBtn = UIButton(type: UIButton.ButtonType.roundedRect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let timer:Timer!
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MailViewController.wordPrint(_:)), userInfo: nil, repeats: true)
        
        returnHomeBtn.backgroundColor = UIColor.clear
        returnHomeBtn.setTitle("返回主页", for: .normal)
        returnHomeBtn.setTitleColor(UIColor.white, for: UIControl.State())
        returnHomeBtn.titleLabel?.font = UIFont(name: "Zpix", size: 30)
        returnHomeBtn.addTarget(self, action: #selector(self.returnHome(_:)), for: UIControl.Event.touchUpInside)
        
        
        var background = [UIImage]()
                      for i in 1 ... 4 {
                          background.append(UIImage(named: "bg\(i)")!)
                      }
        let imageView = UIImageView()
        imageView.animationImages = background
        imageView.animationDuration = 5
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        self.view.addSubview(imageView)
            imageView.snp.makeConstraints {(bg) in
            bg.top.bottom.left.right.equalTo(0)
            bg.center.equalToSuperview()
        }

        text.backgroundColor = UIColor.clear
        self.view.addSubview(text)
        text.textColor = UIColor.white
        text.lineBreakMode = NSLineBreakMode.byWordWrapping
        text.numberOfLines = 0
        text.snp.makeConstraints {(text) in
            text.width.equalTo(300)
            text.center.equalToSuperview()
        }
        
        
    }
    @objc func wordPrint(_ timer:Timer) {
        if i <= str.count{
        let output = str.prefix(i)
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 15
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Zpix", size: 22),
                              NSAttributedString.Key.paragraphStyle: paraph]
            text.attributedText = NSAttributedString(string: String(output), attributes: attributes)
        i+=1
        }
        else{
            timer.invalidate()
            self.view.addSubview(returnHomeBtn)
            returnHomeBtn.snp.makeConstraints {(btn) in
                btn.centerX.equalToSuperview()
                btn.centerY.equalTo(text).offset(150)
            }
        }
    }
    
    @objc func returnHome(_ btn: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
