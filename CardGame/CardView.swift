//
//  CardView.swift
//  CardGame
//
//  Created by kerollos nabil on 3/25/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable
    var rank:Int = 1 { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    var sute:String = "♥️" { didSet {setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    var isFaceUp:Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()} }
    var pipsRtio:CGFloat = sizeRatio.faceCardImageToboundSize {didSet{
            setNeedsDisplay()
        }
        
    }
    
    private func getAtributedString(string:String, fontSize:CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return  NSAttributedString(string: string, attributes: [.font:font, .paragraphStyle:paragraphStyle])
    }
    private  var cornerString:NSAttributedString{
        return getAtributedString(string: rankString+"\n"+sute, fontSize: cornerFontSize)
    }
    private lazy var upperLeftlable = createCornerLabel()
    private lazy var lawerRightlable = createCornerLabel()
    func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0;
        addSubview(label)
        return label
    }
    private func confegurCornerLabel(label:UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay();setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        confegurCornerLabel(label: upperLeftlable)
        upperLeftlable.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        confegurCornerLabel(label: lawerRightlable)
        lawerRightlable.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lawerRightlable.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
        .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
        .offsetBy(dx: -lawerRightlable.frame.width, dy: -lawerRightlable.frame.height)
        
    }
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        let maxVerticalPipCount = CGFloat(pipsPerRowForRank[rank].count)
        let maxHorizontalPipCount = CGFloat(pipsPerRowForRank[rank].max() ?? 0)
        var pipsBound = bounds.zoom(py: pipsRtio)
        let pipsOrder = pipsPerRowForRank[rank]
        var attriputedStr = getAtributedString(string: sute, fontSize: pipsBound.size.height/maxVerticalPipCount)
        var fontSize = pipsBound.size.height/maxVerticalPipCount
        if attriputedStr.size().height > pipsBound.height/maxVerticalPipCount {
            let ratio = (pipsBound.height/maxVerticalPipCount) / attriputedStr.size().height
            fontSize *= ratio
            attriputedStr = getAtributedString(string: sute, fontSize: fontSize)
        }
        if attriputedStr.size().width > pipsBound.width/maxHorizontalPipCount {
            let ratio = (pipsBound.width/maxHorizontalPipCount) / attriputedStr.size().width
            fontSize *= ratio
            attriputedStr = getAtributedString(string: sute, fontSize: fontSize)
        }
        let emptySection = (pipsBound.height - attriputedStr.size().height*maxVerticalPipCount) / (maxVerticalPipCount+1)
        pipsBound.size.height = attriputedStr.size().height
        for pipCount in pipsOrder {
            pipsBound.origin.y += emptySection
            switch pipCount {
            case 1:
                attriputedStr.draw(in: pipsBound)
            case 2:
                attriputedStr.draw(in: pipsBound.leftHafe)
                attriputedStr.draw(in: pipsBound.rightHafe)
            default:
                break
            }
            pipsBound.origin.y += pipsBound.size.height
        }
    }
    @objc func changeRatio(sender: UIPinchGestureRecognizer){
        switch sender.state {
        case .changed, .ended:
            pipsRtio*=sender.scale
            sender.scale = 1.0
        default:
            break
        }
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRedus)
        path.addClip()
        UIColor.white.setFill()
        path.fill()
        
        if isFaceUp{
            if let cardImage = UIImage(named: rankString+sute, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                cardImage.draw(in: bounds.zoom(py: pipsRtio))
            }else {
                drawPips()
            }
        } else {
            if let faceDownBackGround = UIImage(named: "stanford-tree", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceDownBackGround.draw(in: bounds)
            }
        }
        /*self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale*/
        
    }
    

}
extension CardView {
    private struct sizeRatio {
        static let cornreFontSizeToBoundHight:CGFloat = 0.085
        static let cornerRedusToToBoundHight:CGFloat = 0.06
        static let cornerOffsetToCornerRedius:CGFloat = 0.33
        static let faceCardImageToboundSize:CGFloat = 0.65
        static let pipsOffsetRatio:CGFloat = 1.8
    }
    private var pipsOffset:CGSize{
        return CGSize(width: cornerString.size().width, height: cornerString.size().width * sizeRatio.pipsOffsetRatio)
    }
    private var cornerRedus:CGFloat{
        return bounds.size.height * sizeRatio.cornerRedusToToBoundHight
    }
    private var cornerFontSize:CGFloat {
        return bounds.size.height * sizeRatio.cornreFontSizeToBoundHight
    }
    private var cornerOffset:CGFloat {
        return cornerRedus * sizeRatio.cornerOffsetToCornerRedius
    }
    private var rankString:String {
        switch rank {
            case 1: return "A"
            case 2...10: return String(rank)
            case 11: return "J"
            case 12: return "Q"
            case 13: return "K"
            default: return "?"
        }
    }
    
}
extension CGRect {
    var leftHafe : CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHafe : CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func  inset(py size:CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size:CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(py ratio:CGFloat) -> CGRect {
        return insetBy(dx: (width-(width*ratio))/2, dy: (height-(height*ratio))/2)
    }
}
extension CGPoint {
    func  offsetBy(dx:CGFloat, dy:CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
