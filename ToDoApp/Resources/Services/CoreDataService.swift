//
//  CoreDataService.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceProtocol: AnyObject {
    func saveToCoreData(tasks: [Todo])
    func fetchTodos(completion: @escaping ([Todo]) -> Void)
    func updateTodo(with id: String, newTitle: String, newDescription: String, newStatus: Bool)
    func addNewTodo(title: String, description: String, completed: Bool)
    func deleteTodo(with id: String)
}

final class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    let context = CoreDataStack.shared.context
    
    func saveToCoreData(tasks: [Todo]) {
        for task in tasks {
            _ = self.castModel(task)
        }
        do {
            try self.context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetchTodos(completion: @escaping ([Todo]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        var todos = [Todo]()
        do {
            let todoEntities = try self.context.fetch(fetchRequest) as? [TodoEntity]
            todoEntities?.forEach { entity in
                let todo = self.castEntity(entity)
                todos.append(todo)
            }
            completion(todos)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func updateTodo(with id: String, newTitle: String, newDescription: String, newStatus: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let todoEntities = try self.context.fetch(fetchRequest) as? [TodoEntity]
            if let entity = todoEntities?.first {
                entity.todo = newTitle
                entity.todoDescription = newDescription
                entity.completed = newStatus
                try context.save()
            }
        } catch {
            print("Error updating data: \(error)")
        }
    }
    
    
    func addNewTodo(title: String, description: String, completed: Bool) {
        
        let todoEntity = TodoEntity(context: self.context)
        todoEntity.id = UUID().uuidString
        todoEntity.todo = title
        todoEntity.todoDescription = description
        todoEntity.date = Date().formatted()
        todoEntity.completed = completed
        do {
            try self.context.save()
        } catch {
            print("Could not save new task")
        }
    }
    
    func deleteTodo(with id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let todos = try self.context.fetch(fetchRequest)
            if let todoToDelete = todos.first {
                self.context.delete(todoToDelete as! NSManagedObject)
                try self.context.save()
                print("Task with id \(id) was deleted")
            } else {
                print("Task with id \(id) was not found")
            }
        } catch {
            print("Error while trying delete todo: \(error.localizedDescription)")
        }
    }
    
}

private extension CoreDataService {
    
    func castEntity(_ entity: TodoEntity) -> Todo {
        return Todo(id: entity.id,
                    todo: entity.todo ?? "",
                    todoDescription: entity.todoDescription,
                    date: entity.date,
                    completed: entity.completed,
                    userId: Int(entity.userId))
    }
    
    func castModel(_ model: Todo) -> TodoEntity {
        let todoEntity = TodoEntity(context: context)
        todoEntity.id = hashToUUID(from: Int(model.id) ?? 0).uuidString
        todoEntity.todo = model.todo
        todoEntity.todoDescription = model.todoDescription
        todoEntity.date = model.date
        todoEntity.completed = model.completed
        todoEntity.userId = Int32(model.userId)
        return todoEntity
    }
    
    func hashToUUID(from intValue: Int) -> UUID {
        var hasher = Hasher()
        hasher.combine(intValue)
        let hashValue = hasher.finalize()
        
        var uuidBytes = [UInt8](repeating: 0, count: 16)
        let hashBytes = withUnsafeBytes(of: hashValue.bigEndian) { Array($0) }
        
        for i in 0..<min(hashBytes.count, uuidBytes.count) {
            uuidBytes[i] = hashBytes[i]
        }
        
        return UUID(uuid: uuidBytes.withUnsafeBufferPointer { $0.baseAddress!.withMemoryRebound(to: uuid_t.self, capacity: 1) { $0.pointee } })
    }
}
