//
//  FireDetailViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import UIKit
import FirebaseStorage

class FireDetailViewController: UIViewController {

    var imageValue: String = ""
    var textValue: String = ""
    var idValue: String = ""
    
    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfText.text = textValue
        let storage = Storage.storage()
        let httpReference = storage.reference(forURL: imageValue) // http 주소로 가져온다.
        
        httpReference.getData(maxSize: 1*1024*1024, completion: { data, error in
            if let error = error {
                print("ERROR : \(error)")
            } else {
                self.imgView.image = UIImage(data: data!)
            }
        })
    }
    

    @IBAction func btnUpdate(_ sender: UIButton) {
        
        guard let todo = tfText.text else {return}
        
        let updateModel = UpdateModel()
        let result = updateModel.updateItems(documentId: idValue, todo: todo)
        
        if result {
            showAlert("알림", "수정되었습니다.", "확인")
        } else {
            showAlert("알림", "수정에 문제가 생겼습니다..", "확인")
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

}
