//
//  MainViewModel.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 16/01/2021.
//

import Combine
import UIKit

class MainViewModel: BaseViewModel, ObservableObject {

    // MARK: - Internal computed properties
    var actionHeroItems: [ActionHeroItem] {
        return Array(actionHeroes).sorted()
    }

    var isSquadSectionVisible: Bool {
        return isSquadListLoading || !hiredHeroesItems.isEmpty
    }

    var isSquadListLoading: Bool {
        return isSquadListFetching && hiredHeroesItems.isEmpty
    }

    // MARK: - Internal stored properties
    let navigation = PassthroughSubject<MainCoordinatorRoute, Never>()
    @Published var hiredHeroesItems = [ActionHeroItem]()
    @Published var isMainListLoading = false
    @Published var errorMessage: String?

    // MARK: - Private stored properties
    @Published private var isSquadListFetching = true
    @Published private var actionHeroes = Set<ActionHeroItem>()
    private let interactor: MarvelInteracting
    private var hiringManager: ActionHeroHiringProviding
    private let hiredListErrorHandler = ErrorHandler()
    private let itemLoadThreshold: Int
    private let itemLimit: Int
    private var currentOffset = 0
    private var itemsTotal = 1

    // MARK: - Internal methods
    init(listingConfig: MainViewListingConfig = MainViewListingConfig(),
         interactor: MarvelInteracting = MarvelInteractor(),
         hiringManager: ActionHeroHiringProviding = AppSettings.shared) {
        self.itemLoadThreshold = listingConfig.itemLoadThreshold
        self.itemLimit = listingConfig.itemLimit
        self.interactor = interactor
        self.hiringManager = hiringManager
        super.init()
        setupBindings()
        getCharacters()
    }

    func itemAppeared(_ item: ActionHeroItem) {
        guard actionHeroes.suffix(itemLoadThreshold).contains(item) else { return }
        getCharacters()
    }

    func itemTapped(_ item: ActionHeroItem) {
        navigation.send(.showDetails(item))
    }

    // MARK: - Private methods
    private func getCharacters() {
        guard !isMainListLoading,
              errorMessage == nil,
              actionHeroes.count < itemsTotal else { return }
        isMainListLoading = true
        let requestShared = interactor.getCharacters(offset: currentOffset,
                                                     limit: itemLimit)
            .handleErrors(errorHandler)
            .share()
        requestShared
            .map { $0.data.total }
            .assignNoRetain(to: \.itemsTotal, on: self)
            .store(in: &cancellableBag)
        requestShared
            .map { $0.data.results.map { ActionHeroItem(from: $0) } }
            .sink { [weak self] in self?.actionHeroes.insert($0) }
            .store(in: &cancellableBag)
        requestShared
            .combineLatest($actionHeroes) { $1.count }
            .assignNoRetain(to: \.currentOffset, on: self)
            .store(in: &cancellableBag)
        requestShared
            .map { _ in false }
            .assignNoRetain(to: \.isMainListLoading, on: self)
            .store(in: &cancellableBag)
    }

    private func setupBindings() {
        hiringManager.hiredHeroesIDsPublisher
            .map { !$0.isEmpty }
            .assignNoRetain(to: \.isSquadListFetching, on: self)
            .store(in: &cancellableBag)

        hiringManager.hiredHeroesIDsPublisher
            .removeDuplicates()
            .sink { [weak self] in self?.updateHiredHeroes(with: $0) }
            .store(in: &cancellableBag)

        errorHandler.errorSubject
            .map { $0.description }
            .assignNoRetain(to: \.errorMessage, on: self)
            .store(in: &cancellableBag)

        $errorMessage
            .delay(for: 5, scheduler: DispatchQueue.main)
            .map { _ in nil }
            .assignNoRetain(to: \.errorMessage, on: self)
            .store(in: &cancellableBag)

        errorHandler.errorSubject
            .map { _ in false }
            .assignNoRetain(to: \.isMainListLoading, on: self)
            .store(in: &cancellableBag)

        hiredListErrorHandler.errorSubject
            .map { $0.description }
            .assignNoRetain(to: \.errorMessage, on: self)
            .store(in: &cancellableBag)

        hiredListErrorHandler.errorSubject
            .map { _ in false }
            .assignNoRetain(to: \.isSquadListFetching, on: self)
            .store(in: &cancellableBag)
    }

    private func updateHiredHeroes(with newIDs: [Int]) {
        if !hiredHeroesItems.isEmpty {
            hiredHeroesItems.removeAll(where: { !newIDs.contains($0.id) })
        }
        let currentHeroesIDs = hiredHeroesItems.map { $0.id }
        let heroesToDownload = newIDs.filter { !currentHeroesIDs.contains($0) }
        guard !heroesToDownload.isEmpty else { return }
        Publishers.MergeMany(heroesToDownload.map {
            interactor.getCharacter(id: $0)
                .handleErrors(hiredListErrorHandler)
                .compactMap { $0.data.results.first }
                .map { ActionHeroItem(from: $0) }
                .eraseToAnyPublisher()
        })
        .collect()
        .combineLatest($hiredHeroesItems)
        .map { ($0.0 + $0.1).sorted() }
        .assignNoRetain(to: \.hiredHeroesItems, on: self)
        .store(in: &cancellableBag)
    }
}
