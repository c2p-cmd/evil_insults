//
//  API.swift
//  EvilInsults
//
//  Created by Sharan Thakur on 03/01/24.
//

import AppIntents
import Observation
import SwiftUI

struct LanguageConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Choose a language"
    
    @Parameter(title: "Language Input", default: Languages.en)
    var language: Languages
    
    func perform() async throws -> some ReturnsValue<String> {
        let service = APIService()
        return .result(value: await service.fetchAndReturnInsult(in: language))
    }
}

enum Languages: String, Identifiable, CaseIterable, AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Languages Enum"
    
    static var caseDisplayRepresentations: [Languages : DisplayRepresentation] = [
        .en: "English",
        .hi: "Hindi",
        .de: "German"
    ]
    
    case en = "English"
    case hi = "Hindi"
    case de = "German"
    
    var id: String {
        self.rawValue
    }
    
    var code: String {
        switch self {
        case .en:
            "en"
        case .hi:
            "hi"
        case .de:
            "de"
        }
    }
}

@Observable
class APIService {
    private let apiURL = "https://evilinsult.com/generate_insult.php"
    
    var language: Languages
    var insult: String
    var error: Error?
    var isBusy: Bool
    
    init() {
        self.language = .en
        self.insult = "Monkey"
        self.error = nil
        self.isBusy = false
    }
    
    func fetchJoke() {
        Task {
            var url = URL(string: apiURL)!
            let queryItems = [
                URLQueryItem(name: "lang", value: language.code),
                URLQueryItem(name: "type", value: "text")
            ]
            url.append(queryItems: queryItems)
            
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            
            withAnimation {
                isBusy = true
            }
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let text = String(decoding: data, as: UTF8.self)
                withAnimation {
                    self.insult = text
                    self.isBusy = false
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.description)
                }
            } catch {
                self.error = error
                withAnimation {
                    self.isBusy = false
                }
            }
        }
    }
    
    func fetchAndReturnInsult(in language: Languages) async -> String {
        var url = URL(string: apiURL)!
        let queryItems = [
            URLQueryItem(name: "lang", value: language.code),
            URLQueryItem(name: "type", value: "text")
        ]
        url.append(queryItems: queryItems)
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return String(decoding: data, as: UTF8.self)
        } catch {
            return "Monkey penis sucker!"
        }
    }
}
