//
//  QueryModel.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import Foundation

protocol MysqlModelProtocol {
    func itemDownloaded(items: [MySQLTodoList])
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
        var locations: [MySQLTodoList] = []
        
        do {
            let todoLists = try decoder.decode([MySqlTodoListDB].self, from : data)
            
            for todolist in todoLists {
                let query = MySQLTodoList(id: todolist.id, todoList: todolist.todo, insertdate: todolist.insertdate, compledate: todolist.compledate, status: todolist.status, seq: todolist.seq, image: todolist.image)
                locations.append(query)
            }
        } catch let error {
            print("Faile : \(error)")
        }
        
        DispatchQueue.main.async {
            self.delegate.itemDownloaded(items: locations)
        }
    }
    
    //insert
    func insertQuery(image: String, insertdate: String, status: Int, todo: String) -> Bool {
        
        var result = true
        var content = "?image=\(image)&insertdate=\(insertdate)&status=\(status)&todo=\(todo)"
        
        var urlPath = "http://localhost:8080/Flutter/JSP/todoList/todoInsert.jsp"
        urlPath += content
        
        print("urlPath >>>>>>>> \(urlPath)")
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        
        DispatchQueue.global().async {
            do {
                _ = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    result = true
                }
            } catch let error{
                print("error >>>>>>> \(error)")
                result = false
            }
        }
        
        return result
    }
    
    
    //update
    func updateQuery(image: String, todo: String, id: Int) -> Bool {
        
        var result = true
        var content = "?image=\(image)&todo=\(todo)&id=\(id)"
        
        var urlPath = "http://localhost:8080/Flutter/JSP/todoList/todoUpdate.jsp"
        urlPath += content
        
        print("urlPath >>>>>>>> \(urlPath)")
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        
        DispatchQueue.global().async {
            do {
                _ = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    result = true
                }
            } catch let error{
                print("error >>>>>>> \(error)")
                result = false
            }
        }
        
        return result
    }
    
    //delete
    func deleteQuery(id: Int) -> Bool {
        
        var result = true
        var content = "?id=\(id)"
        
        var urlPath = "http://localhost:8080/Flutter/JSP/todoList/todoDelete.jsp"
        urlPath += content
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        print("rurl r >>> : ",url)
        
        DispatchQueue.global().async {
            do {
                _ = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    result = true
                }
            } catch let error{
                print("error >>>>>>> \(error)")
                result = false
            }
        }
        
        return result
    }
    
    
}
