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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTextField(textField: UITextField, placeholder: String) {
        let textAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -5.0]
        
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
        textField.clearsOnBeginEditing = true
        textField.autocapitalizationType = .allCharacters
    }
    
    func configureUI() {
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        // TODO: Figure out how to hide cancelButton
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(); switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)"); if newStatus == PHAuthorizationStatus.authorized {
                print("success") }
            })
            case .restricted: print("User do not have access to photo album.")
            case .denied: print("User has denied the permission.")
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
    
    //MARK: - Delegates
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
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

