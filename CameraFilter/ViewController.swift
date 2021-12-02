//
//  ViewController.swift
//  CameraFilter
//
//  Created by pineone on 2021/12/02.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilmButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photoCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                  fatalError("Segue destination is not found")
              }
        
        photoCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func filterButton(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilmButton.isHidden = false
    }
    
}

