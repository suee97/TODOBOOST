import UIKit

extension UIColor {
    static var primaryPurple: UIColor {
        return UIColor(red: 20/255, green: 10/255, blue: 38/255, alpha: 1)
    }
    
    static var secondaryPurple: UIColor {
        return UIColor(red: 34/255, green: 23/255, blue: 56/255, alpha: 1)
    }
    
    static var tabBarColor: UIColor {
        return UIColor(red: 239/255, green: 245/255, blue: 248/255, alpha: 1)
    }
    
    static var calendarSelected: UIColor {
        return UIColor.white.withAlphaComponent(0.5)
    }
    
    static var secondaryWhite: UIColor {
        return UIColor(red: 223/255, green: 223/255, blue: 228/255, alpha: 1)
    }
    
    static var primaryMint: UIColor {
        return UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
    }
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}


