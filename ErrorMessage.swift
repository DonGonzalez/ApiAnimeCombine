//
//  dedefrg.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation

enum ErrorMessage: Error, CustomStringConvertible {
    
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown(Error)
    case goodResponse(statusCode: Int)
    
    var localizedDescription: String {
        // user description
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(statusCode: _):
            return " Sorry the connection to your server failed. "
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        case .goodResponse(statusCode: _):
            return "Good StatusCode"
        }
    }
    
    var description: String {
        // info for debugging
        switch self {
        case .unknown(let err) :
            return "\(err)"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        case .goodResponse(statusCode: let statusCode):
            return "Good response with ststus code \(statusCode)"
        }
    }
}
