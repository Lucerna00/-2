//
//  DiaryLog.swift
//  chatgpt_v2
//
//  Created by 신영재 on 2023/06/19.
//

import Foundation

struct DiaryInfo: Codable {
    var date: String
    var place: String
    var contents: String
    var response: String
}

func testjson(info: DiaryInfo) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let jsonData = try encoder.encode(info)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("[create json data]")
            print("jsonObj: ", jsonString)
            print("")
            
            let decoder = JSONDecoder()
            if let parsedInfo = try? decoder.decode(DiaryInfo.self, from: jsonData) {
                print("[parse json data]")
                print("json data: ", parsedInfo)
                print("place: ", parsedInfo.place)
                print("date: ", parsedInfo.date)
                print("contents: ", parsedInfo.contents)
                print("response: ", parsedInfo.response)
            }
        }
    } catch {
        print(error.localizedDescription)
    }
}

