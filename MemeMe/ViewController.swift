//
//  ViewController.swift
//  MemeMe
//
//  Created by mac on 8/22/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var memedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        configureTextField(textField: topTextField, placeholder: "TOP")
        configureTextField(textField: bottomTextField, placeholder: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureTextField(textField: UITextField, placeholder: String) {
        
        let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        let strokeWidth = -5.0
        
        let textAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: font!,
            NSAttributedStringKey.strokeWidth.rawValue: strokeWidth
        ]
        
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
        textField.clearsOnBeginEditing = true
        textField.autocapitalizationType = .allCharacters
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.strokeColor: UIColor.white,
                NSAttributedStringKey.strokeWidth: strokeWidth,
                NSAttributedStringKey.font: font!
            ]
        )
    }
    
    func generateMemedImage() -> UIImage {
        
        prepareUI(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        prepareUI(hide: false)
        
        return memedImage
    }
    
    func prepareUI(hide: Bool) {
        
        // Hide toolbars and placeholder text
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    
        prepareTextField(hide: hide, field: topTextField)
        prepareTextField(hide: hide, field: bottomTextField)
    }
    
    func prepareTextField(hide: Bool, field: UITextField) {
        if (field.text == nil || field.text == "") {
            print("Hide top text field \(hide)")
            field.isHidden = hide
        }
    }
    
    func openGallery(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.barButtonItem = sender
    }

    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(); switch photoAuthorizationStatus {
        case .authorized: self.openGallery(sender: sender)
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                self.openGallery(sender: sender)
            }
        })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.")
        }
    }
    
    @IBAction func takeAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: self.memedImage!)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        memedImage = generateMemedImage()
        
        let vc = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: [])
        vc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            self.save()
            self.dismiss(animated: true, completion: nil)

            // Use belowe code for later if memes has t be stored on the phone
            /*
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(); switch photoAuthorizationStatus {
            case .authorized:
                // TODO: save meme to storage here
            case .notDetermined: PHPhotoLibrary.requestAuthorization({
                (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    // TODO: save meme to storage here
                }
            })
            case .restricted: print("User do not have access to photo album.")
            case .denied: print("User has denied the permission.")
            }
            */
            
        }
        present(vc, animated: true)
    }
    
    //MARK: - Delegates
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
            shareButton.isEnabled = true
        } else {
            print("Error selecting image.")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Close keyboard on return or clicking anywhere on the screen outside the text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

