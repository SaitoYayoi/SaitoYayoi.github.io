//
//  WeatherViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/4/4.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON


class WeatherViewController: UIViewController, UITextFieldDelegate{
    
    let preTextLabel = UILabel()
    let weatherInfo = UILabel()
    let textField = UITextField()
    var warning = 0
    
    let tudeToLocation = "https://restapi.amap.com/v3/geocode/regeo?output=JSON&radius=1000&extensions=all&key=14960ff6beb497b9b3976a298a7823d4&location=%@"
    let weatherUrl = "https://restapi.amap.com/v3/weather/weatherInfo?key=ac27e18866b8b0b3b5270054264a484d&city=%@"
    let preText = "正在给气象局打电话..."
    var timer:Timer!
    var timer2:Timer!
    var nowDistrict = "nil"
    var times = 0
    
    var info:Dictionary<String,JSON> = ["温度":JSON("nil"),"湿度":JSON("nil"),"天气":JSON("nil"),"风向":JSON("nil"),"风力":JSON("nil")]

        var i = 0
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
            if i <= 12{
            let output = preText.prefix(i)
            preTextLabel.text = String(output)
            i+=1
        }
        else {
            timer.invalidate()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(WeatherViewController.preTextPrint(_:)), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(WeatherViewController.weatherinfo(_:)), userInfo: nil, repeats: true)
        
        let plistPath = Bundle.main.path(forResource: "WeatherNum", ofType: "plist")
        let data = NSMutableDictionary.init(contentsOfFile: plistPath!)!
        
        UserDefaults().string(forKey: "info")
        let RelongtitudePlusLatitude  = longtitudePlusLatitude?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let config1 = URLSessionConfiguration.default
        let url1 = URL(string: String(format: tudeToLocation, RelongtitudePlusLatitude))
        let request1 = URLRequest(url: url1!)
        let session1 = URLSession(configuration: config1)
        let task1 = session1.dataTask(with: request1) { (data1, response, error) in
            let json1 = try! JSON(data: data1!)
            self.nowDistrict = json1["regeocode"]["addressComponent"]["district"].stringValue
            if self.nowDistrict == "" || self.nowDistrict == ""{
                self.warning = 1
                let alertController = UIAlertController(title: "没有获取到您的经纬度\n即将返回星球主页…", message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                    self.dismiss(animated: true, completion: nil)

                }
                
            }
            else {
            let midNum = data[self.nowDistrict]! as! String
            let districtNum = midNum
            
            let weatherUrl = "https://restapi.amap.com/v3/weather/weatherInfo?key=ac27e18866b8b0b3b5270054264a484d&city=\(districtNum)"
            let config2 = URLSessionConfiguration.default
            let url2 = URL(string: String(format: weatherUrl))
            let request2 = URLRequest(url: url2!)
            let session2 = URLSession(configuration: config2)
            let task2 = session2.dataTask(with: request2) { (data2, response, error) in
                let json2 = try! JSON(data: data2!)
                self.info["温度"] = json2["lives"][0]["temperature"]
                self.info["湿度"] = json2["lives"][0]["humidity"]
                self.info["风向"] = json2["lives"][0]["winddirection"]
                self.info["风力"] = json2["lives"][0]["windpower"]
                self.info["天气"] = json2["lives"][0]["weather"]
            }
            task2.resume()
        }
        }
        task1.resume()
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
        
    }
    
    @objc func weatherinfo(_ timer:Timer){
        let humidity = info["湿度"]?.string
        let temperature = info["温度"]?.string
        let winddirection = info["风向"]?.string
        let weather = info["天气"]?.string
        let windpower = info["风力"]?.string
        let weatherString = "\(nowDistrict)现在的天气是:\n温度:\(temperature!)℃！\n湿度:\(humidity!)%！\n天气状况:\(weather!)！\n风力:\(windpower!)！\n风向:\(winddirection!)！\n报告完毕！"
        weatherInfo.backgroundColor = UIColor.clear
        self.view.addSubview(weatherInfo)
        weatherInfo.textColor = UIColor.white
        weatherInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        weatherInfo.numberOfLines = 0
        weatherInfo.snp.makeConstraints {(weatherInfo) in
            weatherInfo.center.equalToSuperview()
        }
        if warning == 1{
            weatherInfo.removeFromSuperview()
        }
        if i==13 {
            preTextLabel.text = ""
            if times <= weatherString.count{
                let output = weatherString.prefix(times)
                let paraph = NSMutableParagraphStyle()
                paraph.lineSpacing = 10
                let attributes = [NSAttributedString.Key.font: UIFont(name: "Zpix", size: 22),NSAttributedString.Key.paragraphStyle: paraph]
                weatherInfo.attributedText = NSAttributedString(string: String(output), attributes: attributes as [NSAttributedString.Key : Any])
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
                    button.centerX.equalTo(weatherInfo).offset(100)
                    button.centerY.equalTo(weatherInfo).offset(120)
                }
            }

        }
    }
    @objc func returnHome(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }

}

