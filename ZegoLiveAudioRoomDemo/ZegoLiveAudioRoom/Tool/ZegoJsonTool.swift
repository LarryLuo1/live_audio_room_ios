//
//  ZegoJsonTool.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/14.
//

import Foundation


/// a `json to model` and `model to json` tool
struct ZegoJsonTool {
    
    /// json to model
    static func jsonToModel<T>(type: T.Type, json: Any) -> T? where T: Codable {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        guard let model = try? JSONDecoder.init().decode(type, from: jsonData) else {
            return nil
        }
        return model
    }
    
    /// model to json string
    static func modelToJson<T>(toString model: T) -> String? where T: Encodable {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }
    
    /// model to json dictionary
    static func modelToJson<T>(toDictionary model: T) -> [String: Any]? where T: Encodable {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any] else {
            return nil
        }
        return dict
    }
    
    /// a dictionary to json str
    static func dictionaryToJson(_ dict: [String : Any]?) -> String? {
        guard let dict = dict else {
            return nil
        }

        let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        guard let data = data else {
            return nil
        }
        let jsonStr = String(data: data, encoding: .utf8)
        guard let jsonStr = jsonStr else {
            return nil
        }
        return jsonStr
    }
    
    /// json string to dictionary
    static func jsonToDictionary(_ jsonStr: String?) -> [String : Any]? {
        
        guard let jsonStr = jsonStr else {
            return nil
        }
        
        if let data = jsonStr.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            } catch {
                
            }
        }
        return nil
    }
}
    