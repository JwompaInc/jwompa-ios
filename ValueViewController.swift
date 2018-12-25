//
//  ValueViewController.swift
//  JWOMPA
//
//  Created by Badhan Ganesh on 10/26/17.
//  Copyright © 2017 Relienttekk. All rights reserved.
//

import UIKit

class ValueViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let gradient = CAGradientLayer()
    var listValues: [Dictionary<String,String>] = []
    
    init() {
        super.init(nibName: "ValueViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonActionSetup()
        getContentWebService()
        configureCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  bannerView.removeFromSuperview()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    fileprivate func buttonActionSetup() {
        
        self.signInButton.showsTouchWhenHighlighted = true
        self.signUpButton.showsTouchWhenHighlighted = true
        
        self.signInButton.addTarget(self, action: #selector(signInButtonTouched(_:)), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTouched(_:)), for: .touchUpInside)
    }
    
    fileprivate func configurePageControl() {
        self.pageControl.currentPage = 0
        self.pageControl.addTarget(self, action: #selector(pageControlDotTouched(_:)), for: .valueChanged)
        self.pageControl.numberOfPages = self.listValues.count
    }
    
    @objc fileprivate func pageControlDotTouched(_ sender: UIPageControl) {
        self.collectionView.scrollToItem(at: IndexPath.init(row: sender.currentPage, section: 0), at: .left, animated: true)
    }
    
    fileprivate func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false

        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.minimumLineSpacing = 0
        
        self.collectionView.register(UINib.init(nibName: "ValueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ValueCollectionCell")
    }
    
    fileprivate func getContentWebService() {
        let functionName = Constants().kGetValueScreenDetailsURL
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: functionName, succes: { (dictionary, requestOperation) in
            
            let array = dictionary.object(forKey: "value_screen") as! [Dictionary<String, String>]
            for dic in array { self.listValues.append(dic) }
            
            DispatchQueue.main.async {
                self.configurePageControl()
                self.collectionView.reloadData()
            }
        }) { (error, operation) in
            print(error)
        }
    }
    
    func signInButtonTouched(_ sender: UIButton) {
        let loginVC = JWelcomeVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    func signUpButtonTouched(_ sender: UIButton) {
        let registerVC = JRegistrationVC.init(nibName: "JRegistrationVC", bundle: nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}


extension ValueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listValues.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = "ValueCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ValueCollectionViewCell
        cell.titleLabel.text = self.listValues[indexPath.row]["title"]
        cell.contentLabel.text = self.listValues[indexPath.row]["content"]

        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        self.pageControl.currentPage = visibleIndexPath.row
    }
}
