//
//  vdfvdfvdf.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import Combine
import Foundation
import UIKit


class AnimeViewModel {
    
    //MARK: Publishers
    private let navigator: UINavigationController
     var cancellableAnimeViewModel = Set<AnyCancellable>()
     var publishAnime = PassthroughSubject<Anime, ErrorMessage>()
     var publishMessageErrorType = PassthroughSubject<MessageErrorType,Never>()
     var publishLoadingPopup = PassthroughSubject<Void,Never>()
     var publishDismissLoadingPopup = PassthroughSubject<Void,Never>()
     var publishSingleAnimeData = PassthroughSubject<SingleAnime,ErrorMessage>()
     var publishUpdateAnime = PassthroughSubject<Anime,ErrorMessage>()
    
    //MARK: Variable
    var selectedFilterMemory = ""
    var selectedSortMemory = ""
    var selectedSearchMemory = ""
    var filterDataToSend: ModalViewController.FilterType = .emptyEnum
    var sortDataToSend: [ModalViewController.SortType] = []
    
    private init (navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func createDetailViewController(singleData: SingleAnime) {
        DetailAnimeViewModel.create(navigator: self.navigator, singleData: singleData)
    }
    
    func createUserFiltringMenu(modalType: ModalViewController.UserFilterOption, sortSelect: [ModalViewController.SortType], filterSelect: ModalViewController.FilterType) -> UIViewController {
        
        let modalVC = ModalViewController(modalType: modalType, sortSelect: sortSelect, filterSelect: filterSelect)
        Publishers.CombineLatest(modalVC.sortSelect, modalVC.clickSortButton)
            .map{ (sort, _) -> [ModalViewController.SortType] in
                return sort
            }
            .sink { [weak self] sortAnime in
                self?.sortAnimeData(sort: sortAnime)
            }
            .store(in: &modalVC.modalCancelable)
        
        Publishers.CombineLatest(modalVC.filteSelect, modalVC.clickFilterButton)
            .map{ (filter, _) -> ModalViewController.FilterType in
                return filter
            }
            .sink { [weak self] filterAnime in
                self?.filterAnimeData(filter: filterAnime)
            }
            .store(in: &modalVC.modalCancelable)
        
        modalVC.modalTransitionStyle = .flipHorizontal
        modalVC.modalPresentationStyle = .custom
        modalVC.view.backgroundColor = .white
        modalVC.view.layer.cornerRadius = 8
        return modalVC
    }
    
    private func filterAnimeData(filter:ModalViewController.FilterType){
        self.filterDataToSend = filter
        self.selectedFilterMemory = filter.filterValue
        
        Services.shared.getAnime(endpoint: .moreAnime(offset: 0, sort: self.selectedSortMemory, filter: self.selectedFilterMemory, search: self.selectedSearchMemory))
            .sink { error in
                switch error{
                case .finished:
                    self.publishMessageErrorType.send(MessageErrorType.success("Fetch Complited"))
                    break
                case .failure(let error):
                    self.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                }
            } receiveValue: { anime in
                self.publishAnime.send(anime)
            }
            .store(in: &cancellableAnimeViewModel)
    }
    
    private func sortAnimeData(sort: [ModalViewController.SortType]){
        var sortContener: [String] = []
        var i = 0
        while i <= sort.count - 1 {
            sortContener.append(sort[i].sortValue)
            i += 1
        }
        self.sortDataToSend = sort
        if sortContener != []{
            self.selectedSortMemory = ("&sort=\(sortContener.joined(separator: ","))")
            
            Services.shared.getAnime(endpoint: .moreAnime(offset: 0, sort: self.selectedSortMemory, filter: self.selectedFilterMemory, search: self.selectedSearchMemory))
                .sink { error in
                    print(error)
                } receiveValue: { anime in
                    self.publishAnime.send(anime)
                }
                .store(in: &cancellableAnimeViewModel)
            
        } else {
            self.selectedSortMemory = sortContener.joined(separator: ",")
            
            Services.shared.getAnime(endpoint: .moreAnime(offset: 0, sort: self.selectedSortMemory, filter: self.selectedFilterMemory, search: self.selectedSearchMemory))
                .sink { error in
                    switch error{
                    case .finished:
                        self.publishMessageErrorType.send(MessageErrorType.success("Fetch Complited"))
                        break
                    case .failure(let error):
                        self.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                    }
                } receiveValue: { anime in
                    self.publishAnime.send(anime)
                }
                .store(in: &cancellableAnimeViewModel)
        }
    }
    
    struct Input {
        let initialAnime: AnyPublisher<Void,Never>
        let clickAnimeCell: AnyPublisher<Int,Never>
        let onSearchText: AnyPublisher<String,Never>
        let updateAnime: AnyPublisher<Int,Never>
    }
    
    struct Output {
        let showAnimeData: AnyPublisher<Anime,ErrorMessage>
        let showMessaageErrorType: AnyPublisher<MessageErrorType,Never>
        let showLoadingPopup: AnyPublisher<Void,Never>
        let dissmisLoadingPopup: AnyPublisher<Void,Never>
        let showSingleAnimeData: AnyPublisher<SingleAnime,ErrorMessage>
        let showUpdateAnime: AnyPublisher<Anime, ErrorMessage>
    }
    
    func transform(input: Input) -> Output {
        
        input.initialAnime
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [unowned self] _ in
                Services.shared.getAnime(endpoint: Endpoint.moreAnime(offset: 0, sort: self.selectedSortMemory, filter: self.selectedFilterMemory, search: self.selectedSearchMemory))
                    .sink { completion in
                        switch completion {
                        case .finished:
                            self.publishMessageErrorType.send(MessageErrorType.success("Fetch Complited"))
                            break
                        case .failure(let error):
                            self.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                            print(error.self)
                        }
                    }
            receiveValue: {[weak self] anime in
                self?.publishAnime.send(anime)
            }
                
            .store(in: &self.cancellableAnimeViewModel)
            }
            .store(in: &self.cancellableAnimeViewModel)
        
        input.clickAnimeCell
            .sink { [unowned self] cellIndex in
                // this is correct -> show popup and create request?
                self.publishLoadingPopup.send()
                Services.shared.getSingleAnime(endpoint: Endpoint.singleAnime(id: cellIndex))
                    .sink { [weak self] complition in
                        switch complition{
                        case .finished:
                            print("done")
                        case.failure(let error):
                            self?.publishDismissLoadingPopup.send()
                            self?.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                            return
                        }
                    } receiveValue: {[weak self] anime in
                        self?.publishSingleAnimeData.send(anime)
                    }
                    .store(in: &self.cancellableAnimeViewModel)
            }
            .store(in: &cancellableAnimeViewModel)
        
        input.onSearchText
            .sink { [weak self] text in
                self?.selectedSearchMemory = text
                Services.shared.getAnime(endpoint: Endpoint.moreAnime(offset: 0, sort: self?.selectedSortMemory ?? "", filter: self?.selectedFilterMemory ?? "", search: self?.selectedSearchMemory ?? ""))
                    .sink { [weak self] error in
                        switch error{
                        case .finished:
                            return print("done")
                        case.failure(let error):
                            self?.publishDismissLoadingPopup.send()
                            self?.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                            return
                        }
                    } receiveValue: {[unowned self] anime in
                        self?.publishAnime.send(anime)
                    }
                    .store(in: &self!.cancellableAnimeViewModel)
            }
            .store(in: &self.cancellableAnimeViewModel)
        
        input.updateAnime
            .throttle(for: .seconds(3.0), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] lastIndex in
                Services.shared.getAnime(endpoint: Endpoint.moreAnime(offset: lastIndex, sort: self?.selectedSortMemory ?? "", filter: self?.selectedFilterMemory ?? "", search: self?.selectedSearchMemory ?? ""))
                    .sink { [weak self] error in
                        switch error {
                        case .finished:
                            print("done")
                        case .failure(let error):
                            self?.publishMessageErrorType.send(MessageErrorType.failure(error.description))
                            return
                        }
                    } receiveValue: {[weak self] anime in
                        self?.publishUpdateAnime.send(anime)
                    }
                    .store(in: &self!.cancellableAnimeViewModel)
            }
            .store(in: &cancellableAnimeViewModel)
        
        return Output(showAnimeData:  publishAnime.eraseToAnyPublisher(),
                      showMessaageErrorType: publishMessageErrorType.eraseToAnyPublisher(),
                      showLoadingPopup: publishLoadingPopup.eraseToAnyPublisher(),
                      dissmisLoadingPopup: publishDismissLoadingPopup.eraseToAnyPublisher(),
                      showSingleAnimeData: publishSingleAnimeData.eraseToAnyPublisher(), showUpdateAnime: publishUpdateAnime.eraseToAnyPublisher())
    }
}

extension AnimeViewModel {
    
    static func create() -> UIViewController {
        let navigator = UINavigationController()
        navigator.navigationBar.backItem?.hidesBackButton = false
        navigator.navigationBar.backgroundColor = .systemGray3
        let viewModel = AnimeViewModel(navigator: navigator)
        let vc = AnimeViewController()
        vc.assignDependencies(viewModel: viewModel)
        vc.title = "CombineAnime"
        vc.view.backgroundColor = .white
        navigator.setViewControllers([vc], animated: false)
        return navigator
    }
}

