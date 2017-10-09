import Foundation

private func convertNibble(_ value: UInt8) -> UInt8? {
    if (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(value) {
        return value - UInt8(ascii: "0")
    }
    if (UInt8(ascii: "a")...UInt8(ascii: "f")).contains(value) {
        return value - UInt8(ascii: "a") + 10
    }
    if (UInt8(ascii: "A")...UInt8(ascii: "F")).contains(value) {
        return value - UInt8(ascii: "A") + 10
    }
    return nil
}

private func convertByte(highNibble: UInt8, lowNibble: UInt8) -> UInt8? {
    guard let low = convertNibble(lowNibble), let high = convertNibble(highNibble)
        else { return nil }
    
    return (high << 4) | low
}
extension Data {
    
    init?(hexString: String) {

        let cleanString: String
        if hexString.hasPrefix("0x") {
            cleanString = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 2)...]).replacingOccurrences(of: " ", with: "")
        } else {
            cleanString = hexString.replacingOccurrences(of: " ", with: "")
        }
        
        guard hexString.characters.count % 2 == 0 else {
            return nil
        }
        
        var highHexChar: UInt8?
        
        var bytes: [UInt8] = []
        for c in cleanString.utf16 {
            guard c < 127 else {
                return nil }
            
            if let highChar = highHexChar {
                guard let byte = convertByte(highNibble: highChar, lowNibble: UInt8(c)) else { return nil }
                bytes.append(byte)
                highHexChar = nil
            } else {
                highHexChar = UInt8(c)
            }
        }
        
        self.init(bytes: bytes)
    }
    
    func hexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
