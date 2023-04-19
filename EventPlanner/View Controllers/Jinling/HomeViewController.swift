//
//  HomeViewController.swift
//  EventPlanner
//
//  Created by  on 2023-04-02.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageIndex = 0
    var timer: Timer?
        
    let images = [
        UIImage(named: "party_image.jpg"),
        UIImage(named: "wine.jpg"),
        UIImage(named: "sparkle.jpg"),
        UIImage(named: "coco.jpg"),
        UIImage(named: "flamingo.jpg")
          
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startTimer()

    }
    @IBAction func unwindToHomeViewController(sender: UIStoryboardSegue){
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(switchImage), userInfo: nil, repeats: true)
    }
    
    @objc func switchImage() {
        // Increment the image index
        imageIndex += 1
        
        // Check if we've reached the end of the images array
        if imageIndex >= images.count {
            imageIndex = 0
        }
        
        // Fade out the current image
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        }, completion: { _ in
            // Set the image of the image view to the next image
            self.imageView.image = self.images[self.imageIndex]
            
            // Fade in the new image
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.alpha = 1
            })
        })
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start the timer again if it was previously running
        if let timer = timer, !timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(switchImage), userInfo: nil, repeats: true)
        }
    }


        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        // Stop the timer when the view is about to disappear
        timer?.invalidate()
        // reset timer
        timer = nil
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
