//
//  LiveAudioGiftView.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by zego on 2021/12/17.
//

import UIKit

protocol LiveAudioGiftViewDelegate:AnyObject {
    func sendGift(giftModel:GiftModel);
}

class LiveAudioGiftView: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatUserList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1.0)
            var lineView:UIView = UIView.init(frame: CGRect.init(x: 16, y: 41.5, width: messageTableView?.bounds.size.width ?? 0 - 32, height: 0.5))
            lineView.backgroundColor = UIColor.init(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
            cell?.contentView.addSubview(lineView)
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    weak var delegate: LiveAudioGiftViewDelegate?
    
    var titleLabel:UILabel?
    var sendButton:UIButton?
    var giftCollectionView:UICollectionView?
    
    var giftArray:Array<GiftModel>?
    var seatUserList:Array<SpeakerSeatModel>?
    var targetUserList:Array<Any>?
    var sendGift:GiftModel?
    var messageLabel:UILabel?
    var arrowButton:UIButton?
    var messageTableView:UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sendGift = giftArray?.first
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI() -> Void {
        self.backgroundColor = UIColor.clear
        
        let whiteView:UIView = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 400, width: self.bounds.size.width, height: 400))
        whiteView.backgroundColor = UIColor.white
        
        let maskPath:UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: whiteView.bounds.size.width, height: whiteView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 12, height: 12))
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = whiteView.bounds
        maskLayer.path = maskPath.cgPath
        whiteView.layer.mask = maskLayer
        
        let width = self.frame.size.width
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: whiteView.bounds.size.width, height: whiteView.bounds.size.height))
        titleLabel?.text = ZGLocalizedString("room_page_gift")
        titleLabel?.textColor = UIColor.init(red: 27/255.0, green: 27/255.0, blue: 27/255.0, alpha: 1.0)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel?.textAlignment = .center
        whiteView.addSubview(titleLabel!)
        
        let messageView:UIView = UIView.init(frame: CGRect.init(x: 18, y: 349, width: whiteView.bounds.size.width - 18 - 11 - 112, height: 40))
        messageView.layer.masksToBounds = true
        messageView.layer.cornerRadius = 12.0
        messageView.backgroundColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1.0)
        whiteView.addSubview(messageView)
        
        arrowButton = UIButton.init(type: .custom)
        arrowButton?.frame = CGRect.init(x: messageView.bounds.size.width - 12 - 16, y: 12, width: 16, height: 16)
        arrowButton?.setImage(UIImage.init(named: "pull_arrow"), for: .normal)
        arrowButton?.addTarget(self, action: #selector(arrowClick), for: .touchUpInside)
        messageView.addSubview(arrowButton!)
        
        messageLabel = UILabel.init(frame: CGRect.init(x: 15, y: 11, width: messageView.bounds.size.width - 15 - 12 - 16 - 30, height: 15))
        messageLabel?.isUserInteractionEnabled = true ?? false
        messageLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        messageView.addSubview(messageLabel!)
        
        let messageLabelTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(messageLabelTapClick))
        messageLabel?.addGestureRecognizer(messageLabelTap)
        setMessageLabelNomalTitle()
        
        messageTableView = UITableView.init(frame: CGRect.init(x: 18, y: giftCollectionView?.frame.maxY ?? 0 + 9, width: width - 18 - 123, height: 400 - (giftCollectionView?.frame.maxY ?? 0) - 9 - 61), style: .plain)
        messageTableView?.delegate = self as UITableViewDelegate
        messageTableView?.dataSource = self as UITableViewDataSource
        messageTableView?.isHidden = true
        messageTableView?.separatorStyle = .none
        messageTableView?.layer.masksToBounds = true
        messageTableView?.layer.cornerRadius = 12.0
        messageTableView?.backgroundColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1.0)
        
        let maskView:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - 390))
        maskView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        
        let tapClick:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        maskView.addGestureRecognizer(tapClick)
        
        self.addSubview(maskView)
        self.addSubview(whiteView)
    }
    
    @objc func tapClick() -> Void {
        
    }
    
    @objc func arrowClick(_ sender: UIButton) -> Void {
        
    }
    
    @objc func messageLabelTapClick() -> Void {
        
    }
    
    func setMessageLabelNomalTitle() -> Void {
        if RoomManager.shared.userService.localInfo?.role == .host && seatUserList?.count == 1 {
            messageLabel?.text = ZGLocalizedString("room_page_select_default")
        } else {
            messageLabel?.text = ZGLocalizedString("room_page_gift_no_speaker")
        }
    }
    
}
