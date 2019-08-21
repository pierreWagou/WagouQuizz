import UIKit

class ViewController: UIViewController {
    
    var game = Game()
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        questionView.title = "Loading..."
        questionView.style = .standard
        scoreLabel.text = "0 / 10"
        UIView.animate(withDuration: 1, animations: ({
            self.scoreLabel.transform = CGAffineTransform(rotationAngle: 0)
        }))
        
        game.refresh()
        
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title
        
    }
    
    
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .ended, .cancelled:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationPercent = 2*translation.x / UIScreen.main.bounds.width
        let rotationAngle = translationPercent * CGFloat.pi/6
        let rotationtransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationtransform)
        questionView.transform = transform
        
        if translation.x>0 {
            questionView.style = .correct
        }
        if translation.x==0 {
            questionView.style = .standard
        }
        if translation.x<0 {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        scoreLabel.text = "\(game.score) / 10"
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }
        else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: {(success) in
            if success {
                self.showQuestionView()
            }
        })
        UIView.animate(withDuration: 1, animations: ({
            let radians = atan2f(Float(self.scoreLabel.transform.b), Float(self.scoreLabel.transform.a));
            self.scoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat(radians) + CGFloat.pi/5)
        }))
    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        questionView.style = .standard
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
            }, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
    questionView.addGestureRecognizer(panGestureRecognizer)
        
        startNewGame()
    }


}

