//
//  todo_list_item.swift
//  CheckMark
//
//  Created by Mihil Jose on 17/02/23.
//

import UIKit

class todo_list_item: UITableViewCell {

    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var hourTodo: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var todoTitle: UILabel!
    
    var isChecked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("custom cell")
    }

    @IBAction func checkbobButtonAction(_ sender: Any) {
        if isChecked == false{
            checkboxButton.setImage(UIImage(named: "check"), for: .normal)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoTitle.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            todoTitle.attributedText = attributeString
            
            isChecked = true
        }
        else{
            checkboxButton.setImage(UIImage(named: "uncheck"), for: .normal)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoTitle.text ?? "")
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            todoTitle.attributedText = attributeString
            isChecked = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
