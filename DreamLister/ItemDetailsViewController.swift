//
//  ItemDetailsViewController.swift
//  DreamLister
//
//  Created by Carlos Uy on 8/11/17.
//  Copyright © 2017 Orangebox Technology LLC. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Mark: - IBOutlets
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    // Mark: - Variables
    
    var stores = [Store]()
    var itemEdit: Item?
    var imagePicker: UIImagePickerController!
    
    // Mark: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        generateData()
        
        getStores()
        
        if itemEdit != nil {
            loadItemData()
        }
    }
    
    // MARK: - Funcs
    
    func generateData() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            
            if self.stores.count == 0 {
                let store = Store(context: context)
                store.name = "Best Buy"
                let store2 = Store(context: context)
                store2.name = "Tesla Dealership"
                let store3 = Store(context: context)
                store3.name = "Fry's Electronics"
                let store4 = Store(context: context)
                store4.name = "Target"
                let store5 = Store(context: context)
                store5.name = "Amazon"
                let store6 = Store(context: context)
                store6.name = "K Mart"
                
                ad.saveContext()
            }
        } catch {
            // handle error
        }
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    func loadItemData() {
        if let item = itemEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    
    // Mark: - IBActions
    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        
        if itemEdit == nil {
            item = Item(context: context)
        } else {
            item = itemEdit
        }

        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if itemEdit != nil {
            context.delete(itemEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Mark: - UIPickerView Protocols
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    // Mark: - UIImagePicker Protocols
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
