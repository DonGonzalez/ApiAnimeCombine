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
    var arrayImage: [String] = []
   private var animeData: Anime?
    var animeDetails: [AnimeData]?
    
    func showData(data: Anime) {
        self.animeData = data
        self.animeDetails = data.data
        self.reloadData()
    }
    
    func addData( newData: Anime) {
        let oldAnimeDatails = animeDetails
        //self.animeData = newData
        self.animeDetails?.append(contentsOf: newData.data)
          //  self.reloadData()
        let index = Int(exactly: oldAnimeDatails!.count)!
        
        if index != 0 {
           
            let start = index - 1 
            let end = start + newData.data.count
            print(start)
            print(end)
            let indexPath = Array(start..<end).compactMap ({
                return IndexPath(row: $0, section: 0)
            })
            self.insertRows(at: indexPath, with: .none)
        }
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
var boolImage = false
extension AnimeTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeDetails?.count ??  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! TableViewCell
      
        
        let representID = self.animeDetails?[indexPath.row].id
        cell.identif = representID!
        
        DispatchQueue.main.async {
            cell.AnimeImageView.image = nil
            
            if cell.identif == representID{
                print(cell.identif == representID)
                cell.config(title: self.animeDetails?[indexPath.row].attributes.canonicalTitle ?? "",
                            season: self.animeDetails?[indexPath.row].attributes.episodeCount ?? 0,
                            imageURL: self.animeDetails?[indexPath.row].attributes.posterImage?.tiny)
                //   cell.imageView?.loadImage(url: self.animeDetails?[indexPath.row].attributes.posterImage?.tiny)
            }
        }
      
        // imageURL: self.animeDetails?[indexPath.row].attributes.posterImage?.tiny
        //  cell.config(title: self.animeDetails?[indexPath.row].attributes.canonicalTitle ?? "",
        //              season: self.animeDetails?[indexPath.row].attributes.episodeCount ?? 0)
        
        
        // self.arrayImage.append(self.animeDetails?[indexPath.row].attributes.posterImage?.tiny ?? "")
        return cell
    
    }
}

