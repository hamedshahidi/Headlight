//
//  SkillColor.swift
//  Headlight
//
//  Created by iosdev on 24/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit
import GameKit

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
    
    // Calculates contrast rate between two colors (used in general)
    static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
        
        let luminance1 = color1.luminance()
        let luminance2 = color2.luminance()
        
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }
    
    // Calculates contrast rate of a color to another (used on a color)
    func contrastRatio(with color: UIColor) -> CGFloat {
        return UIColor.contrastRatio(between: self, and: color)
    }
    
    func luminance() -> CGFloat {
        
        let ciColor = CIColor(color: self)
        
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.03928) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
    
    // generates random UIColor
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
}

// produce random CGFloats in the range 0 to 1
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

class SkillColor {
    
    static private var colors = ["#00FF00","#0000FF","#FF0000","#01FFFE","#FFA6FE","#006401","#010067","#95003A","#007DB5","#FF00F6","#774D00","#90FB92","#0076FF","#FF937E","#6A826C","#FF029D","#FE8900","#7A4782","#7E2DD2","#85A900","#FF0056","#A42400","#00AE7E","#683D3B","#BDC6FF","#263400","#BDD393","#00B917","#9E008E","#001544","#C28C9F","#FF74A3","#01D0FF","#004754","#E56FFE","#788231","#0E4CA1","#91D0CB","#BE9970","#968AE8","#BB8800","#43002C","#DEFF74","#00FFC6","#FFE502","#620E00","#008F9C","#98FF52","#7544B1","#B500FF","#00FF78","#FF6E41","#005F39","#6B6882","#5FAD4E","#A75740","#A5FFD2","#FFB167","#009BFF","#E85EBE"]
    static private var lastColorIndex = 0
    static private var skillColor: [String:String] = [:]
    static  private var usedColors: [UIColor] = []
    
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
    
    
    // Finds two complementary colors for text and background
    // with a contrast rate suitable for reading.

    // TODO: Fix this, causes an endless loop after 15 colors...

    /*
    static func getPairColors () -> (UIColor, UIColor) {
        
        var color: UIColor = .white
        var complementary: UIColor = .black
        
        let source = GKARC4RandomSource(seed: "hello world".data(using: .utf8)!)
        source.dropValues(1024)
        source.nextInt()
        
        // Random search for non-repeated colors with good contrast rate in between
        repeat {
            
//            let colorIndex = Int.random(in: 0 ..< colors.count)
//            color = UIColor(hex: colors.shuffled()[colorIndex]) ?? .cyan
            
            color = .random()
            
            complementary = getComplementaryForColor(color: color)
            
            print("color")
            print(colorIndex)
            print(usedColors.count)
            print(colors.count)
            
        } while (
            (usedColors.contains(color) ||
                UIColor.contrastRatio(between: color, and: complementary) < 6) && usedColors.count < colors.count
        )
        
        print("found")
        
        usedColors.append(color)
        
        return (color, complementary)
    }
    */
    
    // Generates complementary color of given color
    static func getComplementaryForColor(color: UIColor) -> UIColor {
        
        let ciColor = CIColor(color: color)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
    
}




