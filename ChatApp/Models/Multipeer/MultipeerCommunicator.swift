//
//  MultipeerCommunicator.swift
//  ChatApp
//
//  Created by Иван Лебедев on 18/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {

    var online: Bool = false
    var userName: String
    var userPeerID: MCPeerID

    var session: MCSession

    var browser: MCNearbyServiceBrowser
    var advertiser: MCNearbyServiceAdvertiser

    weak var delegate: CommunicatorDelegate?

    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    var peers: [MCPeerID] = []

    init(userName: String) {

        online = true

        self.userName = userName
        if self.userName == "" {
            self.userName = "Default" + "\(Date())"
        }
        self.userPeerID = MCPeerID(displayName: UIDevice.current.name)

        self.session = MCSession(peer: self.userPeerID)
        self.advertiser = MCNearbyServiceAdvertiser(peer: userPeerID, discoveryInfo: ["userName": self.userName], serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: userPeerID, serviceType: "tinkoff-chat")

        super.init()

        self.advertiser.delegate = self
        self.browser.delegate = self
        self.session.delegate = self

        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()

        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tinkoff-chat", discoveryInfo: ["userName": self.userName], session: session)
        mcAdvertiserAssistant.start()
    }

    func sendMessage(text: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        let message = MultipeerMessage(text: text)
        do {
            try self.session.send(try JSONEncoder().encode(message),
                                  toPeers: session.connectedPeers.filter({$0.displayName == userID}),
                                  with: .reliable)
            completionHandler?(true, nil)
        } catch let error {
            Debugger.shared.dbprint("Error:" + error.localizedDescription)
            completionHandler?(false, error)
        }

        self.delegate?.didReceiveMessage(text: message.text, fromUser: userName, toUser: userID)
    }

    func connectPeer(userID: String) {
        let peer = peers.filter({$0.displayName == userID})
        if peer.count > 0 {
            browser.invitePeer(peer[0], to: session, withContext: nil, timeout: TimeInterval(exactly: 10) ?? TimeInterval())
        }
    }

    func disconnectPeers() {
        self.session.disconnect()
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        self.delegate?.failedToStartAdvertising(error: error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if self.session.connectedPeers.count == 0 {
            invitationHandler(true, self.session)
            return
        }
        invitationHandler(false, nil)
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate?.failedToStartBrowsingForUsers(error: error)
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {

        self.peers.append(peerID)
        self.delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"] ?? "")
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.didLostUser(userID: peerID.displayName)
        self.peers.removeAll(where: {$0 == peerID})
    }

}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Nothing here
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Nothing here
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Nothing here
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //Nothing here
        self.delegate?.stateChanged(displayName: peerID.displayName, state: state)
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(MultipeerMessage.self, from: data)
            self.delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: userPeerID.displayName)
        } catch let err {
            Debugger.shared.dbprint("Error while unpacking message:\n" + err.localizedDescription)
        }
    }

}
