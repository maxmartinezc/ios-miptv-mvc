//
//  ChannelCellView.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 06-10-22.
//

import UIKit
import Kingfisher

class ChannelCellView: UITableViewCell {
    
    let channelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: K.Player.cellChannelNameLabelSize, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let channelImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    
    let favoriteChannelImageView : UIImageView = {
        let image = UIImage(systemName: "star")
        let uiImageView = UIImageView(image: image!)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.tintColor = K.Colors.favoriteChannelIcon
        return uiImageView
    }()
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = K.Colors.defaultChannelBoxBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = K.Colors.defaultChannelBoxBackground
        cellView.addSubview(channelName)
        cellView.addSubview(channelImageView)
        cellView.addSubview(favoriteChannelImageView)
        contentView.addSubview(cellView)
        setNoSelectedCell()
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            channelName.textColor = K.Colors.selectedChannel
            channelImageView.backgroundColor = K.Colors.selectedChannel
            cellView.backgroundColor = K.Colors.selectedChannelBoxBackground
        } else {
            setNoSelectedCell()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.channelName.text = nil
        self.channelImageView.kf.cancelDownloadTask()
        self.channelImageView.image = nil
    }
    
    func configure(model: ChannelItem) {
        self.selectionStyle = .none
        
        self.channelName.text = model.name
        let url = URL(string: model.logo)
        self.channelImageView.kf.setImage(with: url)
        self.favoriteChannelImageView.image = UIImage(systemName: model.isFavorite ? "star.fill" : "star" )
    }
    
    private func setupview() {
        NSLayoutConstraint.activate([
            
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: K.Player.cellChannelBottomAnchor),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.Player.cellChannelTopAnchor),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cellView.heightAnchor.constraint(equalTo: channelImageView.heightAnchor, constant: K.Player.cellChannelHeightAnchor),
            
            channelImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: K.Player.cellChannelImageLeadingAnchor),
            channelImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            channelImageView.widthAnchor.constraint(equalToConstant: K.Player.cellChannelImageWidthAnchor),
            channelImageView.heightAnchor.constraint(equalToConstant: K.Player.cellChannelImageHeightAnchor),
            
            channelName.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            channelName.topAnchor.constraint(equalTo: cellView.topAnchor),
            channelName.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: K.Player.cellChannelNameWidthAnchor),
            channelName.leadingAnchor.constraint(equalTo: channelImageView.trailingAnchor, constant: K.Player.cellChannelNameLeadingAnchor),
            
            favoriteChannelImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            favoriteChannelImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: K.Player.cellChannelFavoriteImageTrailingAnchor)
            
        ])
    }
    
    private func setNoSelectedCell() {
        channelName.textColor = K.Colors.defaultChannelNameTextColor
        channelImageView.backgroundColor = K.Colors.defualtChannelImageBackgroundColor
        cellView.backgroundColor = K.Colors.defaultChannelBoxBackground
    }
}
