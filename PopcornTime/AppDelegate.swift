//
//  AppDelegate.swift
//  PopcornTime
//
//  Created by Joe Bloggs on 15/03/2016.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import UIKit
import TVMLKitchen
import PopcornKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let manager = NetworkManager.sharedManager()
        manager.fetchServers { servers, error in
            if let servers = servers {
                if let yts = servers["yts"] as? [String], let eztv = servers["eztv"] as? [String] {
                    manager.setServerEndpoints(yts: yts.first!, eztv: eztv.first!)
                }
            }
        }
        
        let cookbook = Cookbook(launchOptions: launchOptions)
        cookbook.evaluateAppJavaScriptInContext = { appController, jsContext in
            
        }
        
        cookbook.actionIDHandler = ActionHandler.primary
        cookbook.playActionIDHandler = ActionHandler.play
        
        Kitchen.prepare(cookbook)
        
        KitchenTabBar.sharedBar.items = [
            Popular(),
            Latest(),
            Search()
        ]
        
        return true
    }
}

