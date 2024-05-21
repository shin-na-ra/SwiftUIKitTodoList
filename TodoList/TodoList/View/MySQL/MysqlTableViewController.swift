//
//  MysqlTableViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import UIKit

class MysqlTableViewController: UITableViewController {

    @IBOutlet var tvListView: UITableView!
    
    var dataArray: [MySQLTodoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    func readValues() {
        var mysqlQueryModel = MysqlQueryModel()
        mysqlQueryModel.delegate = self
        mysqlQueryModel.downloadItems()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMysql", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let url = "http://localhost:8080/Flutter/Images/swift/"
        let image = "\(dataArray[indexPath.row].image)"
        
        let urlPath = url + image
        
        var urlImage: UIImage?
        
        DispatchQueue.global().async {
            if let data = try?Data(contentsOf: URL(string: urlPath)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        content.image = image
                        cell.contentConfiguration = content
                    }
                }
            }
        }
        
        content.text = dataArray[indexPath.row].todoList
        cell.contentConfiguration = content

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
            
            let mysqlQueryModel = MysqlQueryModel()
            print("id : \(dataArray[indexPath.row].id)")
            let result = mysqlQueryModel.deleteQuery(id: dataArray[indexPath.row].id)
            
            if result {
                showAlert("알림", "삭제되었습니다.", "확인")
                dataArray.remove(at: indexPath.row)
            } else {
                showAlert("알림", "삭제에 문제가 생겼습니다.", "확인")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func showAlert(_ title: String, _ content: String, _ actionValue:String) {
        let resultAlert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let onAction = UIAlertAction(title: actionValue, style: .default, handler: {ACTION in
            
            self.navigationController?.popViewController(animated: true)
        })
        resultAlert.addAction(onAction)
        self.present(resultAlert, animated: true)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "myDetail" {
            let detailController = segue.destination as! MysqlDetailViewController
            
            let cell = sender as! UITableViewCell
            let indexPath = tvListView.indexPath(for: cell)
            
            detailController.textValue = dataArray[indexPath!.row].todoList
            detailController.imageValue = dataArray[indexPath!.row].image
            detailController.idValue = dataArray[indexPath!.row].id
        }
    }

}

extension MysqlTableViewController: MysqlModelProtocol {
    func itemDownloaded(items: [MySQLTodoList]) {
        dataArray = items
        tvListView.reloadData()
    }
}
