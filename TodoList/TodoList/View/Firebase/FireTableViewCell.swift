//
//  FireTableViewCell.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

import UIKit

class FireTableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
