//
//  EventCreationViewController.swift
//  EventPlanner
//
//  Created by  on 2023-04-02.
//

import UIKit

class EventCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let eventType = ["Birthday Party", "Graduation", "Baby & Kids", "Wedding", "Holiday", "Party", "Sports", "Organizations", "Celebrations", "Anniversary"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventType[row]
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
