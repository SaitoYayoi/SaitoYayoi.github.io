//
//  FateViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/4/15.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SwiftyJSON


var timer:Timer!
var timer2:Timer!
let preTextLabel = UILabel()
let TextField = UITextField()
let consLabel = UILabel()
let str = "你的星座是:"
var i = 0
var times = 0
var cons = "nil"
var info:Dictionary<String,JSON> = ["name":JSON("nil"), "datetime":JSON("nil"), "all":JSON("nil"), "color":JSON("nil"), "health":JSON("nil"), "love":JSON("nil"), "money":JSON("nil"), "number":JSON("nil"), "QFriend":JSON("nil"), "summary":JSON("nil"), "work":JSON("nil")]

class FateViewController: UIViewController, UITextFieldDelegate {
    
    @objc func returnHome(_ button:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func preTextPrint(_ timer:Timer) {
            preTextLabel.backgroundColor = UIColor.clear
            self.view.addSubview(preTextLabel)
            preTextLabel.textColor = UIColor.white
            preTextLabel.font = UIFont(name: "Zpix", size: 20)
            preTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            preTextLabel.numberOfLines = 0
            preTextLabel.snp.makeConstraints {(preTextLabel) in
                preTextLabel.width.equalTo(300)
                preTextLabel.centerX.equalToSuperview().offset(-25)
                preTextLabel.centerY.equalToSuperview().offset(-50)
            }
            if i <= 8{
            let output = str.prefix(i)
            preTextLabel.text = String(output)
            i+=1
        }
        else {
            timer.invalidate()
        }
        if i == 8{
            self.view.addSubview(TextField)
            TextField.snp.makeConstraints {(textField) in
                textField.width.equalTo(100)
                textField.centerY.equalTo(preTextLabel)
                textField.centerX.equalTo(preTextLabel).offset(25)
            }
        }
    }

    func textFieldShouldReturn(_ TextField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        cons = TextField.text!
        if cons == "水瓶" || cons == "双鱼" || cons == "白羊" || cons == "金牛" || cons == "双子" || cons == "巨蟹" || cons == "狮子" || cons == "处女" || cons == "天秤" || cons == "天蝎" || cons == "射手" || cons == "摩羯" {
            cons = cons + "座"
        }
        let urlString = "http://web.juhe.cn:8080/constellation/getAll?key=b9e394f24f7890c24b19db0ef6b44c00&type=today&consName=\(cons)"
        let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let config = URLSessionConfiguration.default
        let url = URL(string: urlStr!)
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url!) {(data, response, error) in
            let json = try! JSON(data: data!)
            info["name"] = json["name"]
            info["datetime"] = json["datetime"]
            info["all"] = json["all"]
            info["color"] = json["color"]
            info["health"] = json["health"]
            info["love"] = json["love"]
            info["money"] = json["money"]
            info["number"] = json["number"]
            info["QFriend"] = json["QFriend"]
            info["summary"] = json["summary"]
            info["work"] = json["work"]
            i = 100
        }
        task.resume()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(FateViewController.preTextPrint(_:)), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(FateViewController.consPrint(_:)), userInfo: nil, repeats: true)
        TextField.borderStyle = UITextField.BorderStyle.roundedRect
        TextField.textAlignment = NSTextAlignment.center
        TextField.backgroundColor = UIColor.clear
        TextField.returnKeyType = UIReturnKeyType.done
        TextField.delegate = self
        TextField.textColor = UIColor.white
        TextField.font = UIFont(name: "Zpix", size: 20)
        
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

        // Do any additional setup after loading the view.
    }
    @objc func consPrint(_ timer:Timer) {
        consLabel.backgroundColor = UIColor.clear
        self.view.addSubview(consLabel)
        consLabel.textColor = UIColor.white
        consLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        consLabel.numberOfLines = 0
        consLabel.snp.makeConstraints {(consLabel) in
            consLabel.width.equalTo(300)
            consLabel.center.equalToSuperview()
        }
        if i == 100 {
            if cons == "白羊座" || cons == "金牛座" || cons == "双子座" || cons == "巨蟹座" || cons == "狮子座" || cons == "处女座" || cons == "天秤座" || cons == "天蝎座" || cons == "射手座" || cons == "摩羯座" || cons == "水瓶座" || cons == "双鱼座" {
            let printStr = "\(info["datetime"]!.string!)的\(info["name"]!.string!)\n综合指数:\(info["all"]!.string!)\n幸运色:\(info["color"]!.string!)\n健康指数:\(info["health"]!.string!)\n爱情指数:\(info["love"]!.string!)\n财运指数:\(info["money"]!.string!)\n幸运数字:\(info["number"]!.int!)\n速配星座:\(info["QFriend"]!.string!)\n工作指数:\(info["work"]!.string!)\n今日概述:\(info["summary"]!.string!)"
            preTextLabel.text = ""
            TextField.removeFromSuperview()
            if times <= printStr.count {
                let output = printStr.prefix(times)
                let paraph = NSMutableParagraphStyle()
                paraph.lineSpacing = 10
                let attributes = [NSAttributedString.Key.font: UIFont(name: "Zpix", size: 22),
                                  NSAttributedString.Key.paragraphStyle: paraph]
                consLabel.attributedText = NSAttributedString(string: String(output), attributes: attributes)
                times+=1
                
            }
            else {
                timer2.invalidate()
                let Return = UIButton(type: UIButton.ButtonType.roundedRect)
                let returnImage = UIImage(named: "return")
                Return.setBackgroundImage(returnImage, for: .normal)
                Return.addTarget(self, action: #selector(self.returnHome(_:)), for: UIControl.Event.touchUpInside)
                self.view.addSubview(Return)
                Return.snp.makeConstraints {(button) in
                    button.centerX.equalTo(consLabel).offset(150)
                    button.centerY.equalTo(consLabel).offset(320)
                }
                }
            }
            else {
                preTextLabel.text = ""
                TextField.removeFromSuperview()
                let str = "没有在星座大全中找到\(cons)\n检查一下吧"
                if times <= str.count {
                    let output = str.prefix(times)
                    let paraph = NSMutableParagraphStyle()
                    paraph.lineSpacing = 10
                    let attributes = [NSAttributedString.Key.font: UIFont(name: "Zpix", size: 22),
                                                     NSAttributedString.Key.paragraphStyle: paraph]
                    consLabel.attributedText = NSAttributedString(string: String(output), attributes: attributes)
                    times+=1
                }
                else {
                    timer2.invalidate()
                    let Return = UIButton(type: UIButton.ButtonType.roundedRect)
                    let returnImage = UIImage(named: "return")
                    Return.setBackgroundImage(returnImage, for: .normal)
                    Return.addTarget(self, action: #selector(self.returnHome(_:)), for: UIControl.Event.touchUpInside)
                    self.view.addSubview(Return)
                    Return.snp.makeConstraints {(button) in
                        button.centerX.equalTo(consLabel).offset(110)
                        button.centerY.equalTo(consLabel).offset(40)
                    }
                }
                
        }
    }
  }
}
