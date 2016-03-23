//
//  DescriptionRecipe.swift
//  PopcornTime
//
//  Created by Joe Bloggs on 14/03/2016.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import TVMLKitchen
import PopcornKit

public struct DescriptionRecipe: RecipeType {
    
    let title: String
    let description: String
    
    public let theme = DefaultTheme()
    public let presentationType = PresentationType.Modal
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    public var xmlString: String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        xml += "<document>"
        xml += template
        xml += "</document>"
        return xml
    }
    
    public var template: String {
        var xml = ""
        if let url = NSBundle.mainBundle().URLForResource("DescriptionRecipe", withExtension: "xml") {
            xml = try! String(contentsOfURL: url)
            xml = xml.stringByReplacingOccurrencesOfString("{{TITLE}}", withString: title.cleaned)
            xml = xml.stringByReplacingOccurrencesOfString("{{DESCRIPTION}}", withString: description.cleaned)
        }
        return xml
    }
    
}
