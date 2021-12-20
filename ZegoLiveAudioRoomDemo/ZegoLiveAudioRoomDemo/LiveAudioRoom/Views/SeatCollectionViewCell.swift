//
//  SeatCollectionViewCell.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by zego on 2021/12/17.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var soundWaveImage: UIImageView!
    @IBOutlet weak var micImageView: UIImageView!
    @IBOutlet weak var hostLogo: UIImageView!
    
    @IBOutlet weak var soundImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var micImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if isCurrentChinese() {
            self.hostLogo.image = UIImage.init(named: "host_logo_china")
        } else {
            self.hostLogo.image = UIImage.init(named: "host_logo")
        }
    }
    
    public func setSpeakerSeat(seatModel: SpeakerSeatModel, role: UserRole) -> Void {
        nameLabel.text = ""
        hostLogo.isHidden = true
        micImageView.isHidden = true
        soundWaveImage.isHidden = seatModel.soundLevel <= 5
        
        switch seatModel.status {
        case .untaken :
            nameLabel.isHidden = true
            if role == .listener {
                headImageView.image = UIImage.init(named: "seat_up_icon")
            } else if role == .host || role == .speaker {
                headImageView.image = UIImage.init(named: "icon_seat")
                micImageView.isHidden = true
            }
            break
        case .occupied :
            nameLabel.isHidden = false
            micImageView.isHidden = !seatModel.mic
            let imageName:String = ""
            headImageView.image = UIImage.init(named: imageName)
            if seatModel.userID == RoomManager.shared.roomService.info.hostID {
                hostLogo.isHidden = false
            }
            break
        case .closed :
            nameLabel.isHidden = true
            micImageView.isHidden = true
            headImageView.image = UIImage.init(named: "seat_lock_icon")
            break
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func isCurrentChinese() -> Bool {
        let languages:Array = NSLocale.preferredLanguages
        let currentLanguage:String = languages.first ?? ""
        if currentLanguage == "" {
            return true
        }
        return false
    }
    
    func updateUI() -> Void {
        let width:CGFloat = self.contentView.bounds.size.width
        var height:CGFloat = 54.0
        if width - 22 > 54 {
            height = 54
        } else {
            height = width - 22
        }
        headImageHeightConstraint.constant = height
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = height * 0.5
        micImageHeightConstraint.constant = height
        soundImageHeightConstraint.constant = height + 22.0
    }

}
