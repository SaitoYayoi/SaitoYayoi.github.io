//
//  MainViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/5/8.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import UserNotifications
import AudioToolbox.AudioServices


var latitude = 0.0
var longitude = 0.0
var longtitudePlusLatitude:NSString? = "nil"

let Swidth = UIScreen.main.bounds.width
let Sheight = UIScreen.main.bounds.height

let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString


func requestUrl(urlString: String) -> Bool {
    let url: NSURL = NSURL(string: urlString)!
    let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
    request.timeoutInterval = 5
    
    var response: URLResponse?
    
    do {
        try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                return true
            }
        }
        return false
    }
    catch (let error) {
        print("error:\(error)")
        return false
    }
}

@available(iOS 10.0, *)
class MainViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var locationManager:CLLocationManager!
    var timer:Timer!
    var timer2:Timer!
    let naviImage = UIImageView()
    let nav1 = UIButton(type: UIButton.ButtonType.custom)
    let nav2 = UIButton(type: UIButton.ButtonType.custom)
    let nav3 = UIButton(type: UIButton.ButtonType.custom)
    let nav4 = UIButton(type: UIButton.ButtonType.custom)
    let bgView = UIImageView()
    let bg = UIImage(named: "bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 60, left: 15, bottom: 55, right: 15), resizingMode: .stretch)
    var Tap = UITapGestureRecognizer()
    
    var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {

        notification()
        everyDayNotification()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
            locationManager?.requestWhenInUseAuthorization()
        }
        
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
        
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.disappear), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.appear), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        
        naviImage.image = UIImage(named: "navi")
        bgView.image = bg
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints {(bg) in
            bg.center.equalToSuperview()
            bg.height.equalTo(100)
            bg.left.equalTo(0).offset(35)
            bg.right.equalTo(0).offset(-35)
        }
        self.view.addSubview(naviImage)
        naviImage.snp.makeConstraints {(make) in
            make.width.equalTo(210)
            make.height.equalTo(20)
            make.center.equalToSuperview()
        }
        Tap = UITapGestureRecognizer(target: self, action: #selector(self.animateAction(_:)))
        Tap.numberOfTapsRequired = 1
        Tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(Tap)
        nav1.addTarget(self, action: #selector(navi1), for: .touchUpInside)
        nav2.addTarget(self, action: #selector(navi2), for: .touchUpInside)
        nav3.addTarget(self, action: #selector(navi3), for: .touchUpInside)
        nav3.addTarget(self, action: #selector(navi3), for: .touchUpInside)
        nav4.addTarget(self, action: #selector(navi4), for: .touchUpInside)
        
        
        nav1.backgroundColor = UIColor.clear
        nav1.setTitle("看看信箱！", for: UIControl.State())
        nav1.setTitleColor(UIColor.white, for: UIControl.State())
        nav1.titleLabel?.font = UIFont(name: "Zpix", size: 30)
        
        nav2.backgroundColor = UIColor.clear
        nav2.setTitle("看看天气。", for: UIControl.State())
        nav2.setTitleColor(UIColor.white, for: UIControl.State())
        nav2.titleLabel?.font = UIFont(name: "Zpix", size: 30)
        
        nav3.backgroundColor = UIColor.clear
        nav3.setTitle("听一首歌。", for: UIControl.State())
        nav3.setTitleColor(UIColor.white, for: UIControl.State())
        nav3.titleLabel?.font = UIFont(name: "Zpix", size: 30)
        
        nav4.backgroundColor = UIColor.clear
        nav4.setTitle("看看运势！", for: UIControl.State())
        nav4.setTitleColor(UIColor.white, for: UIControl.State())
        nav4.titleLabel?.font = UIFont(name: "Zpix", size: 30)
        
    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
    @objc func disappear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.naviImage.alpha = 0
        })
    }
    @objc func appear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.naviImage.alpha = 1
        })
    }
    
    
    func notification() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.body = NSString.localizedUserNotificationString(forKey: "您回到了地球", arguments: nil)
               
        let infoDic = NSDictionary(object: "message.", forKey: "infoKey" as NSCopying)
        content.userInfo = infoDic as [NSObject : AnyObject]
               
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    func everyDayNotification() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.body = NSString.localizedUserNotificationString(forKey: "来看看今天的天气和运势吧!", arguments: nil)
        
        var compoents:DateComponents = DateComponents()
        compoents.hour = 9
               
        let infoDic = NSDictionary(object: "message.", forKey: "infoKey" as NSCopying)
        content.userInfo = infoDic as [NSObject : AnyObject]
               
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: compoents, repeats: true)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request)
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        longtitudePlusLatitude = ("\(NSString(string: String(longitude))),\(NSString(string: String(latitude)))") as NSString
        UserDefaults().setValue(longtitudePlusLatitude, forKey: "info")
        locationManager.stopUpdatingLocation()
    }
    
      @objc func animateAction(_ sender: UIButton) {
        timer.invalidate()
        timer2.invalidate()
        
        
        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
        
        naviImage.removeFromSuperview()
        Tap.removeTarget(self, action: #selector(self.animateAction(_:)))
        
        nav1.alpha = 0
        nav2.alpha = 0
        nav3.alpha = 0
        nav4.alpha = 0
        self.view.addSubview(nav1)
        self.view.addSubview(nav2)
        self.view.addSubview(nav3)
        self.view.addSubview(nav4)
        UIView.animate(withDuration: 0.6) {
            self.bgView.alpha = 0
            self.nav1.alpha = 1
            self.nav2.alpha = 1
            self.nav3.alpha = 1
            self.nav4.alpha = 1
        }

        nav1.snp.makeConstraints {(nav1) in
            nav1.centerY.equalToSuperview().offset(-80)
            nav1.centerX.equalToSuperview()
        }
        nav2.snp.makeConstraints {(nav2) in
            nav2.centerY.equalToSuperview().offset(-40)
            nav2.centerX.equalToSuperview()
        }
        nav3.snp.makeConstraints {(nav3) in
            nav3.centerY.equalToSuperview()
            nav3.centerX.equalToSuperview()
        }
        nav4.snp.makeConstraints {(nav4) in
            nav4.centerY.equalToSuperview().offset(40)
            nav4.centerX.equalToSuperview()
        }
    }
     @objc func navi1(_ sender: UIButton) {
        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
        let mail = MailViewController()
        self.present(mail, animated: true, completion: nil)
    }
     @objc func navi2(_ sender: UIButton) {
        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
        let networkStatus = requestUrl(urlString: "https://www.baidu.com")
        if networkStatus == false {
            let fal = NetworkErrorWeatherViewController()
            self.present(fal, animated: true, completion: nil)
        }
        else {
            let weather = WeatherViewController()
            self.present(weather, animated: true, completion: nil)
        }
    }
     @objc func navi3(_ sender: UIButton) {
        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
        let music = MusicViewController()
        self.present(music, animated: true, completion: nil)
    }
     @objc func navi4(_ sender: UIButton) {
        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
        let networkStatus = requestUrl(urlString: "https://www.baidu.com")
        if networkStatus == false {
            let fal = NetworkErrorFateViewController()
            self.present(fal, animated: true, completion: nil)
        }
        else {
        let fate = FateViewController()
        self.present(fate, animated: true, completion: nil)
        }
    }
    
}
