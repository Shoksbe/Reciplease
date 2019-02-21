//
//  FakeResponse.swift
//  AlamofireTestTests
//
//  Created by Sebastien Bastide on 26/09/2018.
//  Copyright © 2018 Sebastien Bastide. All rights reserved.
//

import Foundation

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
}
