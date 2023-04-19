//
//  EventDetailsViewController.swift
//  EventPlanner
//
//  Created by  on 2023-04-02.
//

import UIKit
import CoreImage

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var lblWhere: UILabel!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateQRCodeButtonTapped(_ sender: UIButton) {
        displayQRCode2()
    }
    
    // Generate QR code with event details
    func generateQRCode2(from string: String, size: CGFloat) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        let scaleX = size / qrImage.extent.size.width
        let scaleY = size / qrImage.extent.size.height
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return UIImage(ciImage: transformedImage)
    }

    func displayQRCode2() {
        let qrCodeString = "You are invited to \(lblEventTitle.text ?? "")\nDate and time: \(lblWhen.text ?? "")\nLocation: \(lblWhere.text ?? "")\nHosted By: \(lblHost.text ?? "")\nTheme: \(lblTheme.text ?? "")"
        guard let qrCodeImage = generateQRCode2(from: qrCodeString, size: 250.0) else { return }
        qrCodeImageView.image = qrCodeImage
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
