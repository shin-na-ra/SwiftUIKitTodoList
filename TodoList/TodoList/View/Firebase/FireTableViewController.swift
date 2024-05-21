//
//  FireTableViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

import UIKit
import FirebaseStorage

class FireTableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    var dataArray: [FirebaseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    func readValues() {
        var queryModel = QueryModel()
        queryModel.delegate = self
        queryModel.downloadItems()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "fireCell", for: indexPath) as! FireTableViewCell

        cell.lblText.text = self.dataArray[indexPath.row].todoList
        
        let storage = Storage.storage()
        let httpResponse = storage.reference(forURL: self.dataArray[indexPath.row].image)
        
        httpResponse.getData(maxSize: 1*1024*1024, completion: {data, error in
            if let error = error {
                print("Error : \(error)")
            } else {
                cell.imgView.image = UIImage(data: data!)
            }
        })
            
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
            // Delete the row from the data source
            let deleteModel = DeleteModel()
            let result = deleteModel.deleteItems(documentId: dataArray[indexPath.row].id)
            
            if result {
                showAlert("알림", "삭제되었습니다.", "확인")
                dataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                showAlert("알림", "삭제에 문제가 생겼습니다.", "확인")
            }
            
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
        
        if segue.identifier == "FireDetail" {
            let detailController = segue.destination as! FireDetailViewController
            
            let cell = sender as! FireTableViewCell
            let indexPath = tvListView.indexPath(for: cell)
            
            detailController.textValue = dataArray[indexPath!.row].todoList
            detailController.idValue = dataArray[indexPath!.row].id
            detailController.imageValue = dataArray[indexPath!.row].image
            
        }
            
    }

}

extension FireTableViewController: QueryModelProtocol {
    func itemDownloaded(items: [FirebaseModel]) {
        dataArray = items
        tvListView.reloadData()
    }
}
