//
//  ActionHandler.swift
//  PopcornTime
//
//  Created by Joe Bloggs on 15/03/2016.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import TVMLKitchen
import PopcornKit
import PopcornTorrent
import YoutubeSourceParserKit
import AVKit

struct ActionHandler {
    
    /**
     The action handler for when the primary (select) button is pressed
     
     - parameter id: The actionID of the element pressed
     */
    static func primary(id: String) {
        print(id)
        let pieces = id.componentsSeparatedByString(":")
        switch pieces.first! {
            case "showMovie":
//                Kitchen.serve(xmlFile: "Loading.xml", type: .Modal)
                NetworkManager.sharedManager().showDetailsForMovie(movieId: Int(pieces.last!)!, withImages: false, withCast: true) { movie, error in
//                    Kitchen.dismissModal()
                    if let movie = movie {
                        NetworkManager.sharedManager().suggestionsForMovie(movieId: Int(pieces.last!)!, completion: { movies, error in
                            if let movies = movies {
                                let product = ProductRecipe(movie: movie, suggestions: movies)
                                Kitchen.serve(recipe: product)
                            } else if let _ = error {
                                
                            }
                        })
                    } else if let _ = error {
                        
                    }
                }
            
        case "playMovie":
            // {{MAGNET}}:https:{{IMAGE}}:http:{{BACKGROUND_IMAGE}}:{{TITLE}}:{{SHORT_DESCRIPTION}}
            let magnet = "magnet:?xt=urn:btih:\(pieces[1])&tr=" + Trackers.map { $0 }.joinWithSeparator("&tr=")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ProgressViewController") as! ProgressViewController
            
            viewController.magnet = magnet
            viewController.imageAddress = pieces[3]
            viewController.backgroundImageAddress = pieces[5]
            viewController.movieName = pieces[6]
            viewController.shortDescription = pieces[7]
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                Kitchen.appController.navigationController.pushViewController(viewController, animated: true)
            })
            
        case "playPreview":
            Youtube.h264videosWithYoutubeURL(NSURL(string: pieces.last!)!, completion: { videoInfo, error in
                if let videoInfo = videoInfo {
                    if let url = videoInfo["url"] as? String {
                        let playerController = AVPlayerViewController()
                        playerController.player = AVPlayer(URL: NSURL(string: url)!)
                        playerController.player?.play()
                        Kitchen.appController.navigationController.pushViewController(playerController, animated: true)
                    }
                }
            })
            
        case "addWatchlist": break
            
        case "showDescription":
            Kitchen.serve(recipe: DescriptionRecipe(title: pieces[1], description: pieces.last!))
            
        default: break
        }

    }
    
    /**
     The action handler for when the play button is pressed
     
     - parameter id: The actionID of the element pressed
     */
    static func play(id: String) {
        
    }
    
}