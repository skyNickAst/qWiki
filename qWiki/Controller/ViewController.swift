//
//  ViewController.swift
//  qWiki
//
//  Created by Nikolai Astakhov on 16.01.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    
    var pageid = ""
    var objectTitle = ""
    var objectDescription = ""
    var objectImageURL = ""
    
    let res = ResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
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
        requestInfo(searchFieldValue: searchField.text!)
        searchField.text = ""
    }
    
    func requestInfo(searchFieldValue: String) {
        let parameters: [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : searchFieldValue, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        AF.request(wikipediaURL, method: .get, parameters: parameters).responseData { [self] response in
            if let error = response.error{
                print(error.localizedDescription)
            } else {
                if let data = response.data {
                    let dataJSON : JSON = JSON(data)
                    
                    pageid = dataJSON["query"]["pageids"][0].stringValue
                    objectTitle = dataJSON["query"]["pages"][pageid]["title"].stringValue
                    objectDescription = dataJSON["query"]["pages"][pageid]["extract"].stringValue
                    objectImageURL = dataJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                    performSegue(withIdentifier: "toResult", sender: self)
                }
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultViewController
        
        destinationVC.articleTitle = objectTitle
        destinationVC.articleText = objectDescription
        destinationVC.articleImageURL = objectImageURL
    }
}
