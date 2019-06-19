//
//  Client.swift
//  On the map
//
//  Created by Mac User on 5/1/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

class Client {
    
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let parseId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

    struct Auth{
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/session"
        
        case login
        case logout
        case getStudentLocations(limit: Int)
        case getUserData(userId: String)
        case getStudentLocation(uniqueKey: String)
        case postStudentLocation
        case updateStudentLocation(objectId: String)
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base
            case .logout:
                return Endpoints.base
            case .getStudentLocations(let limit):
                return "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&&order=-updatedAt"
            case .getUserData(let userId):
                return "https://onthemap-api.udacity.com/v1/users/\(userId)"
            case .getStudentLocation(let uniqueKey):
                return "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
            case .postStudentLocation:
                return Endpoints.base
            case .updateStudentLocation(let objectId):
                return Endpoints.base + "/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
        

        @discardableResult class func taskForGETRequest<ResponseType:Decodable>(url:URL, response:ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void)-> URLSessionTask{
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(parseId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                
                var newData: Data
                if url.absoluteString.contains("https://onthemap-api.udacity.com") {
                    newData = data.subdata(in: (5..<data.count))
                } else {
                    newData = data
                }
                
                print(String(data: newData, encoding: .utf8)!)
                
                if let responseObject = try? decoder.decode(ResponseType.self, from: newData) {
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, ClientError.init("Get Request Error."))
                        return
                    }
                }
                
            }
            task.resume()
            
            return task
        }
        
        //MARK: TaskForPostRequest
        class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(parseId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                
                let decoder = JSONDecoder()
                
                if let responseObject = try? decoder.decode(ResponseType.self, from: newData) {
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                        return
                    }
                } else if let responseObject = try? decoder.decode(ErrorResponse.self, from: newData) {
                    DispatchQueue.main.async {
                        completion(nil, ClientError.init(responseObject.error))
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, ClientError.init("Post Request Error"))
                        return
                    }
                }
            }
            task.resume()
        }
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(parseId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            
            if let responseObject = try? decoder.decode(ResponseType.self, from: data) {
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    return
                }
            } else if let responseObject = try? decoder.decode(ErrorResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(nil, ClientError.init(responseObject.error))
                    return
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, ClientError.init("Put Request Error."))
                    return
                }
            }
        }
        task.resume()
    }
        
        class func login(username: String, password: String, completion: @escaping (Bool, Error?)-> Void) {
            let body = LoginRequest(udacity: LoginParameters(username:username, password:password))
            taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) {(response, error) in
                if let response = response {
                    Auth.sessionId = response.session.id
                    Auth.key = response.account.key
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
                
            }
        }
        //MARK: DeleteRequest
        class func logout(completion: @escaping (Bool, Error?)-> Void) {
            var request = URLRequest(url: Endpoints.logout.url)
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    completion(true, nil)
                    return
                }
            }
            task.resume()
        }
        
        class func getStudentLocations(limit: Int,completion: @escaping (Bool, Error?)-> Void) {
            taskForGETRequest(url: Endpoints.getStudentLocations(limit: limit).url, response: StudentLocation.self) { (response, error) in
                if let response = response {
                    ClientData.studentInformations = response.results
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }
        
        class func getUserData(userId: String, completion: @escaping (Bool, Error?)-> Void) {
            taskForGETRequest(url: Endpoints.getUserData(userId: userId).url, response: User.self) { (response, error) in
                if let response = response{
                    Auth.firstName = response.firstName
                    Auth.lastName = response.lastName
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }
        
        class func getStudentLocation(uniqueKey: String, completion: @escaping (Bool, Error?)-> Void) {
            taskForGETRequest(url: Endpoints.getStudentLocation(uniqueKey: uniqueKey).url, response: StudentLocation.self) { (response, error) in
                if let response = response {
                    if let studentLocation = response.results.first {
                        Auth.objectId = studentLocation.objectId
                        ClientData.myStudentInformation = studentLocation
                    }
                    completion(true, nil)
                    return
                }
                
                completion(false, error)
                return
            }
        }
    class func postStudentLocation(studentInformation: StudentInformation, completion: @escaping (Bool, Error?)-> Void){
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: studentInformation) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
                return
            }
            
            completion(false, error)
        }
    }
    
    class func updateStudentLocation(studentInformation: StudentInformation, completion: @escaping (Bool, Error?)-> Void) {
        taskForPUTRequest(url: Endpoints.updateStudentLocation(objectId: Auth.objectId).url, responseType: UpdateLocationResponse.self, body: studentInformation) { (response, error) in
            if let response = response, response.updatedAt != "" {
                completion(true, nil)
                return
            }
            
            completion(false, error)
        }
    }
    
}


