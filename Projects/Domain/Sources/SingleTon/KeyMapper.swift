//
//  KeyMapper.swift
//  Domain
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire

public class KM {
    public static let shared = KM()

    private static var data: [String: String] = [:]

    private init() {
        KM.loadAndParseData()
    }

    public func configure() {

    }

    private static func loadAndParseData() {
        let url = "http://teamone.kro.kr:9080/project/"

        AF.request(url, method: .get)
            .responseDecodable(of: MapperResponseDTO.self) { response in



                switch response.result {
                case .success(let response):

                    response.category.forEach {
                        self.data[$0.name] = $0.key
                    }

                    response.job.forEach {
                        self.data[$0.name] = $0.key
                        $0.value.forEach {
                            self.data[$0.name] = $0.key
                        }
                    }

                    response.region.forEach {
                        self.data[$0.name] = $0.key
                    }

                case .failure(let error):
                    print("!!!!!!!!!!!\(error)::::")
                    print("MAPPER LOAD ERROR ::: \n\(error.localizedDescription)!!!!!!")
                    print("!!!!!!!!!!!!")
                }
            }
    }

    public static func key(name: String) -> String {
        if let key = data[name] {
            return key
        } else {

            print("!!!!!!!!!!!\(self)::::")
            print("KEY ERROR")
            print("!!!!!!!!!!!!")

            return name
        }
    }
}
