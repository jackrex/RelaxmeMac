//
//  MusicPlayerViewController.swift
//  RelaxMeMac
//
//  Created by jackrex on 3/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SDWebImage
import AVFoundation


extension CALayer {
    func pauseAnimate(){
        let pausedTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0;
        timeOffset = pausedTime;
    }
    
    func resumeAnimate(){
        let pausedTime: CFTimeInterval = timeOffset
        speed = 0.2;
        timeOffset = 0.0;
        beginTime = 0.0;
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause;
    }
}

class MusicPlayerViewController: NSViewController, AVAudioPlayerDelegate, NSWindowDelegate {
    
    var audioPlayer = AudioManager.sharedManager.audioPlayer

    
    var data: TVListDetail!
    var currentPlayUrl: String!
    var listData: [TVListDetail]!
    var currentIndex: Int!
    
    var timer: Timer!

    
    @IBOutlet weak var coverImageView: NSImageView!
    var trueCoverImageView: NSImageView!
    @IBOutlet weak var musicLabel: NSTextField!
    @IBOutlet weak var startTimeLabel: NSTextField!
    @IBOutlet weak var endTimeLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var indicatorView: NSProgressIndicator!
    
    
    @IBOutlet weak var playBtn: NSButton!
    @IBOutlet weak var nextBtn: NSButton!
    @IBOutlet weak var prevBtn: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        self.view.window?.delegate = self
        self.view.window?.minSize = NSSize(width: 1000, height: 600)
        self.view.window?.maxSize = NSSize(width: 1000, height: 600)
        
        if audioPlayer != nil {
            audioPlayer?.pause()
            audioPlayer?.stop()
        }
        
        self.currentPlayUrl = SecurityUtil.shared.aesDecrypt(data.music_url).replacingOccurrences(of: "\0", with: "")
        self.musicLabel.stringValue = data.story_name
        self.preparePlay(playUrl: currentPlayUrl)
        self.becomeFirstResponder()
        
        self.coverImageView.wantsLayer = true
             self.coverImageView.canDrawSubviewsIntoLayer = true
             self.coverImageView.layer?.cornerRadius = 100
             self.coverImageView.layer?.masksToBounds = true
                     
        self.coverImageView.sd_setImage(with: URL.init(string: data.img_url.squareFormat())!, placeholderImage: NSImage.init(named: "image-placeholder-rect"), options: .allowInvalidSSLCertificates, completed: nil)

     
        
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        let minimumSize = NSSize(width: 1000, height: 600)
        return minimumSize
    }
    
      func startPlay() -> Void {
   
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fillMode = .forwards
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(-Double.pi * 2.0)
        rotate.duration = 4
        rotate.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        rotate.isCumulative = true
        rotate.isRemovedOnCompletion = false
        rotate.repeatCount = .greatestFiniteMagnitude
        coverImageView.layer?.position = CGPoint.init(x:coverImageView.frame.midX, y:coverImageView.frame.midY)
        coverImageView.layer?.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        coverImageView.layer?.add(rotate, forKey: nil)

            if self.audioPlayer == nil {
                Common.showToastCenter(self.view, "Loading Please Wait..".localized())
                return
            }
            self.audioPlayer!.numberOfLoops = 0
            self.audioPlayer!.volume = 1.0
            self.audioPlayer?.delegate = self
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()

            
        }
    
    
   
        
        func preparePlay(playUrl: String) -> Void {
            indicatorView.startAnimation(nil)
            indicatorView.isHidden = false
            
            DispatchQueue.global().async {
                let localURL = URL.init(string: playUrl)!
                let audioData = try? Data.init(contentsOf: localURL)
                DispatchQueue.main.async {
                    self.audioPlayer = try? AVAudioPlayer.init(data: audioData!)
                    self.playBtn.image = NSImage.init(named: "toolbar_pause_n")
                    AudioManager.sharedManager.audioPlayer = self.audioPlayer
                    AudioManager.sharedManager.currentIndex = self.currentIndex
                    AudioManager.sharedManager.listData = self.listData
                    self.startTimer()
                    self.indicatorView.isHidden = true
                    self.startPlay()
                }
            }
            
           
        
        }
        
        func startTimer() -> Void {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)

        }
        
    
        @objc func updateProgress() {
            if audioPlayer == nil {
                return
            }
            let progress = Float((self.audioPlayer?.currentTime)!) / Float((self.audioPlayer?.duration)!)
            self.progressIndicator.doubleValue = Double(progress * 100)
            self.endTimeLabel.stringValue = self.timeformat(fromSeconds: Int((self.audioPlayer?.duration)!))!
            self.startTimeLabel.stringValue = self.timeformat(fromSeconds: Int((self.audioPlayer?.currentTime)!))!
        }
        
        func timeformat(fromSeconds seconds: Int) -> String? {
            let totalm: Int = seconds / (60)
            let h: Int = totalm / (60)
            let m: Int = totalm % (60)
            let s: Int = seconds % (60)
            if h == 0 {
                return String(format: "%02d:%02d", m, s)
            }
            return String(format: "%02d:%02d:%02d", h, m, s)
        }
    
    
     func updateMusic() -> Void {
        self.coverImageView.layer?.resumeAnimate()
            let coverUrl = listData[currentIndex].img_url
            let txt = listData[currentIndex].story_name
            self.musicLabel.stringValue = txt
            self.coverImageView.sd_setImage(with: URL.init(string: coverUrl.squareFormat())!, completed: nil)
            self.currentPlayUrl = SecurityUtil.shared.aesDecrypt(listData[currentIndex].music_url).replacingOccurrences(of: "\0", with: "")
            preparePlay(playUrl: currentPlayUrl)
        }
        
        
        func stopEveryThing() -> Void {
            self.pauseImageAnimation()
            self.playBtn.image = NSImage.init(named: "toolbar_play_n")
            
            if audioPlayer != nil {
                self.audioPlayer?.pause()
                self.audioPlayer?.stop()
            }
            
            if AudioManager.sharedManager.audioPlayer != nil {
                AudioManager.sharedManager.audioPlayer.pause()
                AudioManager.sharedManager.audioPlayer.stop()
            }
            
            
        }
        
        func audioControl() -> Void {
            if audioPlayer?.isPlaying ?? false {
                audioPlayer?.pause()
                audioPlayer?.stop()
                self.timer.invalidate()
                self.playBtn.image = NSImage.init(named: "toolbar_play_n")
                self.pauseImageAnimation()
            }else {
                self.playBtn.image = NSImage.init(named: "toolbar_pause_n")
                startPlay()
                startTimer()
                self.coverImageView.layer?.resumeAnimate()
                
            }
        }
        
        func pauseImageAnimation() {
            self.coverImageView.layer?.pauseAnimate()
            
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            print("playFinish")
            self.nextAction("")
        }
    
    @IBAction func playAction(_ sender: Any) {
          self.audioControl()
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        stopEveryThing()
            currentIndex = currentIndex + 1
            
            if (currentIndex > listData.count - 1) {
                currentIndex = 0
            }
            self.updateMusic()
    }
    
    @IBAction func preAction(_ sender: Any) {
        stopEveryThing()
              currentIndex = currentIndex - 1
              if (currentIndex < 0) {
                  currentIndex = listData.count - 1
              }
              self.updateMusic()

    }
    
    func play(playUrl: String) -> Void {
         DownloadApi.downloadFile(url: playUrl) { [weak self] (success) in
             if self == nil {
                 return
             }
             if success {
                 
                 let localURL = URL.init(fileURLWithPath: FileApi.audioPath(url: playUrl))
                 // 用file:// 直接加会报错 如果是中文路径
                 self?.audioPlayer = try! AVAudioPlayer.init(contentsOf: localURL)
                self?.playBtn.image = NSImage.init(named: "toolbar_pause_n")
                 AudioManager.sharedManager.audioPlayer = self?.audioPlayer
                 self?.startTimer()
                 self?.indicatorView.isHidden = true
                 self?.startPlay()
                 
                 
             }else {
                 Common.showToastCenter((self?.view)!, "Download Error,Try Again".localized())
             }
         }
     }
}


