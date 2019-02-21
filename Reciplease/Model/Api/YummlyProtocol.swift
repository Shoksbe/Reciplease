//
//  YummlyProtocol.swift
//  Reciplease
//
//  Created by Gregory De knyf on 20/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import Alamofire

protocol YummlyProtocol {
    func request(url: URL, method: HTTPMethod, parameters: Parameters?, header: HTTPHeaders, completionHandler: @escaping (DataResponse<Any>) -> Void)
}
