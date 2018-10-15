//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var picture: UIImage!
    
    @IBAction func onChoose(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available")
            vc.sourceType = .camera
        } else {
            print("Camera is not available so we are using photo library instead")
            vc.sourceType = .photoLibrary
        }
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picture = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: {self.performSegue(withIdentifier: "tagSegue", sender: nil)})
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popViewController(animated: true)
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "cisco"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapview: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotation == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let address = "Mountain View, California"
//        getCoordinate(addressString: address) { success in
//            let addr = success.0
//            self.mapView.region = MKCoordinateRegionMakeWithDistance(addr, 2000, 2000)
//        }
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.7833, -122.4167), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tagSegue" {
            let locationsViewController = segue.destination as! LocationsViewController
            locationsViewController.delegate = self
        }
    }
}
