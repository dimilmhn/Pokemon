//
//  PokemonListTableViewCell.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(background)
        self.addSubview(nameLabel)
        self.addSubview(urlLabel)
        self.setBackgroundConstraints()
        self.setNameLabelConstraints()
        self.setURLLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel : PokemonListCellViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
            urlLabel.text = viewModel?.url
        }
    }
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        return label
    }()
    
    private var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5.0
        return view
    }()

    private func setNameLabelConstraints() {
         let nameLabelConstraints = [
             nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
             nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
             nameLabel.heightAnchor.constraint(equalToConstant: 30)
            
         ]
         NSLayoutConstraint.activate(nameLabelConstraints)
     }
     
    private func setURLLabelConstraints() {
         let urlLabelConstraints = [
            urlLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            urlLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            urlLabel.heightAnchor.constraint(equalToConstant: 30)
         ]
         NSLayoutConstraint.activate(urlLabelConstraints)
     }
    
    private func setBackgroundConstraints() {
         let urlLabelConstraints = [
            background.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 5),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5),
            background.heightAnchor.constraint(equalToConstant: 80)
         ]
         NSLayoutConstraint.activate(urlLabelConstraints)
     }
}
