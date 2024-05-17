//
//  SQLiteTodoList.swift
//  TodoList
//
//  Created by 신나라 on 5/16/24.
//

import Foundation
import SQLite3
import UIKit

protocol SQLiteTodoListProtocol {
    func itemDownloaded(items: [TodoList])
}

class SQLiteTodoList {
    
    var db: OpaquePointer?
    var todoList: [TodoList] = []
    var delegate: SQLiteTodoListProtocol!

    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "sqliteTodoList.sqlite")
        
        //sqlite3_open : 특정 파일 열고 없으면 생성
        if sqlite3_open(fileURL.path(percentEncoded: true), &db ) != SQLITE_OK {
            print("Error opening database")
        }
        
        //table 만들기
        if sqlite3_exec(db, "create table if not exists todo(id integer primary key autoincrement, todo text, insertdate text, compledate text, status integer, seq integer, image BLOB)", nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error create table: \(errMsg)")
        }
    }
    
    
    func sqlLiteQueryDB() {
        var stmt: OpaquePointer?
        let queryString = " select * from todo order by seq"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errMsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let todo = String(cString: sqlite3_column_text(stmt, 1))
            let insertdate = String(cString: sqlite3_column_text(stmt, 2))
            let compledate = String(cString: sqlite3_column_text(stmt, 3))
            let status = Int(sqlite3_column_int(stmt, 4))
            let seq = Int(sqlite3_column_int(stmt, 5))
            var image: UIImage = UIImage()
            
            if let dataBlob = sqlite3_column_blob(stmt, 6) {
                let dataBlobLength = sqlite3_column_bytes(stmt, 6)
                let data = Data(bytes: dataBlob, count: Int(dataBlobLength))
                image = UIImage(data: data)!
            }
            
            todoList.append(TodoList(id: id, todoList: todo, insertdate: insertdate, compledate: compledate, status: status, seq: seq, image: image))
        }
        
        delegate.itemDownloaded(items: todoList)
    }
    
    func sqlLiteInsertDB(todo: String, insertdate: String, compledate: String, status: Int, image: UIImage) -> Bool{
        var stmt: OpaquePointer?
        var newSeq: Int32 = 0
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let query = "SELECT MAX(IFNULL(seq, 1)) FROM todo;"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                let currentSeq = sqlite3_column_int(stmt, 0) //현재 seq
                newSeq = currentSeq + 1     // 새로운 seq 값
            } else {
                print("쿼리 실행 결과가 SQLITE_ROW가 아닙니다.")
            }
            sqlite3_finalize(stmt)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("쿼리 실행 중 오류 발생: \(errorMessage)")
        }
        
        
        let queryString = "insert into todo (todo, insertdate, compledate, status, seq, image) values (?,?,?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, todo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, insertdate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, compledate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, Int32(status))
        sqlite3_bind_int(stmt, 5, newSeq)
        let imageData = image.jpegData(compressionQuality: 0.4)! as NSData
        sqlite3_bind_blob(stmt, 6, imageData.bytes, Int32(imageData.length), SQLITE_TRANSIENT)
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }
    
    
    func sqlLiteDeleteDB(id: Int32) -> Bool {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "delete from todo where id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, id)
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }
    
    func sqlLiteUpdateDB(todo: String, image: UIImage, id: Int) -> Bool{
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "update todo set todo = ?, image = ? where id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, todo, -1, SQLITE_TRANSIENT)
        
        let imageData = image.jpegData(compressionQuality: 0.4)! as NSData
        sqlite3_bind_blob(stmt, 2, imageData.bytes, Int32(imageData.length), SQLITE_TRANSIENT)
        
        sqlite3_bind_int(stmt, 3, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            return false
        }
    }
}
