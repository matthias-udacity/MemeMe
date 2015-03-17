//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Matthias on 16/03/15.
//

import UIKit

class EditMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!

    weak var currentTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // If no memes have been created yet, remove the cancel button.
        if (UIApplication.sharedApplication().delegate as AppDelegate).memes.isEmpty {
            topToolbar.items?.removeLast()
        }

        // Set default text field attributes.
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]

        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes

        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center

        // Disable camera if not available.
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            cameraButton.enabled = false
        }

        // Disable album if not available.
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            albumButton.enabled = false
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe to keyboard notifications.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        // Unsubscribe from keyboard notifications.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbars.
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image.
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide toolbars.
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }

    func saveMeme(image: UIImage) {
        // Create new meme.
        let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, image: image)

        // Add meme to shared model.
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
    }

    // MARK: IBAction

    @IBAction func actionButtonPressed(sender: UIBarButtonItem) {
        // Generate image.
        let memedImage = generateMemedImage()

        // Present activities.
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            // Save meme to shared model.
            self.saveMeme(memedImage)

            // Dismiss meme editor.
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, nil)
    }

    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        presentImagePickerController(.Camera)
    }

    @IBAction func albumButtonPressed(sender: UIBarButtonItem) {
        presentImagePickerController(.PhotoLibrary)
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Display selected image.
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }

        // Unhide text fields and enable action button.
        if imageView.image != nil {
            topTextField.hidden = false
            bottomTextField.hidden = false
            actionButton.enabled = true
        }

        // Dismiss image picker.
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UITextFieldDelegate

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text == ""
        }
        
        currentTextField = textField
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Notifications

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }

    func keyboardWillShow(notification: NSNotification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
}