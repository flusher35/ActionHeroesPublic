//
//  MainViewModelTests.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 23/01/2021.
//

import Combine
import XCTest

class MainViewModelTests: XCTestCase {

    var mockInteractor = MarvelInteractorMock()
    var mockHiringManager = HiringIDsProviderMock()
    var cancellableBag = Set<AnyCancellable>()

    func testGettingCharacters() {
        // given I open main screen and list loading starts
        let listingConfig = MainViewListingConfig(itemLoadThreshold: 30, itemLimit: 60)
        let heroes = ActionHeroStub.createRandomHeroes(listingConfig.itemLimit)
        mockInteractor.stubCharacters = heroes
        let viewModel = MainViewModel(listingConfig: listingConfig, interactor: mockInteractor)
        // list loading should stop
        let expectation = self.expectation(description: #function)
        let expectedLoadingSequence: [Bool] = [true, false]
        viewModel.$isMainListLoading
            .collect(2)
            .sink {
                XCTAssertEqual($0, expectedLoadingSequence)
                expectation.fulfill()
            }
            .store(in: &cancellableBag)
        waitForExpectations(timeout: 1, handler: nil)
        // then correct amount of items should be shown
        XCTAssertEqual(heroes.count, viewModel.actionHeroItems.count, #function)
    }

    func testPaginationLogic() {
        // given I open main screen and list loading starts
        let listingConfig = MainViewListingConfig(itemLoadThreshold: 30, itemLimit: 60)
        let heroes = ActionHeroStub.createRandomHeroes(listingConfig.itemLimit)
        mockInteractor.stubCharacters = heroes
        let viewModel = MainViewModel(listingConfig: listingConfig, interactor: mockInteractor)
        // list loading should stop
        let expectation = self.expectation(description: #function)
        viewModel.$isMainListLoading
            .collect(2)
            .delay(for: 0, scheduler: DispatchQueue.main)
            .sink { _ in
                XCTAssertFalse(viewModel.actionHeroItems.isEmpty)
                self.mockInteractor.getCharactersGotCalled = { _ in
                    XCTFail("should not make any request when triggering below threshold")
                }
                viewModel.itemAppeared(viewModel.actionHeroItems[listingConfig.itemLoadThreshold - 1])
                self.mockInteractor.getCharactersGotCalled = { offset in
                    if offset == listingConfig.itemLimit {
                        expectation.fulfill()
                    }
                }
                viewModel.itemAppeared(viewModel.actionHeroItems[listingConfig.itemLoadThreshold])
            }
            .store(in: &cancellableBag)
        // then next page of items with correct offset should be triggered for loading
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testItemTapNavigation() {
        // given I open main screen with loaded items
        let viewModel = MainViewModel(interactor: mockInteractor)
        // list loading should stop
        let expectation = self.expectation(description: #function)
        viewModel.$isMainListLoading
            .collect(2)
            .delay(for: 0, scheduler: DispatchQueue.main)
            .sink { _ in
                XCTAssertFalse(viewModel.actionHeroItems.isEmpty)

                let expectedHero = viewModel.actionHeroItems[5]

                viewModel.navigation
                    .sink {
                        if case .showDetails(let tappedHero) = $0,
                           expectedHero == tappedHero {
                            expectation.fulfill()
                        }
                    }
                    .store(in: &self.cancellableBag)
                // when I tap on action hero at index 5
                viewModel.itemTapped(expectedHero)
            }
            .store(in: &cancellableBag)
        // then correct item is send further to navigate
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHiredOneHero() {
        // given I open main screen with empty hired heroes
        let listingConfig = MainViewListingConfig(itemLoadThreshold: 30, itemLimit: 60)
        let heroes = ActionHeroStub.createRandomHeroes(listingConfig.itemLimit)
        mockInteractor.stubCharactersForSingleRequests = heroes
        let viewModel = MainViewModel(listingConfig: listingConfig, interactor: mockInteractor, hiringManager: mockHiringManager)

        let expectedHero = ActionHeroItem(from: heroes.first!)
        let expectation = self.expectation(description: #function)

        viewModel.$hiredHeroesItems
            .dropFirst()
            .sink {
                XCTAssertEqual($0.count, 1)
                if $0.first == expectedHero {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellableBag)
        // when I hire a hero through details view logic
        mockHiringManager.stubHiredIDsSubject.send([expectedHero.id])
        // then correct hero has been fetched and shown in hired section
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemovingHeroFromHired() {
        // given I open main screen with two hired heroes
        let listingConfig = MainViewListingConfig(itemLoadThreshold: 30, itemLimit: 60)
        let heroes = ActionHeroStub.createRandomHeroes(listingConfig.itemLimit)
        mockInteractor.stubCharactersForSingleRequests = heroes
        let viewModel = MainViewModel(listingConfig: listingConfig, interactor: mockInteractor, hiringManager: mockHiringManager)
        mockInteractor.getCharactersGotCalled = { _ in
            XCTFail("should not download any new heroes")
        }
        var stub = Array(heroes.prefix(2)).map { ActionHeroItem(from: $0) }
        viewModel.hiredHeroesItems = stub
        stub.removeFirst()
        // when I fire a one hero through details view logic
        mockHiringManager.stubHiredIDsSubject.send(stub.map { $0.id })
        let expectation = self.expectation(description: #function)
        viewModel.$hiredHeroesItems
            .sink {
                if $0 == stub {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellableBag)
        // then fired hero should be removed without re-downloading the rest
        waitForExpectations(timeout: 1, handler: nil)
    }
}
