//
//  FireAddViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

import UIKit
import FirebaseStorage

class FireAddViewController: UIViewController {

    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    let picker = UIImagePickerController()
    var downURL: String = ""
    
    var success = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnShowImage(_ sender: UIButton) {
        let photoAlert = UIAlertController(title:"이미지 가져오기",message: "갤러리에서 사진을 가져옵니다. ", preferredStyle: .actionSheet)
        let okAciton = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true)
            
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        photoAlert.addAction(okAciton)
        photoAlert.addAction(cancelAction)
        
        present(photoAlert, animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
            
        guard let todo = tfText.text else {return}
        var image = downURL
        print("imageURL >>>> \(image)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        if !todo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let insertModel = insertModel()
            let result = insertModel.insertItems(todo: todo, insertdate: formattedDate , compledate: "", status: 0, image: image)
            
            if result {
                showAlert("알림", "입력이 되었습니다.", "확인")
            } else {
                showAlert("알림", "입력에 문제가 생겼습니다.", "확인")
            }
        }
    }
    
    func insertImage(todo : String) {
        
        print("dddd : todo  : \(todo)")
        
        let storageRef = Storage.storage().reference()
        
        let image  = imgView.image!
        // image -> jpg 줄인다.
        guard let imageData = image.jpegData(compressionQuality: 0.4) else{return}
        
        let imageRef = storageRef.child("images/\(todo).jpg") // file type 이 있어야함. !!
        
        // image meta data setting
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Upload the file to the path "images/___.jpg"
        
        // guard  문장을 쓰는 이유는 if 를 쓰면 else 를 써야하지만 guard 는 else 를 먼저 실행한다.
        imageRef.putData(imageData, metadata: metaData){metaData, error in
            guard metaData != nil else{
                print("Error: putfile")
                return
            }
            // 내려 오면 ! 입력이 된상태이다. 주소를 알아보자.
            // download URL after upload <- 다운을 해보아햔다.
            
            imageRef.downloadURL(completion: {url, error in
                guard let downloadURL = url else {
                    print("Error : DownloadURL")
                    return
                }
                    self.downURL = "\(downloadURL)"
                print(self.downURL)
            })
            
            print("----- Comleted to insert a image ")
            print("1")
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

extension FireAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
        }
            
        insertImage(todo: tfText.text!)
        dismiss(animated: true)
    }
}
