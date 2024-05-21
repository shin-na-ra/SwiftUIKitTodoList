//
//  MysqlDetailViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import UIKit

class MysqlDetailViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    var imgArr = [
        ("http://localhost:8080/Flutter/Images/swift/clock.png", "clock.png", "시계"),
        ("http://localhost:8080/Flutter/Images/swift/cart.png", "cart.png", "장바구니"),
        ("http://localhost:8080/Flutter/Images/swift/pencil.png", "pencil.png", "연필")
    ]
    
    var imageValue = ""
    var textValue = ""
    var imageFile = "http://localhost:8080/Flutter/Images/swift/"
    var idValue = 0
    
    var fileName = ""
    var count = 4
    var checkValue = ""
    
    var imageArray: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfText.text = textValue
        imageFile += imageValue
        
        guard let url = URL(string: imageFile) else {return}
        
        Task {
            do{
                let data = try await loadData(from: url)
                imgView.image = UIImage(data: data)
            } catch let error {
                print("Error: \(error)")
            }
        }
        
        downloadImages()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func loadData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func downloadImages() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            // imageArray가 생성되었는지 확인
            if self.imageArray.count == self.imgArr.count {
                // 생성되었다면 타이머를 중지하고 피커 뷰를 새로 고침
                timer.invalidate()
                self.pickerView.reloadAllComponents()
            }
        }
        
        // 이미지를 비동기적으로 다운로드
        for imageData in imgArr {
            guard let url = URL(string: imageData.0) else { continue }
            downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.imageArray.append(image)
                    
                    if self.imageArray.count == 1 {
                        self.imgView.image = image
                    }
                    
                    if self.imageArray.count == self.imgArr.count {
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    
    func showAlert(_ title: String, _ content: String, _ actionValue:String) {
        let resultAlert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let onAction = UIAlertAction(title: actionValue, style: .default, handler: {ACTION in
            
            self.navigationController?.popViewController(animated: true)
        })
        resultAlert.addAction(onAction)
        self.present(resultAlert, animated: true)
    }
    
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        
        var privateImageValue = ""
        if count == 4 {
            privateImageValue = imageValue
        } else {
            privateImageValue =  imgArr[count].1
        }
        
        print("privateImageValue : \(privateImageValue)")
        
        guard let todo = tfText.text else {return}
        
        let mysqlQueryModel = MysqlQueryModel()
        let result = mysqlQueryModel.updateQuery(image: privateImageValue, todo: todo, id: idValue)
        
        if result {
            showAlert("알림", "수정되었습니다.", "확인")
        } else {
            showAlert("알림", "수정에 문제가 생겼습니다.", "확인")
        }
    }

}



extension MysqlDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imgArr.count
    }
}

extension MysqlDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 이미지 배열이 비어 있는지 확인
        guard row < imageArray.count else {
            // 배열이 비어 있거나 유효한 인덱스를 가지고 있지 않으면 기본 뷰를 반환
            return UIView()
        }
        
        let imageView = UIImageView(image: imageArray[row])
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return imageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imgView.image = imageArray[row]
        count = row
        print("count : \(count)")
    }
}
