//
//  PreviewViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/11/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    var previewButton:UIButton!
    var text:String!;
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.layer.cornerRadius = 10
        //self.view.backgroundColor = UIColor.blue
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                          NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 12.0),
                          NSAttributedStringKey.foregroundColor : UIColor.blue,
                          ]
        
        let myText = "HELLO this is my testing"
        let attrString = NSAttributedString(string: myText,
                                            attributes: attributes)
        
        let rt = CGRect(x: 50, y: 50, width: 100, height: 30)
        //attrString.draw(in: rt)
        self.view.draw(rt)
        //showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeTapped(_ sender: Any) {
        removeAnimate()
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.alpha = 0.95
        UIView.animate(withDuration: 0.45, animations: {
            self.view.alpha = 0.95
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        self.previewButton.layer.backgroundColor = UIColor.gray.cgColor
        UIView.animate(withDuration: 0.45, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.view.alpha = 0.95
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
        
    }
    
}
