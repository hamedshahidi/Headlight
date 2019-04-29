//
//  SkillColor.swift
//  Headlight
//
//  Created by iosdev on 24/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    a = CGFloat(1.0)
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

class SkillColor {
    
    static private var colors = ["#000000","#00FF00","#0000FF","#FF0000","#01FFFE","#FFA6FE","#006401","#010067","#95003A","#007DB5","#FF00F6","#774D00","#90FB92","#0076FF","#FF937E","#6A826C","#FF029D","#FE8900","#7A4782","#7E2DD2","#85A900","#FF0056","#A42400","#00AE7E","#683D3B","#BDC6FF","#263400","#BDD393","#00B917","#9E008E","#001544","#C28C9F","#FF74A3","#01D0FF","#004754","#E56FFE","#788231","#0E4CA1","#91D0CB","#BE9970","#968AE8","#BB8800","#43002C","#DEFF74","#00FFC6","#FFE502","#620E00","#008F9C","#98FF52","#7544B1","#B500FF","#00FF78","#FF6E41","#005F39","#6B6882","#5FAD4E","#A75740","#A5FFD2","#FFB167","#009BFF","#E85EBE"]
    static private var lastColorIndex = 0
    static private var skillColor: [String:String] = [:]
    
    // Get a color for a skill. Parameter str is a KEY of a skill.
    static func getColor(str: String) -> UIColor? {
        if skillColor.count == 0 {
            assignColors()
        }
        
        var color = ""
        // If there is no color for a skill, assign a color to it
        if !skillColor.keys.contains(str) {
            skillColor[str] = colors[lastColorIndex]
            color = colors[lastColorIndex]
            lastColorIndex += 1
        } else {
            // Get skill color with key
            color = skillColor[str] ?? ""
        }

        return UIColor(hex: color)
    }
    
    // Assign colors to skills for the first time
    static func assignColors() {
        let tempSkills = skills.keys.sorted(by: <)
        
        for skill in tempSkills {
            skillColor[skill] = colors[lastColorIndex]
            lastColorIndex += 1
        }
    }
    
}
