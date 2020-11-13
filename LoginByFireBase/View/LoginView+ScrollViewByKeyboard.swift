
import UIKit

extension LoginView
{
    ///當推出鍵盤時，自動將畫面上移
    func scrollViewByKeyboard(){
        let observer = NotificationCenter.default
        
        //NotificationCenter.default.addObserver(觀察者, selector: #selector(觀察者用來處理通知的方法), name: 通知的名稱, object: 要觀察的對象物件)
        observer.addObserver(self, selector: #selector(scrollUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        observer.addObserver(self, selector: #selector(scrollDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func scrollUp(){
        if self.bounds.height == UIScreen.main.bounds.height * 0.8
        {
            return
        }
        let animate = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY * 0.75)
        }
        animate.startAnimation()
    }
    @objc func scrollDown(){
        let animate = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY )
            
            
        }
        animate.startAnimation()
    }
    
}
