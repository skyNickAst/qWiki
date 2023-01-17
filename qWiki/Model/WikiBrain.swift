//
//  WikiBrain.swift
//  qWiki
//
//  Created by Nikolai Astakhov on 17.01.2023.
//

import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

protocol WikiBrainDelegate {
    func didUpdateData(dataModel: ArticleModel)
}

struct WikiBrain {
    var delegate: WikiBrainDelegate?
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    
    func requestInfo(searchFieldValue: String) {
        let parameters: [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : searchFieldValue, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        AF.request(wikipediaURL, method: .get, parameters: parameters).responseData { response in
            if let error = response.error{
                print(error.localizedDescription)
            } else {
                if let data = response.data {
                    let result = parseJSON(with: data)
                    delegate?.didUpdateData(dataModel: result)
                }
            }
        }
    }
    
    func parseJSON(with data: Data) -> ArticleModel {
        
        let dataJSON = JSON(data)
        let pageid = dataJSON["query"]["pageids"][0].stringValue
        let objectTitle = dataJSON["query"]["pages"][pageid]["title"].stringValue
        let objectDescription = dataJSON["query"]["pages"][pageid]["extract"].stringValue
        let objectImageURL = dataJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
        
        let result = ArticleModel(articleTitle: objectTitle, articleText: objectDescription, articleImageURL: objectImageURL)
        return result
    }
}
