//
//  AppDelegate.swift
//  John OS X
//
//  Created by Chris Svenningsen on 2/5/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var queueMenuItem: NSMenuItem!
    var statusItem: NSStatusItem?;
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var statusBar = NSStatusBar.systemStatusBar();
        statusItem = statusBar.statusItemWithLength(-1);
        statusItem!.image = NSImage.init(named: "john-24.png");
        
        statusItem!.menu = self.menu;
        statusItem!.highlightMode = true;
        
        var interval = NSTimeInterval(1.0);
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerDidFire", userInfo: nil, repeats: true);
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func timerDidFire() {
        Alamofire.request(.GET, "http://192.168.7.5:9393/bathroom")
            .responseJSON() { (_, _, JSON, _) in
                if(JSON == nil) {
                    return;
                } else {
                    var currentStatus = JSON!.valueForKey("occupied") as NSInteger;
                    self.updateStatusItemBasedOnStatus(currentStatus);
                }
        }
    }
    
    func updateStatusItemBasedOnStatus(status: NSInteger) {
        var newImage = NSImage.init(named: "john-24.png");
        
        if(status == 0) {
            newImage = NSImage.init(named: "john-24-green.png");
        } else if (status == 1) {
            newImage = NSImage.init(named: "john-24-red.png");
        }
        
        statusItem!.image = newImage;
    }
    
    @IBAction func queue(sender: AnyObject) {
        var username = NSUserName();
        Alamofire.request(.POST, "http://127.0.0.1:9393/queue", parameters: ["name": username])
            .response() { (_,_,JSON,_) in
                println(JSON);
        }
    }
}