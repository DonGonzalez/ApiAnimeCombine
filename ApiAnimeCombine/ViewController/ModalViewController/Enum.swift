//
//  Enum.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 08/06/2023.
//

import Foundation

extension ModalViewController {
    
    // MARK: ModalVCEnum
    enum UserFilterOption {
        case sort
        case filter
        
        var title: String {
            switch self {
            case .sort: return "Sort"
            case .filter: return  "Filter"
            }
        }
    }
    
    // MARK: Filter Enum
    enum FilterType: String, CaseIterable {
        case winter
        case spring
        case summer
        case fall
        case emptyEnum
        
        var title: String {
            switch self {
            case .winter:
                return "Winter"
            case .spring:
                return "Spring"
            case .summer:
                return "Summer"
            case .fall:
                return "Fall"
            case .emptyEnum:
                return "None"
            }
        }
        
        var filterValue: String {
            switch self {
            case .winter:
                return "&filter[season]=winter"
            case .spring:
                return "&filter[season]=spring"
            case .summer:
                return "&filter[season]=summer"
            case.fall:
                return "&filter[season]=fall"
            case .emptyEnum:
                return ""
            }
        }
        
        static func type( title: String) -> FilterType {
            return FilterType.allCases.first { $0.title == title} ?? .winter
        }
    }
    //MARK: Sort Enum
    enum SortType: String, CaseIterable {
        
        case User_Count
        case Favorites_Count
        case Episode_Count
        
        var title: String {
            switch self {
            case .User_Count:
                return "User Count"
            case .Favorites_Count:
                return "Favorites Count"
            case .Episode_Count:
                return "Episode Count"
            }
        }
        var sortValue: String {
            switch self {
            case .User_Count:
                return "userCount"
            case .Favorites_Count:
                return "favoritesCount"
            case .Episode_Count:
                return "episodeCount"
            }
        }
        
        static func type( title: String) -> SortType {
            return SortType.allCases.first { $0.title == title} ?? .User_Count
        }
    }
}
