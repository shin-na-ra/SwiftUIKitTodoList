//
//  MysqlAddViewController.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import UIKit

class MysqlAddViewController: UIViewController {

    @IBOutlet weak var tfText: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    
    var imgArr = [
        ("http://localhost:8080/Flutter/Images/swift/clock.png", "clock.png", "시계"),
        ("http://localhost:8080/Flutter/Images/swift/cart.png", "cart.png", "장바구니"),
        ("http://localhost:8080/Flutter/Images/swift/pencil.png", "pencil.png", "연필")
    ]
    
    var fileName = ""
    var count = 0
    var checkValue = ""
    
    var imageArray: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImages()
        
        picker.dataSource = self
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func downloadImages() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            // imageArray가 생성되었는지 확인
            if self.imageArray.count == self.imgArr.count {
                // 생성되었다면 타이머를 중지하고 피커 뷰를 새로 고침
                timer.invalidate()
                self.picker.reloadAllComponents()
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
                        self.picker.reloadAllComponents()
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
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        if tfText.text!.isEmpty {
            let textAlert = UIAlertController(title: "경고", message: "데이터를 입력하세요", preferredStyle: .alert)
            let actionDefault = UIAlertAction(title: "확인", style: .default)
            textAlert.addAction(actionDefault)
            present(textAlert, animated: true)
        } else {
            
            var mysqlQueryModel = MysqlQueryModel()
            guard let todo = tfText.text else {return}
            
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: currentDate)
            let dateSubstring = String(dateString.prefix(10))
            
            print("dfdf : \(dateSubstring)")
            var result = mysqlQueryModel.insertQuery(image: imgArr[count].1, insertdate: dateSubstring, status: 0, todo: todo)
                print("result \(result)")
            if result {
                showAlert("알림", "입력되었습니다.", "확인")
            } else {
                showAlert("알림", "입력에 문제가 생겼습니다.", "확인")
            }
        }
        
        navigationController?.popViewController(animated: true)
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MysqlAddViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imgArr.count
    }
}

extension MysqlAddViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let imageView = UIImageView(image: imageArray[row])
//        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//
//        return imageView
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return imgArr[row].2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imgView.image = imageArray[row]
        count = row
    }
}
