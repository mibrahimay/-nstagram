//
//  PostTableViewCellActions.swift
//  Filling
//
//  Created by mac on 24.02.2024.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didClickLikeButton()
    func didClickCommentButton()
    func didClickSendButton()
}

class PostTableViewCellActions: UITableViewCell {
    weak var delegate : PostTableViewCellDelegate?
    static let identifier = "PostTableViewCellActions"
    
    private let likeButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30,weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    private let commentButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30,weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration: config)
        button.setImage(image,for: .normal)
        button.tintColor = .label
        return button
    }()
    private let sendButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30,weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        button.setImage(image,for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(style : UITableViewCell.CellStyle , reuseIdentifier : String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        likeButton.addTarget(self, action : #selector(didClickLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action : #selector(didClickCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action : #selector(didClickSendButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didClickLikeButton(){
        delegate?.didClickLikeButton()
    }
    @objc private func didClickCommentButton(){
        delegate?.didClickLikeButton()
    }
    @objc private func didClickSendButton(){
        delegate?.didClickLikeButton()
    }

    
    public func configure (with post : Userpost) {
        //configure cell
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //like , comment , send
        let buttonSize = contentView.height-10
        let buttons = [likeButton,commentButton, sendButton]
        for i in 0..<buttons.count{
            let button = buttons[i]
            button.frame = CGRect(x: CGFloat(Int((CGFloat(i)*buttonSize))), y: 5, width: buttonSize, height: buttonSize)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
