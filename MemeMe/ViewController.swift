//
//  ViewController.swift
//  MemeMe
//
//  Created by admin_hassan on 29/03/2019.
//  Copyright © 2019 hassanalhussaini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var UIImagePicker: UIImageView!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var PickButton: UIBarButtonItem!
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    
    var count = 0
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //label
        let label = UILabel()
        label.frame = CGRect(x: 150, y:150, width: 60, height: 60)
        label.text = "0"
        view.addSubview(label)
        self.label = label
        
        
        //button
        let button = UIButton()
        button.frame = CGRect(x:150, y:250, width:60, height: 60)
        button.setTitle("Click", for: .normal)
        view.addSubview(button)
        
        //button.addTarget(self, action: #selector(ViewController.incrementCount), for: UIControl.Event.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func picklAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_sender: any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
    return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(_ notification:Notification){
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIkeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.chRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

}

