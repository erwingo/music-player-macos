//
//  MainController.swift
//  music-player-mac
//
//  Created by Erwin GO on 4/28/17.
//  Copyright © 2017 Erwin GO. All rights reserved.
//

import Cocoa

class MainController: NSViewController {
    // MARK: - Properties

    private var listViewEl: ListView!
    private var playingListViewEl: ListView!
    private var songsUpdatedObserver: NSObjectProtocol!
    
    private lazy var sidebarEl: View = {
        let v = View()
        v.layer?.backgroundColor = NSColor.blue.cgColor
        
        let allSongsBtnEl = NSButton()
        allSongsBtnEl.title = "All Songs"
        allSongsBtnEl.target = self
        allSongsBtnEl.action = #selector(self.showAllSongs)
        v.addSubview(allSongsBtnEl)
        allSongsBtnEl.topAnchorToEqual(v.topAnchor)
        allSongsBtnEl.leftAnchorToEqual(v.leftAnchor)

        let allPlaylistsBtnEl = NSButton()
        allPlaylistsBtnEl.title = "All Playlists"
        allPlaylistsBtnEl.target = self
        allPlaylistsBtnEl.action = #selector(self.showAllPlaylists)
        v.addSubview(allPlaylistsBtnEl)
        allPlaylistsBtnEl.topAnchorToEqual(allSongsBtnEl.bottomAnchor)
        allPlaylistsBtnEl.leftAnchorToEqual(v.leftAnchor)
    
        return v
    }()
    
    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)!
        view.layer?.backgroundColor = NSColor.black.cgColor
        songsUpdatedObserver = NotificationCenter.default.addObserver(forName: .customSongsUpdated, object: nil, queue: nil, using: handleSongsUpdated)
        initViews()
        
        updateSongs()
        showAllSongs()
        AppSingleton.shared.updateSongs()
        AppSingleton.shared.updatePlaylists()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(songsUpdatedObserver)
    }
    
    private func initViews() {
        let title = NSTextField()
        title.isEditable = false
        title.stringValue = "Does this work"
        title.isBordered = false
        title.font = NSFont.systemFont(ofSize: 18)
        title.textColor = .blue
        
        let playerEl = Player()
        view.addSubview(playerEl)
        playerEl.heightAnchorToEqual(height: 100)
        playerEl.topAnchorToEqual(view.topAnchor)
        playerEl.leftAnchorToEqual(view.leftAnchor)
        playerEl.rightAnchorToEqual(view.rightAnchor)
        
        view.addSubview(sidebarEl)
        sidebarEl.topAnchorToEqual(playerEl.bottomAnchor)
        sidebarEl.bottomAnchorToEqual(view.bottomAnchor)
        sidebarEl.leftAnchorToEqual(view.leftAnchor)
        sidebarEl.widthAnchorToEqual(width: 200)
        
        playingListViewEl = ListView("Playing", onItemSelected: nil, onCloseClick: nil)
        view.addSubview(playingListViewEl)
        playingListViewEl.topAnchorToEqual(playerEl.bottomAnchor)
        playingListViewEl.bottomAnchorToEqual(view.bottomAnchor)
        playingListViewEl.widthAnchorToEqual(width: 300)
        playingListViewEl.rightAnchorToEqual(view.rightAnchor)
        
        listViewEl = ListView("...", onItemSelected: nil, onCloseClick: nil)
        view.addSubview(listViewEl)
        listViewEl.topAnchorToEqual(playerEl.bottomAnchor)
        listViewEl.bottomAnchorToEqual(view.bottomAnchor)
        listViewEl.leftAnchorToEqual(sidebarEl.rightAnchor)
        listViewEl.rightAnchorToEqual(playingListViewEl.leftAnchor)
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = View()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Private Methods

    private func handleSongsUpdated(_: Notification) {
        updateSongs()
    }
    
    private func updateSongs() {
        listViewEl.updateData(ListView.getMediaCellDataArrayFromSongModelArray(AppSingleton.shared.songs))
        playingListViewEl.updateData(ListView.getMediaCellDataArrayFromSongModelArray(AppSingleton.shared.songs))
    }

    @objc private func showAllPlaylists() {
        listViewEl.updateData(ListView.getMediaCellDataArrayFromPlaylistModelArray(AppSingleton.shared.playlists))
        listViewEl.updateTitle("All Playlists")
    }
    
    @objc private func showAllSongs() {
        listViewEl.updateData(ListView.getMediaCellDataArrayFromSongModelArray(AppSingleton.shared.songs))
        listViewEl.updateTitle("All Songs")
    }
}