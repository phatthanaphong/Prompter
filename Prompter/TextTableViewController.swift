//
//  TextTableViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/11/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit

class TextTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    
    var userID:Int?
    var fileNameList = [String]()
    var textArea:UITextView?
    var textData:NSDictionary?
    var titleText = [String]()
    var detailText = [String]()
    var mainObject: MainViewController?
   
    
    @IBOutlet weak var unrecorded: UIButton!
    @IBOutlet weak var recorded: UIButton!
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    let buttonColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.unrecorded.backgroundColor = self.buttonColor
        self.unrecorded.layer.cornerRadius = 10
        self.recorded.layer.cornerRadius = 10
        self.all.layer.cornerRadius = 10
        self.addButton.layer.cornerRadius = 5
        self.deleteButton.layer.cornerRadius = 5
    
        
        retrieveDataFromSever()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveDataFromSever(){
        let url = NSURL(string:"http://202.28.34.202/textpreppilot/iosgetText.php")
        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "POST"
        let postString = "userid=\(self.userID!)"
        //print("this is the posting string : \(postString)")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            guard error == nil && data != nil else{
                self.displayMessgage(tileMsg: "Conection Failed", msg: "Cannot connect to the server, please check your connection")
                return
            }
            
            let httpStatus = response as! HTTPURLResponse
            if httpStatus.statusCode == 200 {
                if data!.count != 0{
                    do{
                        let responseString = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        let errorFlag = responseString["error"] as! Bool
                        
                        if errorFlag == false{
                            DispatchQueue.main.async(execute: {
                                self.textData = responseString
                                for (key, value) in self.textData!{
                                    if key as! String == "error"{
                                        continue
                                    }
                                    
                                    let d = value as! NSDictionary
                                    let status = d["t_status"] as! Int
                                    if(status == 0){
                                        self.titleText.append(d["t_topic"]! as! String)
                                        self.detailText.append(d["t_detail"]! as! String)
                                        self.fileNameList.append(d["t_text"]! as! String)
                                        self.tableView.reloadData()
                                        //print(self.fileNameList)
                                    }
                                }
                                
                            })
                            
                        }
                        else{
                            print(responseString["message"] as! String)
                        }
                        
                    }
                    catch _ as NSError{
                        print("Error cannnot get response from the server")
                        //flag = false
                    }
                }
                else{
                    print("No data retrived from the sever")
                    //flag = false
                }
            }
            else{
                print("Error http status code is ",httpStatus.statusCode )
                //flag = false
            }
        }
        task.resume()
    }
    
    func  displayMessgage(tileMsg:String, msg:String){
        let alert = UIAlertController(title: tileMsg, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTextData"{
            let recieverVC = segue.destination as! TextTableViewController
            recieverVC.userID = self.userID
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.titleText.isEmpty){
            return 0
        }
        return self.titleText.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = self.titleText[indexPath.row]
        cell.detailTextLabel?.text = self.detailText[indexPath.row]
        return cell
    }

    @IBAction func unrecordedTapped(_ sender: Any) {
        self.unrecorded.backgroundColor = self.buttonColor
        self.recorded.backgroundColor = UIColor.darkGray
        self.all.backgroundColor = UIColor.darkGray
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                
                let d = value as! NSDictionary
                let status = d["t_status"] as! Int
                if(status == 0){
                    self.titleText.append(d["t_topic"]! as! String)
                    self.detailText.append(d["t_detail"]! as! String)
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    @IBAction func recordedTapped(_ sender: Any) {
        self.unrecorded.backgroundColor = UIColor.darkGray
        self.recorded.backgroundColor = self.buttonColor
        self.all.backgroundColor = UIColor.darkGray
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                
                let d = value as! NSDictionary
                let status = d["t_status"] as! Int
                if(status == 1){
                    self.titleText.append(d["t_topic"]! as! String)
                    self.detailText.append(d["t_detail"]! as! String)
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    @IBAction func allTapped(_ sender: Any) {
        self.unrecorded.backgroundColor = UIColor.darkGray
        self.recorded.backgroundColor = UIColor.darkGray
        self.all.backgroundColor = self.buttonColor
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                
                let d = value as! NSDictionary
                self.titleText.append(d["t_topic"]! as! String)
                self.detailText.append(d["t_detail"]! as! String)
                self.tableView.reloadData()
                
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        //MainViewController. = fileNameList[row]
        getTextFromServer(filename: fileNameList[row])
        
    }
    
    func getTextFromServer(filename:String){
        self.mainObject?.fileName = filename
        var fn = filename.replacingOccurrences(of: ".docx", with: ".txt")
        //self.displayMessgage(tileMsg: "Login Failed", msg: "\(fn)")
        if let url = URL(string: "http://202.28.34.202/textpreppilot/web/uploads/\(fn)") {
            do {
                let contents = try String(contentsOf: url)
                textArea?.text = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
    }
    
    
}
