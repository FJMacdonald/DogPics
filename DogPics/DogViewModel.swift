//
//  DogViewModel.swift
//  DogPics
//
//  Created by Francesca MACDONALD on 2023-08-28.
//

import Foundation

@MainActor //A singleton actor whose executor is equivalent to the main dispatch queue.
class DogViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var message: String
    }
    @Published var imageURL = ""
    var urlString = "https://dog.ceo/api/breeds/image/random"
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create url from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not ddecode retuned JSON data")
                return
            }
            self.imageURL = returned.message
            print("The image url is \(imageURL)")
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
}
