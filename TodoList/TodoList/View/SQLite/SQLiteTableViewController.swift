//
//  SQLiteTableViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/16/24.
//

import UIKit

class SQLiteTableViewController: UITableViewController {

    @IBOutlet var tvListView: UITableView!
    var dataArray: [TodoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
        let longProcessGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tvListView.addGestureRecognizer(longProcessGesture)
    }

    @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            let point = gestureReconizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point ) {
                
                let indexValue = indexPath[1]
                let queryModel = SQLiteTodoList()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                
                let textAlert = UIAlertController(title: "TodoList", message: "해당 항목을 작업완료로 설정 하시겠습니까?", preferredStyle: .alert)
                
                //UIAlertAction 설정 - handler에서 Closure 사용
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                let doneAction = UIAlertAction(title: "완료", style: .default, handler: {ACTION in
                    queryModel.sqlLiteUpdateStatueDB(compledate: formattedDate, status: 1, id: self.dataArray[indexValue].id)
                    self.readValues()
                })
                
                let IncomAction = UIAlertAction(title: "미완료", style: .default)
                
                //UIAlertController에 UIAlertAction 추가
                textAlert.addAction(cancelAction)
                textAlert.addAction(doneAction)
                textAlert.addAction(IncomAction)
                
                present(textAlert, animated: true) //화면띄우기
            }
        }
    }
    
    func readValues() {
        let sqlLiteDB = SQLiteTodoList()
        dataArray.removeAll()
        sqlLiteDB.delegate = self
        sqlLiteDB.sqlLiteQueryDB()
        tvListView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SQLiteTableViewCell
        
        if dataArray[indexPath.row].status == 1 {
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor.white
        }
        
        cell.lblText.text = dataArray[indexPath.row].todoList
        cell.imgView.image = dataArray[indexPath.row].image

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let queryModel = SQLiteTodoList()
            let result = queryModel.sqlLiteDeleteDB(id: Int32(dataArray[indexPath.row].id))
            if result {
                showAlert("결과", "삭제되었습니다.", "확인")
                dataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                showAlert("결과", "삭제에 실패했습니다.", "확인")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func showAlert(_ title: String, _ content: String, _ actionValue:String) {
        let resultAlert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let onAction = UIAlertAction(title: actionValue, style: .default, handler: {ACTION in
            
        })
        resultAlert.addAction(onAction)
        self.present(resultAlert, animated: true)
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        let itemToMove = dataArray[fromIndexPath.row]
        
        let moveValueId = dataArray.remove(at: fromIndexPath.row).id
        
        dataArray.remove(at: fromIndexPath.row)
        
        dataArray.insert(itemToMove, at: to.row)
        
        print("이동한 위치 : ",to.row+1)
        print("움직이는 id값 : ",moveValueId)
        
//        # 9번 : 0 -> 4
//        # seq <= 4
//        # update seq seq-1
        
        let queryModel = SQLiteTodoList()
        let result =  queryModel.sqlLiteUpdateSeq(idValue: moveValueId, moveSeq: (to.row) + 1)
        if result {
            print("성공")
        } else {
            print("땡!")
        }
        
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tvListView.indexPath(for: cell)
            
            let detailController = segue.destination as! DetailSQLiteViewController
            detailController.textValue = dataArray[indexPath!.row].todoList
            detailController.imgValue = dataArray[indexPath!.row].image
            detailController.idValue = dataArray[indexPath!.row].id
        }
    }

}


extension SQLiteTableViewController: SQLiteTodoListProtocol {
    func itemDownloaded(items: [TodoList]) {
        dataArray = items
        tvListView.reloadData()
    }
}
