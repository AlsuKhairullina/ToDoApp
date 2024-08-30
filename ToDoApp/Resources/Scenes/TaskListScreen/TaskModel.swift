//
//  TaskModel.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

struct TodoData: Codable {
    var todos: [Todo]
}

struct Todo: Codable {
    
    let id: String
    var todo: String
    var todoDescription: String?
    var date: String?
    var completed: Bool
    let userId: Int
    
    // С API приходят данные без описания и даты, поэтому заданы дефолтные значения
    
    init(id: String, todo: String, todoDescription: String? = nil, date: String? = nil, completed: Bool, userId: Int) {
        self.id = id
        self.todo = todo
        self.todoDescription = todoDescription ?? "No Description"
        self.date = date ?? "Unknown Date"
        self.completed = completed
        self.userId = userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try? container.decode(Int.self, forKey: .id) {
            self.id = String(id)
        } else if let idString = try? container.decode(String.self, forKey: .id) {
            self.id = idString
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "ID не является Int или String")
        }
        todo = try container.decode(String.self, forKey: .todo)
        todoDescription = try container.decodeIfPresent(String.self, forKey: .todoDescription) ?? "No Description"
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? "Unknown Date"
        completed = try container.decode(Bool.self, forKey: .completed)
        userId = try container.decode(Int.self, forKey: .userId)
    }
}
