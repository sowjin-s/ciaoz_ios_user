//
//  SingleChatController.swift
//  User
//
//  Created by CSS on 05/03/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox

// ENUM Chat Type

enum ChatType : Int {
    
    case single = 1
    case group = 2
    case media = 3
    
}

class SingleChatController: UIViewController {
    
    
    @IBOutlet private var tableView : UITableView!
    @IBOutlet private var bottomConstraint : NSLayoutConstraint!
    @IBOutlet private var textViewSingleChat : UITextView!
    
    @IBOutlet private weak var viewCamera : UIView!
    @IBOutlet private weak var viewRecord : UIView!
    @IBOutlet private weak var viewSend : UIView!
    
    @IBOutlet private weak var progressViewImage : UIProgressView!
    
    private var navigationTapgesture : UITapGestureRecognizer!
    private var imageButtonView : UIImageView? // used to modify profile image after changes
    
    private let senderCellTextId = "sender"
    private let recieverCellTextId = "reciever"
    private let senderMediaId = "senderMedia"
    private let reciverMediaId = "reciverMedia"
    
    private lazy var loader : UIView = {
        createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    private var datasource = [ChatResponse]()   // Current Chat Data
    
    private var currentUser : (Provider)! // Current User Data
    
    private var chatType :  ChatType!   // Current Chat eg:-  single or group
    
    private var currentUserId = 0
    
    private var isSendShown = false {
        
        didSet {
            
            self.viewCamera.isHidden = true //isSendShown
            self.viewSend.isHidden = !isSendShown
            self.viewRecord.isHidden = true
            
        }
        
    }
    
    private var addedObservers = [UInt]() // Added Observers
    
    private var viewJustAppeared = true
    
    private var isConversationToneEnabled = false
    
    // Deinit
    
    deinit {  // Remove the current firebase observer
        
        FirebaseHelper.shared.remove(observers: self.addedObservers)
        
    }
    
    let avPlayerHelper = AVPlayerHelper()
    
    
    let chatSenderNib = "ChatSender"
    let chatRecieverNib = "ChatReciever"
    let imageCellSenderNib = "ImageCellSender"
    let imageCellRecieverNib = "ImageCellReciever"
    
    
}



extension SingleChatController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    //MARK:- Set Current User Data
    
    func set(user : Provider, chatType : ChatType = .single){
        
        self.currentUser = user
        self.chatType = chatType
        self.currentUserId = currentUser.id ?? 0
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.viewJustAppeared = true
        self.isConversationToneEnabled = true//UserDefaults.standard.bool(forKey: Keys.list.conversationTones)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeGestureRecognizer(self.navigationTapgesture)
        
    }
    
    
    //MARK:- Make Tone
    
    private func makeTone(){
        
        if self.isConversationToneEnabled {
            
            DispatchQueue.main.async {
                self.avPlayerHelper.play(file: "mesageTone.wav", isLooped: false)
            }
        }
    }
    
//    private func refreshUserData(){
//
//        if self.currentUser.isInvalidated{
//
//            if let currentUserData = RealmHelper.main.getObject(of: self.chatType == .single ? RealmContact.self : RealmGroup.self, with: self.currentUserId) {
//                 self.currentUser = currentUserData
//            } else {
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
//
//    }
//
    
    //MARK:- Update UI
    
    private func updateUI() {
        
        self.tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [IndexPath(row: 0, section: 0)], with: .fade)
        self.navigationTapgesture = UITapGestureRecognizer(target: self, action: #selector(self.navigationBarTapped))
        self.navigationController?.navigationBar.addGestureRecognizer(self.navigationTapgesture)
        self.navigationItem.title = String.removeNil(currentUser.first_name)+" "+String.removeNil(currentUser.last_name)
        Cache.image(forUrl: Common.getImageUrl(for: currentUser.avatar)) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageButtonView?.image = image?.resizeImage(newWidth: 30)?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
        
        if traitCollection.forceTouchCapability == .available {  // Set Peek and pop for Image Preview
            self.registerForPreviewing(with: self, sourceView: self.tableView)  // Setting image preview for tableview cells
        }
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } 
        let backButtonArrow = UIBarButtonItem(image: #imageLiteral(resourceName: "close-1"), style: .plain, target: self, action: #selector(self.backAction))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let imageButton = UIBarButtonItem(image: #imageLiteral(resourceName: "userPlaceholder").resizeImage(newWidth: 30)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.navigationBarTapped))
        Cache.image(forUrl: Common.getImageUrl(for: currentUser.avatar)) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    
                    let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
                    imageView.makeRoundedCorner()
                    imageView.image = image?.resizeImage(newWidth: 30)?.withRenderingMode(.alwaysOriginal)
                    imageView.contentMode = .scaleAspectFill
                    imageButton.customView = imageView
                    imageButton.customView?.isUserInteractionEnabled = true
                   // imageButton.image = #imageLiteral(resourceName: "account").resizeImage(newWidth: 40)?.withRenderingMode(.alwaysOriginal)
                   // imageButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.navigationBarTapped)))
                    self.imageButtonView = imageView
                }
            }
        }
        
        self.navigationItem.leftBarButtonItems = [backButtonArrow,fixedSpace,imageButton]
        
//        if chatType == .single {  // Media call only allowed to single chat
//
//            let callButton = UIBarButtonItem(image: #imageLiteral(resourceName: "call_icon"), style: .plain, target: self, action: #selector(self.callButtonAction))
//            let videoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "video_icon"), style: .plain, target: self, action: #selector(self.videoButtonAction))
//
//            self.navigationItem.rightBarButtonItems?.append(contentsOf: [videoButton,callButton])
//        }
        
        self.addKeyBoardObserver(with: bottomConstraint)
        self.textViewSingleChat.delegate = self
        self.tableView.register(UINib(nibName: chatSenderNib, bundle: .main), forCellReuseIdentifier: senderCellTextId)
        self.tableView.register(UINib(nibName: chatRecieverNib, bundle: .main), forCellReuseIdentifier: recieverCellTextId)
        self.tableView.register(UINib(nibName: imageCellSenderNib, bundle: .main), forCellReuseIdentifier: senderMediaId)
        self.tableView.register(UINib(nibName: imageCellRecieverNib, bundle: .main), forCellReuseIdentifier: reciverMediaId)
        
        self.viewSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendOnclick)))
        self.viewRecord.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.recordOnclick)))
        self.viewCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cameraOnclick)))
        self.isSendShown = false
        self.startObservers()
        
    }
    
    @IBAction private func backAction() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction private func navigationBarTapped(){
        
        print("Navigstion bar tapped ")
       
    }
 
    // MARK:- Start Observers
    
    private func startObservers(){
        
        let chatPath = Common.getChatId(with: currentUser.id)
        
        let childObserver = FirebaseHelper.shared.observe(path : chatPath, with: .childAdded) { (childValue) in
            
                if self.datasource.count>0, let child = childValue.first {
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.beginUpdates()
                        
                        if self.datasource.filter({ $0.key == child.key }).count == 0 {
                            
                            self.datasource.append(child)
                            self.tableView.insertRows(at: [IndexPath(row: self.datasource.count-1, section: 0)], with: .fade)
                        }
                        
                        self.tableView.endUpdates()
                        self.tableView.scrollToRow(at: IndexPath(row: self.datasource.count-1, section: 0), at: .bottom, animated: false)
                        
                    }
                    self.makeTone()
                    
                } else {
                    
                    self.datasource =  childValue
                    
                    DispatchQueue.main.async {
                        self.reload()
                    }
                }
            
            
        }
        
        
        
        let modifedObserver = FirebaseHelper.shared.observe(path : chatPath, with: .childChanged) { (childValue) in
            
            if let childNode = childValue.first, let index = self.datasource.index(where: { (chat) -> Bool in
                chat.key == childNode.key
            })
            {
                
                self.datasource[index] = childNode
                
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
                
            }
        }
        
        self.addedObservers.append(childObserver)
        self.addedObservers.append(modifedObserver)
        
    }

    
    @IBAction private func reload()
    {
     
        self.tableView.reloadData()
        if self.datasource.count>0{
            UIView.animate(withDuration: 0.5, animations: {  // reload and scroll to last index
                self.tableView.scrollToRow(at: IndexPath(row: self.datasource.count-1, section: 0), at: .top, animated: false)
            })
        }
        
    }
    
    
    // MARK:- More Button Action
    
    @IBAction private func moreButtonAction(){
        
        
        
    }
    
    
//    // MARK:- Image Button Action
//
//    @IBAction private func imageButtonAction(){
//
//        print("Image button click")
//    }
    
    
//    //MARK:- Call Button Action
//    
//    @IBAction private func callButtonAction(){
//       
//        Common.moveToAppRTC(with: .AUDIO, forUser: currentUser, from: self)// Move To App RTC Audio Call
//    }
//    
//    
//    //MARK:- Video Button Action
//    
//    @IBAction private func videoButtonAction(){
//        
//        Common.moveToAppRTC(with: .VIDEO, forUser: currentUser, from: self) // Move to App RTC Video Call
//        
//    }
//    
//    
//    
    //MARK:- Camera Onclick Action
    
    @IBAction private func cameraOnclick(){
        
        SelectImageView.main.show(imagePickerIn: self) { (images) in
            
            if let image = images.first, let imageData = image.resizeImage(newWidth: 400), let data = UIImagePNGRepresentation(imageData), let currentId = self.currentUser.id {
                
                self.progressViewImage.isHidden = false
                
                let task = FirebaseHelper.shared.write(to: currentId, with: data, mime: .image, type : self.chatType, completion: { (isCompleted) in
                    
                    DispatchQueue.main.async {
                        self.progressViewImage.isHidden = true
                    }
                    
//                    // Send FCM Push
//
//                    if isCompleted {
//
//                        self.sendPush(with: Constants.string.image)
//                    }
//
                    print("isCompleted  -- ",isCompleted)
                    
                })
                
                task.observe(.progress, handler: { (snapShot) in
                    
                    DispatchQueue.main.async {
                        self.progressViewImage.progress = (Float(snapShot.progress!.completedUnitCount/snapShot.progress!.totalUnitCount)) 
                    }
                    
                    print("Progress  ",(snapShot.progress!.completedUnitCount/snapShot.progress!.totalUnitCount) * 100)
                    
                })
                
            }
            
        }
        
    }
    
    //MARK:- Record Onclick Action
    
    @IBAction private func recordOnclick(){
        
        
        
    }
    
    @IBAction private func sendOnclick(){
        
//        self.validatedIfBlocked {
        
            FirebaseHelper.shared.write(to: self.currentUserId, with: self.textViewSingleChat.text, type : self.chatType)
           // self.sendPush(with: self.textViewSingleChat.text)
           // self.initimateServerAboutChat()
        
        DispatchQueue.global(qos: .background).async {
            let message = "\(User.main.firstName ?? .Empty) : \(self.textViewSingleChat.text ?? .Empty)"
            self.presenter?.post(api: .chatPush, data: ChatPush(sender : .provider, user_id: self.currentUserId, message: message).toData())
        }
        self.textViewSingleChat.text = .Empty
        self.textViewDidEndEditing(self.textViewSingleChat)
//
//            if let currentUserData = RealmHelper.main.getObject(of: RealmContact.self, with: self.currentUserId) {
//                RealmHelper.main.modify {
//                    RealmHelper.main.write(modal: currentUserData, completion: { (isCompleted) in
//                        print("Chat History added ", currentUserData.name ?? .Empty)
//                    })
//                }
//            }
      //  }
        
        
    }
    
    
//    //MARK:- Send Push with Message
//
//    private func sendPush(with message : String?){
//
//        var tokens = [String]()
//
//        if self.chatType == .single {
//
//            guard let userData = RealmHelper.main.getObject(of: RealmContact.self, with: currentUserId) else { return }
//
//            tokens.append(userData.deviceToken ?? .Empty)
//
//        } else if self.chatType == .group {
//
//            guard let userData = RealmHelper.main.getObject(of: RealmGroup.self, with: currentUserId)?.contact.filter({ $0.id != User.main.id }) else { return }
//
//            tokens.append(contentsOf: userData.map({ $0.deviceToken ?? .Empty }))
//
//        }
//
//        self.setPresenter()
//        self.presenter?.post(api: .fcmPush, data: MakeJson.sendPush(tokens: tokens, title: User.main.name, body: message))
//
//    }
//
//    //MARK:- Intimate Server about messaging User
//
//    private func initimateServerAboutChat(){
//
//        if self.viewJustAppeared {  // Hitting api only on first view appeared
//
//            self.setPresenter()
//            let endUser = BlockModal()
//            endUser.user_id = User.main.id
//            endUser.receiver_id = self.currentUser.id
//            self.presenter?.post(api: .postChatHistory, data: endUser.toData())
//
//
//
//        }
//
//    }
    
//    //MARK:- Validate If Blocked
//
//    private func validatedIfBlocked(onSuccess completion : @escaping (()->Void)){
//     // Validating whether the user is blocked
//        guard let chatUser = RealmHelper.main.getObject(of: RealmContact.self, with: currentUser.id), chatUser.isBlocked else {
//            completion()
//            return
//        }
//
//        let alert = UIAlertController(title: Constants.string.unBlockInfo , message: nil, preferredStyle: .alert)
//
//        let unblockAction = UIAlertAction(title: Constants.string.unBlock, style: .default) { (Void) in
//
//            let block = BlockModal()
//            block.user_id = User.main.id
//            block.contact_user_id = self.currentUser.id
//            block.is_blocked = "\((!chatUser.isBlocked).hashValue)"
//
//            self.loader.isHidden = false
//
//            self.setPresenter()
//            self.presenter?.post(api: .blockUser, data: block.toData())
//
//        }
//
//        let cancelAction = UIAlertAction(title: Constants.string.Cancel, style: .cancel, handler: nil)
//
//        alert.view.tintColor = .primary
//        alert.addAction(cancelAction)
//        alert.addAction(unblockAction)
//
//        self.present(alert, animated: true, completion: nil)
//
//
//    }
    
    
    //MARK:- Back Button Action
    
    @IBAction private func backButtonAction(){
        
        if navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            print(currentPoint)
            if !self.textViewSingleChat.bounds.contains(currentPoint){
                self.textViewSingleChat.resignFirstResponder()
            }
        }
    }
    
    
    private func setEmptyView(){
        
        DispatchQueue.main.async {
            
            self.tableView.backgroundView = self.datasource.count == 0 ?  {
                
                let label = UILabel(frame: self.tableView.bounds)
                label.textAlignment = .center
                label.text = Constants.string.noChatHistory
                Common.setFont(to: label, isTitle: true)
                return label
                
                }() : nil
            
        }
    }
    
    
    //MARK:- Show Image Preview
    
    private func getImagePreview(index : Int)->LightboxController?{
        
        if datasource.count>index, datasource[index].response?.type == Mime.image.rawValue, let url = URL(string: (datasource[index].response?.url) ?? .Empty) {
            
            let image = LightboxImage(imageURL: url)
            
            let lightBox = LightboxController(images: [image], startIndex: 0)
            lightBox.dynamicBackground = true
            LightboxConfig.CloseButton.image = #imageLiteral(resourceName: "close-1")
            LightboxConfig.CloseButton.text = .Empty
            LightboxConfig.CloseButton.size = CGSize(width: 25, height: 25)
            LightboxConfig.PageIndicator.enabled = false
            return lightBox
        }
        
        return nil
    }
    
    
    
    
}


//MARK:- TableView Datasource and delegate

extension SingleChatController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        if indexPath.row % 2 == 0 {
        
        if let chat = datasource[indexPath.row].response, let tableCell = tableView.dequeueReusableCell(withIdentifier: getCellId(from: chat), for: indexPath) as? ChatCell {
            
            if chat.user == User.main.id {
                
                tableCell.setSender(values: datasource[indexPath.row])
                
            } else {
                
                tableCell.setRecieved(values: datasource[indexPath.row], chatType: self.chatType)
            
                
            }
            
            return tableCell
        }
        
        
        
        
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: senderCellId, for: indexPath)  {
        //
        //                cell.setSender(values: datasource[indexPath.row])
        //
        //                return cell
        //
        //            }
        
        //        } else {
        //
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: recieverCellId, for: indexPath) as? ChatCell {
        //                cell.set(values: datasource[indexPath.row].0, isRecieved: datasource[indexPath.row].1)
        //                return cell
        //            }
        //
        //        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.datasource[indexPath.row].response?.type == Mime.text.rawValue {
            return UITableViewAutomaticDimension
        }
        
        return 400 * (568 / UIScreen.main.bounds.height)
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Preview Image
        
        if let lightBox = self.getImagePreview(index: indexPath.row){
            
            self.present(lightBox, animated: true, completion: nil)
            
        }
        
        UIView.animate(withDuration: 0.2) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }

    private func getCellId(from entity : ChatEntity)->String {
        
        if entity.senderType == UserType.user.rawValue {
            return entity.type == Mime.text.rawValue ? senderCellTextId : senderMediaId
        } else {
            return entity.type == Mime.text.rawValue ? recieverCellTextId : reciverMediaId
        }
        
    }
    
    
}


//MARK:- UITextViewDelegate

extension SingleChatController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == Constants.string.writeSomething {
            textView.text = .Empty
            textView.textColor = .black
        }
        self.reload()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == .Empty {
            textView.text = Constants.string.writeSomething
            textView.textColor = .lightGray
            isSendShown = false
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.isEmpty {
            isSendShown = true
        } else  {
            isSendShown = false
        }
        
    }
    
    
}


//MARK:- UIViewControllerPreviewingDelegate

extension SingleChatController : UIViewControllerPreviewingDelegate {
    
    // peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?{
        
        guard let indexPath = tableView.indexPathForRow(at: location),  // Getting image from tableview and show in peek preview
              let cell = tableView.cellForRow(at: indexPath),
              let vc = self.getImagePreview(index: indexPath.row) else {
            return nil
        }
        
        previewingContext.sourceRect = cell.frame
        vc.dismissalDelegate = self
        return vc
    }
    
    // pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){
       
        self.present(viewControllerToCommit, animated: true, completion: nil)
        
    }
}


//MARK:- PostViewProtocol

extension SingleChatController : PostViewProtocol {
  
    func onError(api: Base, message: String, statusCode code: Int) {
    
            DispatchQueue.main.async {
                self.view.make(toast: message)
            }
        print("Error in ",api,"  ", message)
        
    }
    
  
}

//MARK:- LightboxControllerDismissalDelegate

extension SingleChatController : LightboxControllerDismissalDelegate {
  
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
        controller.navigationController?.popViewController(animated: true)
        
    }
    
}




