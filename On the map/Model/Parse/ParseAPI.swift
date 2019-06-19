//
//  ParseAPI.swift
//  On the map
//
//  Created by Mac User on 5/1/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

//class ParseAPI {
//
//    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
//    static let parseId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
//
//    enum Endpoints: String {
//        static let base = "https://parse.udacity.com/parse/classes"
//
//        case studentLocations
//
//        var stringValue: String {
//            switch self {
//
//            case .studentLocations: return Endpoints.base + "/StudentLocation"
//
//            }
//        }
//        var url: URL {
//            return URL(string: self.stringValue)!
//        }
//    }
//
//
//    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data) as Error
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//
//        return task
//    }
//
//    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = try! JSONEncoder().encode(body)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data) as Error
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//
//    class func fetchStudentLocations(completionHandler: @escaping ([String], Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: Endpoints.studentLocations.url) { (data, response, error) in
//            guard let data = data else {
//                completionHandler([], error)
//                return
//            }
//        }
//        task.resume()
//    }
//
//}
