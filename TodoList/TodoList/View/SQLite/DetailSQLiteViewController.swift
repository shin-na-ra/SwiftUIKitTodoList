//
//  DetailSQLiteViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/17/24.
//

import UIKit

class DetailSQLiteViewController: UIViewController {

    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    var imageArray: [UIImage?] = []
    var imageArr = ["icon1.png", "icon2.png", "icon3.png"]
    var imgValue: UIImage!
    var textValue: String = ""
    var idValue : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<imageArr.count {
            let image = UIImage(named: imageArr[i])
            imageArray.append(image)
        }
        
        imgView.image = imgValue
        tfText.text = textValue
        pickerView.dataSource = self
        pickerView.delegate = self

    }
    

    @IBAction func btnAction(_ sender: UIButton) {
        let queryModel = SQLiteTodoList()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        guard let text = tfText.text else {return}
        guard let image = imgView.image else {return }
        
        
        let result = queryModel.sqlLiteInsertDB(todo: text, insertdate: formattedDate, compledate: "", status: 0, image: image)
        
        if result {
            showAlert("알림", "수정되었습니다.", "확인")
        } else {
            showAlert("에러", "문제가 발생했습니다.", "확인")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func showAlert(_ title: String, _ content: String, _ actionValue:String) {
        let resultAlert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let onAction = UIAlertAction(title: actionValue, style: .default, handler: {ACTION in
            
            self.navigationController?.popViewController(animated: true)
        })
        resultAlert.addAction(onAction)
        self.present(resultAlert, animated: true)
    }

}


extension DetailSQLiteViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        imageArr.count
    }
}

extension DetailSQLiteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image: imageArray[row])
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return imageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imgView.image = imageArray[row]
    }
}
