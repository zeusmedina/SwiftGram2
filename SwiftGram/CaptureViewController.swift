//
//  CaptureViewController.swift
//  SwiftGram
//
//  Created by zeus medina on 3/4/16.
//  Copyright © 2016 Zeus. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var uploadedImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    let userData = UserData()
    
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //Uploaded image and caption field will be hidden until image is selected for upload
        uploadedImageView.hidden = true
        captionTextField.hidden = true
        
        
        //Due to running in the simulator, the camera function is not available
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false) {
            takePhotoButton.enabled = false
        }
        //Ensures photo library is accessible, will remove upload functionality otherwise
        if(UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) == false) {
            uploadPhotoButton.enabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showImagePickerController() {
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onUploadButton(sender: AnyObject) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        showImagePickerController()
        
    }
    

    @IBAction func onTakePhotoButton(sender: AnyObject) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        showImagePickerController()

    }
    
    
    @IBAction func onSubmitButton(sender: AnyObject) {
        SVProgressHUD.show()
        
        if(captionTextField.text != nil && uploadedImageView.image != nil) {
            userData.postNewImage(uploadedImageView.image!, withCaption: captionTextField.text, withCompletion: { (success: Bool, error: NSError?) -> Void in
                if let error = error {
                    NSLog("Unable to upload image, error.")
                    SVProgressHUD.dismiss()
                    
                    //TODO: add an alert to users
                } else {
                    NSLog("Image was uploaded!")
                    SVProgressHUD.dismiss()
                }
            })
        } else {
            //No Image or Caption were entered
            SVProgressHUD.dismiss()
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            // Make buttons active
            uploadedImageView.hidden = false
            captionTextField.hidden = false
            submitButton.hidden = false
            
            
            let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Set preview of image
            uploadedImageView.image = chosenImage
        
            dismissViewControllerAnimated(true, completion: nil)
            
    }

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
