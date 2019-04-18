//
//  ViewController.swift
//  ManPro.net
//
//  Created by Lorenzo Malferrari on 15/04/2019.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        risolutoreIndirizzo() { address in
            print("Address preReplace -> " + address)
            
            self.urlStr = address.replacingOccurrences (of: "\\/", with: "/")
            print("Address postReplace -> " + self.urlStr)
            
            let url = URL(string: a)! //Here is the error -> Fatal error: Unexpectedly found nil while unwrapping an Optional value
            self.webView.load(URLRequest(url: url))
            // 2
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self.webView, action: #selector(self.webView.reload))
            self.toolbarItems = [refresh]
            self.navigationController?.isToolbarHidden = true
        }
        
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { title = webView.title }
    
    func risolutoreIndirizzo(completion: @escaping (_ result: String) -> Void) {
        var indirizzoPortaleString:String = ""
        
        let indirizzoPortale:String = "https://mywebsite.com/"
        let percorsoPortale:String = "privateProject/file.php"
        print("URL -> \(indirizzoPortale+percorsoPortale)")
        let request = NSMutableURLRequest(url: NSURL(string: indirizzoPortale+percorsoPortale)! as URL)
        request.httpMethod = "POST"
        let nameDB = "nagest"
        let postString = "StringaAccesso=\(nameDB)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            //print("response = \(response)")
            let responseString:String! = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            print("responseString = \(String(describing: responseString))")
            
            print("---------------------------------")
            
            //Ora bisogna spezzare responseString per ottenere i campi indirizzoPortale e indirizzoPortaleEncoding
            let arrayResponse = responseString.split(separator: ",")
            
            //print(arrayResponse[0])
            
            indirizzoPortaleString = arrayResponse[0].split(separator: ":")[1] + ":" + arrayResponse[0].split(separator: ":")[2]
            print("Indirizzo al quale accedere -> " + indirizzoPortaleString)
            
            completion(indirizzoPortaleString)
        }
        task.resume()
    }
}
