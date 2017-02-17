//
//  ViewController.swift
//  Cute Animals
//
//  Created by Jaxson Mann on 2/2/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var getImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func getNewImage(_ sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }

    // Configure UI
    private func setUIEnabled(_ enabled: Bool) {
        getImageButton.isEnabled = enabled
        
        if enabled {
            getImageButton.alpha = 1.0
        } else {
            getImageButton.alpha = 0.5
        }
    }
    
    // Helper for escaping parameters in URL
    private func escapedParams(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    // Make a Network Request
    private func getImageFromFlickr() {
        
        let methodParams = [
            Constants.FlickrParamKeys.Method: Constants.FlickrParamValues.PhotosMethod,
            Constants.FlickrParamKeys.APIKey: Constants.FlickrParamValues.APIKey,
            Constants.FlickrParamKeys.Text: Constants.FlickrParamValues.Text,
            Constants.FlickrParamKeys.SafeSearch: Constants.FlickrParamValues.SafeSearch,
            Constants.FlickrParamKeys.Extras: Constants.FlickrParamValues.MediumURL,
            Constants.FlickrParamKeys.Format: Constants.FlickrParamValues.ResponseFormat,
            Constants.FlickrParamKeys.NoJSONCallback: Constants.FlickrParamValues.DisableJSONCallback
        ]
        
        // create URL and Request
        let session = URLSession.shared
        let urlString = Constants.Flickr.APIBaseURL + escapedParams(methodParams as [String:AnyObject])
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                displayError("No data was retunred by the request!")
                return
            }
            
            // Parse data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // GUARD: Did Flickr return an error (stat != ok)?
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code an message in \(parsedResult)")
                return
            }
            
            // GUARD: Are the "photos" and "photo" keys in our results?
            guard let photosDict = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDict[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            //Select random photo
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDict = photoArray[randomPhotoIndex] as [String:AnyObject]
            
            // GUARD: Does our photo have a key for 'url_m'?
            guard let imageURLString = photoDict[Constants.FlickrResponseKeys.MediumURL] as? String else {
                displayError("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photoDict)")
                return
            }
            
            // if image exists at the url, set image
            let imageURL = URL(string: imageURLString)
            if let imageData = try? Data(contentsOf: imageURL!) {
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.photoImageView.image = UIImage(data: imageData)
                }
            } else {
                displayError("Image does not exist at \(imageURL)")
            }
        }
        
    // Start task!
    task.resume()
    }
}
