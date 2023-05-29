//
//  sfddgdfvx.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit
import Combine

class AnimeViewController: UIViewController {
    
    //MARK: Variable
    var viewModel: AnimeViewModel?
    var animeTableView = AnimeTableView()
    let searchBar = UISearchBar()
    var cancellabe = Set<AnyCancellable>()
    var offset: Int = 0
    
    //MARK: Publishers
    let didLoad = PassthroughSubject<Void,Never>()
    let animeDataStart = PassthroughSubject<Anime,Error>()
    let indexAnimeCell = PassthroughSubject<Int,Never>()
    let searchText = PassthroughSubject<String,Never>()
    let infiniteScroll = PassthroughSubject<Int,Never>()
    let modalViewControler = PassthroughSubject<ModalViewController.UserFilterOption,Never>()
    var initAnimeData = CurrentValueSubject<Bool,Never>(true)
    
    func assignDependencies(viewModel: AnimeViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.binding()
        self.didLoad.send()
        self.configureSearchBar()
        self.tableViewConfig()
        self.createNavigationBarButtons()
    }
    
    private func configureSearchBar() {
        self.view.addSubview(searchBar)
        self.searchBar.showsCancelButton = true
        self.searchBar.showsScopeBar = true
        self.searchBar.delegate = self
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func tableViewConfig() {
        self.view.addSubview(animeTableView)
        animeTableView.delegate = self
        animeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            animeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            animeTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            animeTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    // polaczenie
    func binding() {
        let input = AnimeViewModel.Input(initialAnime: didLoad.eraseToAnyPublisher(), clickAnimeCell: indexAnimeCell.eraseToAnyPublisher(), onSearchText: searchText.eraseToAnyPublisher(), updateAnime: infiniteScroll.eraseToAnyPublisher())
        
        let output = viewModel?.transform(input: input)
        
        output?.showAnimeData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complition in
                print("showdatacomp\(complition)")
            }, receiveValue: { [weak self] data in
                self?.animeTableView.showData(data: data)
            })
            .store(in: &viewModel!.cancellableAnimeViewModel)
        
        output?.showMessaageErrorType
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { MessageErrorType in
                PopupAlert.shared.createAlert(view: self, title: "", errorData: MessageErrorType)
            })
            .store(in: &cancellabe)
        
        output?.showLoadingPopup
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { index in
                let applicationDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                applicationDelegate.window!.rootViewController?.view.addSubview(LoadingPopup.shared.createLoadingPopup(view: self))
            })
            .store(in: &cancellabe)
        
        output?.showSingleAnimeData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    return
                case .failure(let error):
                    print(" showAnimeData \(error)")
                    return
                }
            }, receiveValue: {[weak self] anime in
                LoadingPopup.shared.dismissLoadingPopup()
                self?.viewModel?.createDetailViewController(singleData: anime)
                self?.view.isUserInteractionEnabled = true
                self?.dismiss(animated: true)
            })
            .store(in: &cancellabe)
        
        output?.dissmisLoadingPopup
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                LoadingPopup.shared.dismissLoadingPopup()
                self?.view.isUserInteractionEnabled = true
            })
            .store(in: &cancellabe)
        
        output?.showUpdateAnime
        
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { anime in
                self.animeTableView.addData(newData: anime)
            })
            .store(in: &cancellabe)
    }
}

extension AnimeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.view.isUserInteractionEnabled = false
        let index = Int((animeTableView.animeDetails?[indexPath.row].id ?? "0"))
        self.indexAnimeCell.send(index!)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let totalNumberOfCell = tableView.numberOfRows(inSection: 0)
        let lastDetectCell = indexPath.last
        // Check when create request and add new data to TableView
        if lastDetectCell! - 5 ==  animeTableView.animeDetails!.count - 6
            && animeTableView.animeDetails?.count != offset{
            //send to model view information for request
            self.infiniteScroll.send(totalNumberOfCell)
            self.offset = totalNumberOfCell
        }
        else {
        }
    }
}

extension AnimeViewController: UISearchBarDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.searchTextField.isUserInteractionEnabled = true
        self.searchBar.isUserInteractionEnabled = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            let convertedUserText = "&filter[text]=\(searchText.convertUserText)"
            self.searchText.send(convertedUserText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userText = searchBar.searchTextField.text
        else {
            return _ = " "
        }
        let convertedUserText = "&filter[text]=\(userText.convertUserText)"
        self.searchText.send(convertedUserText)
        searchBar.searchTextField.isUserInteractionEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isUserInteractionEnabled = false
        searchBar.searchTextField.isUserInteractionEnabled = false
        searchBar.searchTextField.text = ""
        self.searchText.send("")
    }
}
extension String {
    // computed value
    var convertUserText: String {
        let trimSpace = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let removeSpace = trimSpace.replacingOccurrences(of: " ", with: "")
        let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let stripedText = removeSpace.filter {chars.contains($0) }
        return stripedText
    }
}
