//
//  ViewController.swift
//  MemeMe
//
//  Created by admin_hassan on 29/03/2019.
//  Copyright © 2019 hassanalhussaini. All rights reserved.
//

import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    lazy var imagePicker: UIImagePickerController = {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var PickButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
        // Do any additional setup after loading the view.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMemedImage))
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = (self as! UITextFieldDelegate)
        textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-condesedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor .black,
            .strokeWidth: -8.0
        ]
    }
    
    func OpenImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func pickAnImage(_ sender: UIBarButtonItem){
        if sender.tag == 1{
        OpenImagePicker(sourceType: .camera)
        } else {
        OpenImagePicker(sourceType: .photoLibrary)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
    return true
    }
    
    func updateImageView(image: UIImage?){
        imageView.image = image
        navigationItem.leftBarButtonItem?.isEnabled = (image != nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if bottomTextField.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) ->CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        _ = (topTextField.text == "TOP") ? "" : topTextField.text ?? ""
        _ = (bottomTextField.text == "BUTTOM") ? "" : bottomTextField.text ?? ""
        guard imageView.image != nil else {return}
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func shareMemedImage(_ sender: Any){
        //sharefunction
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType, completed: Bool, returnItems:[Any]?, error:NSError?) in
            
            if(!completed){return}
            self.save()
        } as? UIActivityViewController.CompletionWithItemsHandler
    }
}
