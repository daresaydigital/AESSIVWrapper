//
//  AESSivWrapperTests.swift
//  AESSivWrapperTests
//
//  Created by Elyas Naranjee on 2017-09-29.
//  Copyright © 2017 Daresay AB. All rights reserved.
//

import XCTest
@testable import AESSivWrapper

class AESSivWrapperTests: XCTestCase {
    
    func testSivDecrypt() {
        let AESKey: Data = Data(hexString: "0x90A3254A4EE159C21D53F9F68502E367")!
        let CMACKey: Data = Data(hexString: "F2324BD1B9AD7A0E7D3C1DDB2F6F99AC")!
        let SivKey = CMACKey + AESKey
        let encryptedData: Data = Data(hexString: "ABE2CC830A1F31774F4F0790BD861AEB7B92CD5785E263CEE921E420DD0A33")!
        let expectedResult: Data = Data(hexString: "80054D65616473810641647269616E")!
        let result = AESSivWrapper.aesSivDecrptData(encryptedData, key: SivKey)!
        XCTAssertEqual(result, expectedResult)
    }
}
