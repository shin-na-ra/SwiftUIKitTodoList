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
        self.navigationItem.leftBarButtonItem?.title = "편집"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
        if let title = self.navigationItem.leftBarButtonItem?.title, title == "edit" {
           self.navigationItem.leftBarButtonItem?.title = "편집"
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
        
        dataArray.remove(at: fromIndexPath.row)
        
        dataArray.insert(itemToMove, at: to.row)
        
        print("fromindexPath : ",fromIndexPath.row)
        print("to : ",to.row)
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
