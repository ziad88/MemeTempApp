//
//  CellView.swift
//  MemeTemp
//
//  Created by Ziad Alfakharany on 12/03/2023.
//

import UIKit

class CellView: UIView {
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "imgNef")
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 15.0
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = "helllooooo"
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .heavy)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    
    private lazy var cellStackView: UIStackView = {
        let vw = UIStackView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.axis = .vertical
        vw.spacing = 5
        return vw
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(img: String, cellTitle: String) {
        title.text = cellTitle
        imageView.downloaded(from: img)
    }
    
}

private extension CellView {
    func setUp() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(cellStackView)
        
        cellStackView.addArrangedSubview(imageView)
        cellStackView.addArrangedSubview(title)
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            cellStackView.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: -8),
            cellStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            cellStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}

extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
