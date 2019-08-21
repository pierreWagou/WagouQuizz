import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.7861449122, green: 0.9234962463, blue: 0.6283481121, alpha: 1)
            icon.isHidden = false
            icon.image = UIImage(named: "Icon Correct")
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9509298205, green: 0.5277496576, blue: 0.5785906911, alpha: 1)
            icon.isHidden = false
            icon.image = UIImage(named: "Icon Error")
        case .standard:
            backgroundColor = #colorLiteral(red: 0.748629272, green: 0.7692008615, blue: 0.786057353, alpha: 1)
            icon.isHidden = true
        }
    }
    
    

}
