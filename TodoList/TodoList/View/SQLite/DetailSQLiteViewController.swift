//
//  DetailSQLiteViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/17/24.
//

import UIKit
import PhotosUI

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

    }
    

    @IBAction func btnAction(_ sender: UIButton) {
        let queryModel = SQLiteTodoList()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        guard let text = tfText.text else {return}
        guard let image = imgView.image else {return }
        
        
        let result = queryModel.sqlLiteUpdateDB(todo: text, image: image, id: idValue)
        
        if result {
            showAlert("알림", "수정되었습니다.", "확인")
        } else {
            showAlert("에러", "문제가 발생했습니다.", "확인")
        }
    }
    
    
    @IBAction func showImage(_ sender: UIButton) {
        let phoneAlert = UIAlertController(title: "이미지 가져오기", message: "갤러리에서 이미지를 가져옵니다.", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        phoneAlert.addAction(okAction)
        phoneAlert.addAction(cancelAction)
        
        present(phoneAlert, animated: true)
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


extension DetailSQLiteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                DispatchQueue.main.async {
                    self.imgView.image = image as? UIImage
                }
            })
        }
    }
}
