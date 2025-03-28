//
//  AddPropertyVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

//
//  AddPropertyVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit
import CoreData

class AddPropertyVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var loggedInUser: User?

    // UI Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtDetail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Add Image Button Action
    @IBAction func Tap_AddImage(_ sender: UIButton) {
        showImagePickerOptions()
    }
    

    private func showImagePickerOptions() {
        let alert = UIAlertController(title: "Add Property Image", message: "Choose an image source", preferredStyle: .actionSheet)
        
        // Photo Library Option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        })
        
      
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.openImagePicker(sourceType: .camera)
            })
        }
        
        // Cancel Option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

    // Open Image Picker
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }

    // Handle selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true)
    }

    // MARK: - Save Property
    @IBAction func savePropertyTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let priceText = priceTextField.text, let price = Int32(priceText),
              let detail = txtDetail.text, !detail.isEmpty,
              let user = loggedInUser else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        // Access Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        // Create new Property object
        let newProperty = Property(context: context)
        newProperty.title = title
        newProperty.location = location
        newProperty.price = price
        newProperty.propertyId = UUID()
        newProperty.detail = detail
        newProperty.user = user

 
        if let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.8) {
            newProperty.image = imageData
        }

        user.addToProperties(newProperty)

        // Save to Core Data
        do {
            try context.save()
            print(" Property saved successfully!")
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving property: \(error.localizedDescription)")
            showAlert(message: "Failed to save property. Please try again.")
        }
    }

    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
