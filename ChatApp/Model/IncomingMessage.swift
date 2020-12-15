//
//  IncomingMessage.swift
//  ChatApp
//
//  Created by Artyom Mihailovich on 12/4/20.
//

import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var messageCollectionView: MessagesViewController
    
    init(_collectionView: MessagesViewController) {
        messageCollectionView = _collectionView
    }
    
    
    //MARK: - Create message
    
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        
        if localMessage.type == kPHOTO {
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (image) in
               
                mkMessage.photoItem?.image = image
                self.messageCollectionView.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == kVIDEO {
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (thumbnail) in
                
                FileStorage.downloadVideo(videoLink: localMessage.videoUrl) { (isReadyToPlay, fileName) in
                    let videoURL = URL(fileURLWithPath: fileInDocumentDirectory(fileName: fileName))
                    let videoItem = VideoMessage(url: videoURL)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                }
                
                mkMessage.videoItem?.image = thumbnail
                self.messageCollectionView.messagesCollectionView.reloadData()
            }
        }
        
        return mkMessage
    }
}
