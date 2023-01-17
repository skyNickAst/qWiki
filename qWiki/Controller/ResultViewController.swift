//
//  ResultViewController.swift
//  qWiki
//
//  Created by Nikolai Astakhov on 16.01.2023.
//

import UIKit
import SDWebImage

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    
    var articleTitle: String = ""
    var articleText: String = ""
    var articleImageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = articleTitle
        resultText.text = articleText
        resultImage.sd_setImage(with: URL(string: articleImageURL))
    }

}
