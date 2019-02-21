//
//  YummlySession.swift
//  Reciplease
//
//  Created by Gregory De knyf on 20/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import Alamofire

class YummlySesion: YummlyProtocol {
    func request(url: URL,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 header: HTTPHeaders,
                 completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, headers: header)
                 .responseJSON { responseData in
                    completionHandler(responseData)
        }
        
    }
}
