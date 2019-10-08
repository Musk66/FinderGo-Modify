//
//  FinderSync.swift
//  FinderSyncExtension
//
//  Created by Khoa Pham on 13/03/2017.
//  Copyright © 2017 Fantageek. All rights reserved.
//  Modifyed by tiger on 06/08/2018
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync, NSMenuDelegate {

  override init() {
    super.init()

    NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
  }

  // MARK: - Primary Finder Sync protocol methods

  override func beginObservingDirectory(at url: URL) {
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
  }


  override func endObservingDirectory(at url: URL) {
    // The user is no longer seeing the container's contents.
    NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
  }

  override func requestBadgeIdentifier(for url: URL) {
    NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)
  }

  // MARK: - Menu and toolbar item support

  override var toolbarItemName: String {
    return "FinderGo"
  }

  override var toolbarItemToolTip: String {
    return "FinderGo: Click the toolbar item for a menu."
  }

  override var toolbarItemImage: NSImage {
    return NSImage(named: "barIcon")!
  }

  override func menu(for menuKind: FIMenuKind) -> NSMenu {
    let menu = NSMenu(title: "")
    menu.delegate = self

    menu.addItem(withTitle: "Terminal", action: #selector(openTerminal(_:)), keyEquivalent: "")
    //    menu.addItem(withTitle: "iTerm", action: #selector(openiTerm(_:)), keyEquivalent: "")
    //    menu.addItem(withTitle: "Hyper", action: #selector(openHyper(_:)), keyEquivalent: "")
    menu.addItem(withTitle: "VSCode", action: #selector(openVSCode(_:)), keyEquivalent: "")
//     menu.addItem(withTitle: "SublimeText", action: #selector(openSublimeText(_:)), keyEquivalent: "")
    menu.addItem(withTitle: "压缩成Zip", action: #selector(openArchive(_:)), keyEquivalent: "")
    menu.addItem(withTitle: "新建文件夹", action: #selector(newFolder(_:)), keyEquivalent: "")
    menu.addItem(withTitle: "新建文件", action: #selector(newFile(_:)), keyEquivalent: "")

    return menu
  }

  // MARK: - NSMenuDelegate

  func menuWillOpen(_ menu: NSMenu) {
    guard let targetedUrl = FIFinderSyncController.default().targetedURL() else {
      return
    }

    let board = NSPasteboard.general()
    board.setString(targetedUrl.path, forType: NSPasteboardTypeString)
  }

  // MARK: - Action

    @IBAction func openTerminal(_ sender: AnyObject?) {
        run(fileName: "terminal")
    }
    
    @IBAction func openiTerm(_ sender: AnyObject?) {
        run(fileName: "iterm")
    }

    @IBAction func openHyper(_ sender: AnyObject?) {
        run(fileName: "hyper")
    }
    
    @IBAction func openVSCode(_ sender: AnyObject?) {
        run(fileName: "vscode")
    }
    
//     @IBAction func openSublimeText(_ sender: AnyObject?) {
//         run(fileName: "sublimetext")
//     }
    //注意：在终端中测试命令的时候只需要1个“\”，卸载AppleScipt脚本中则需要2个“\”，请注意中间空格部分的处理。
    //例如：终端中：open -a Archive\ Utility /Users/tiger/documents/github
    //do shell script " open -a Archive\\ Utility " & quoted form of cwd
    //另外，可以通过修改归档工具的偏好设置来修改打包后的文件格式，比如：修改为zip
    @IBAction func openArchive(_ sender: AnyObject?) {
        run(fileName: "archive")
    }
    
    @IBAction func newFile(_ sender: AnyObject?) {
        run(fileName: "newFile")
    }
    
    @IBAction func newFolder(_ sender: AnyObject?) {
        run(fileName: "newFolder")
    }

  // MARK: - Script

  func run(fileName: String) {
    guard let targetedUrl = FIFinderSyncController.default().targetedURL() else {
      return
    }

    let worker = ExtensionWorker(path: targetedUrl.path, fileName: fileName)
    worker.run()
  }
}

