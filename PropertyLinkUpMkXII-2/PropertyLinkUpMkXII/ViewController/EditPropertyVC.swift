
  //
  //  EditPropertyVC.swift
  //  PropertyLinkUpMkXII
  //
  //  Created by NAAMI COLLEGE on 26/03/2025.
  //

  import UIKit
  import CoreData

  protocol EditPropertyDelegate: AnyObject {
      func didUpdateProperty(updatedProperty: Property)
  }

  class EditPropertyVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

      // MARK: - Properties
      var property: Property?
      var loggedInUser: User?
      weak var delegate: EditPropertyDelegate? 


      @IBOutlet weak var lblEditTitle: UITextField!
      @IBOutlet weak var lblEditLocation: UITextField!
      @IBOutlet weak var lblEditDetail: UITextField!
      @IBOutlet weak var lblEditPrice: UITextField!
      @IBOutlet weak var lblEditImageView: UIImageView!

      override func viewDidLoad() {
          super.viewDidLoad()
          loadPropertyData()
      }

      // MARK: - Load Existing Property Data
      private func loadPropertyData() {
          guard let property = property else { return }
          
          lblEditTitle.text = property.title
          lblEditLocation.text = property.location
          lblEditDetail.text = property.detail
          lblEditPrice.text = "\(property.price)"
          
          if let imageData = property.image {
              lblEditImageView.image = UIImage(data: imageData)
          }
      }

      // MARK: - Image Picker
      @IBAction func Tap_EditAddImage(_ sender: UIButton) {
          showImagePickerOptions()
      }

      private func showImagePickerOptions() {
          let alert = UIAlertController(title: "Edit Property Image", message: "Choose an image source", preferredStyle: .actionSheet)

          alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
              self.openImagePicker(sourceType: .photoLibrary)
          })

          if UIImagePickerController.isSourceTypeAvailable(.camera) {
              alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
                  self.openImagePicker(sourceType: .camera)
              })
          }

          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          present(alert, animated: true)
      }

      private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = sourceType
          present(imagePicker, animated: true)
      }

      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let selectedImage = info[.originalImage] as? UIImage {
              lblEditImageView.image = selectedImage
          }
          dismiss(animated: true)
      }

      private func showAlert(message: String) {
          let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }

      // MARK: - Update Property Logic
      @IBAction func Tap_EditProperty(_ sender: UIButton) {
          guard let property = property,
                let title = lblEditTitle.text, !title.isEmpty,
                let location = lblEditLocation.text, !location.isEmpty,
                let priceText = lblEditPrice.text, let price = Int32(priceText),
                let detail = lblEditDetail.text, !detail.isEmpty,
                let user = loggedInUser, property.user == user else {
              showAlert(message: "Please fill all fields and ensure you're the property owner.")
              return
          }

          // Update property details
          property.title = title
          property.location = location
          property.price = price
          property.detail = detail

          if let image = lblEditImageView.image, let imageData = image.jpegData(compressionQuality: 0.8) {
              property.image = imageData
          }

          saveContext()
      }

      private func saveContext() {
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          let context = appDelegate.persistentContainer.viewContext

          do {
              try context.save()
              print("Property updated successfully!")
              if let updatedProperty = property {
                  delegate?.didUpdateProperty(updatedProperty: updatedProperty)  // Notify delegate
              }
              navigationController?.popViewController(animated: true)
          } catch {
              print("Error updating property: \(error.localizedDescription)")
              showAlert(message: "Failed to update property. Try again.")
          }
      }

      // MARK: - Delete Property Logic
      @IBAction func Tap_DeleteProperty(_ sender: UIButton) {
          guard let property = property,
                let user = loggedInUser, property.user == user else {
              showAlert(message: "You can only delete properties you own.")
              return
          }

      
          let alert = UIAlertController(title: "Delete Property",
                                        message: "Are you sure you want to delete this property?",
                                        preferredStyle: .alert)

          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
              self.deleteProperty(property)
          })

          present(alert, animated: true)
      }
      private func deleteProperty(_ property: Property) {
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          let context = appDelegate.persistentContainer.viewContext
          
          context.delete(property)

          do {
              try context.save()
              print("Property deleted successfully!")

        
              delegate?.didUpdateProperty(updatedProperty: property)

      
              navigationController?.popViewController(animated: true)

          } catch {
              print("Error deleting property: \(error.localizedDescription)")
              showAlert(message: "Failed to delete property. Try again.")
          }
      }

  

  }
