//
//  ViewController.swift
//  qWiki
//
//  Created by Nikolai Astakhov on 16.01.2023.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, WikiBrainDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    
    var wikiBrain = WikiBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        wikiBrain.delegate = self
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text == "" {
            searchField.placeholder = "Type something..."
            return false
        } else {
            searchField.placeholder = "Search"
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        wikiBrain.requestInfo(searchFieldValue: searchField.text!)
        searchField.text = ""
    }
    
    var objectTitle = ""
    var objectDescription = ""
    var objectImageURL = ""
    
    func didUpdateData(dataModel: ArticleModel) {
        DispatchQueue.main.async {
            self.objectTitle = dataModel.articleTitle
            self.objectDescription = dataModel.articleText
            self.objectImageURL = dataModel.articleImageURL
            self.performSegue(withIdentifier: "toResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultViewController
        destinationVC.articleTitle = objectTitle
        destinationVC.articleText = objectDescription
        destinationVC.articleImageURL = objectImageURL
    }
}
