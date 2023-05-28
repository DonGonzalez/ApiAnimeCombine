//
//  dfvdfv.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit

class AnimeTableView: UITableView {
    
   private let identifier = "TableViewCell"
    
   private var animeData: Anime?
    var animeDetails: [AnimeData]?
    
    func showData(data: Anime) {
        self.animeData = data
        self.animeDetails = data.data
        self.reloadData()
    }
    
    func addData( newData: Anime) {
        self.animeData = newData
        self.animeDetails?.append(contentsOf: animeData!.data)
        self.reloadData()
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
        self.register(UINib(nibName: identifier,
                            bundle: nil),
                      forCellReuseIdentifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimeTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeDetails?.count ??  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
        cell.config(title: animeDetails?[indexPath.row].attributes.canonicalTitle ?? "",
                    season: animeDetails?[indexPath.row].attributes.episodeCount ?? 0,
                    imageURL: animeDetails?[indexPath.row].attributes.posterImage?.tiny)
        return cell
    }
}

