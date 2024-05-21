//
//  QueryModel.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import Foundation

protocol MysqlModelProtocol {
    func itemDownloaded(items: [FirebaseModel])
}

struct MysqlQueryModel {
    var delegate: MysqlModelProtocol!
    let urlPath = "http://localhost:8080/Flutter/JSP/todoList/todoQuery.jsp"
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.parseJSON(data!)
            }
        }
    }
    
    func parseJSON(_ data: Data) {
        let decoder = JSONDecoder()
        var locations: [FirebaseModel] = []
        
        do {
            let todoLists = try decoder.decode([TodoListDB].self, from : data)
            
            for todolist in todoLists {
                let query = FirebaseModel(id: todolist.id, todoList: todolist.todoList, insertdate: todolist.insertdate, compledate: todolist.compledate, status: todolist.status, seq: todolist.seq, image: todolist.image)
                locations.append(query)
            }
        } catch let error {
            print("Faile")
        }
        
        DispatchQueue.main.async {
            self.delegate.itemDownloaded(items: locations)
        }
    }
}
