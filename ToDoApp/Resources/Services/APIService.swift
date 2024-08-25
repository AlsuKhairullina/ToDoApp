//
//  APIService.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol APIServiceProtocol: AnyObject{
    func fetchTasks() async throws -> TodoData
}

final class APIService: APIServiceProtocol {
    
    func fetchTasks() async throws -> TodoData {
        
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let tasksResponse = try JSONDecoder().decode(TodoData.self, from: data)
        return tasksResponse
    }
}

