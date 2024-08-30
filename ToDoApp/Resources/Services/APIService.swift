//
//  APIService.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol APIServiceProtocol: AnyObject{
    func fetchTasks(completion: @escaping ([Todo]) -> () )
}

final class APIService: APIServiceProtocol {
    
    func fetchTasks(completion: @escaping ([Todo]) -> ()) {
        
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let request = URLRequest(url: url)
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        backgroundQueue.asyncAfter(deadline: .now() + 1) {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let responseData = data {
                    do {
                        let tasksResponse = try JSONDecoder().decode(TodoData.self, from: responseData)
                        completion(tasksResponse.todos)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}

