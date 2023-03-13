//
//  ViewController.swift
//  MemeTemp
//
//  Created by Ziad Alfakharany on 12/03/2023.
//

import UIKit
import SafariServices

class MemeViewController: UIViewController {
    
    private let viewModel = MemeViewModel()
    
    private lazy var shuffleBtn: UIBarButtonItem = {
        let action = UIAction { _ in
            self.presentSafari(url: self.viewModel.memes.randomElement()!.url)
        }
        let btn = UIBarButtonItem(primaryAction: action)
        btn.title = "shuffle"
        btn.tintColor = .red
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Most popular memes ever"
        lbl.font = .systemFont(ofSize: 24, weight: .heavy)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var cv: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 353, height: 310)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(customCollectionViewCell.self, forCellWithReuseIdentifier: customCollectionViewCell.identifier)
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.backgroundColor = .black
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    private lazy var secondTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Trendy this week"
        lbl.font = .systemFont(ofSize: 24, weight: .heavy)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var secondCV: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 353, height: 310)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(customCollectionViewCell.self, forCellWithReuseIdentifier: customCollectionViewCell.identifier)
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.backgroundColor = .black
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    
    private lazy var memeStackView: UIStackView = {
        let vw = UIStackView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.axis = .vertical
        vw.spacing = 5
        return vw
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.getMemes()
        viewModel.delegate = self
    }
    
    
    func presentSafari(url: String) {
        
        let url = URL(string: url)!
        
        let vc = SFSafariViewController(url: url)
        
        vc.modalPresentationStyle = .formSheet
        
        self.present(vc, animated: true)
    }
    
}

extension MemeViewController: MemeViewModelDelegate {
    func didFetch() {
        cv.reloadData()
        secondCV.reloadData()
    }
    
    func didFail(error: Error) {
        print(error)
    }
    
    
}

extension MemeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: customCollectionViewCell.identifier, for: indexPath) as! customCollectionViewCell
        
        cell.item = viewModel.memes[indexPath.item]
        
        
        
        let secondCell = secondCV.dequeueReusableCell(withReuseIdentifier: customCollectionViewCell.identifier, for: indexPath) as! customCollectionViewCell
        
        if indexPath.item <= 89 {
            secondCell.item = viewModel.memes[indexPath.item+10]
        }
        
        
        
        if collectionView == cv {
            return cell
        } else {
            return secondCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cv {
            presentSafari(url: viewModel.memes[indexPath.item].url)
        } else {
            presentSafari(url: viewModel.memes[indexPath.item+10].url)
        }
        
    }
}


private extension MemeViewController {
    func setUp() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "MemeTempApp"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        
        navigationItem.rightBarButtonItem = shuffleBtn
        
        self.view.backgroundColor = .black
        self.view.addSubview(memeStackView)
        
        memeStackView.addArrangedSubview(titleLabel)
        memeStackView.addArrangedSubview(cv)
        memeStackView.addArrangedSubview(secondTitleLabel)
        memeStackView.addArrangedSubview(secondCV)
        
        
        NSLayoutConstraint.activate([
            memeStackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            memeStackView.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor),
            memeStackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            memeStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            cv.heightAnchor.constraint(equalToConstant: 310),
            secondCV.heightAnchor.constraint(equalToConstant: 310)
        ])
        
    }
}
