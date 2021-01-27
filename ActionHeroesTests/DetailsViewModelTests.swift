//
//  DetailsViewModelTests.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 24/01/2021.
//

import Combine
import XCTest

class DetailsViewModelTests: XCTestCase {

    var mockHiringManager = HiringIDsProviderMock()
    var mockModalFactory = DetailsViewModelModalFactoryMock()
    var cancellableBag = Set<AnyCancellable>()
    var viewModel: DetailsViewModel!

    override func setUp() {
        let actionHeroStub = ActionHeroItem(from: ActionHeroStub.actionHeroStub)
        viewModel = DetailsViewModel(actionHero: actionHeroStub, hiringManager: mockHiringManager, modalFactory: mockModalFactory)
    }

    func testCorrectRecruitButtonState() {
        // given I open some hero details screen
        // when hero is not recruited yet
        mockHiringManager.stubHiredIDsSubject.send([])
        // then the recruit button should be shown
        XCTAssertEqual(viewModel.recruitButtonTitle, Strings.recruitToSquad, "hero is not recruited yet")
        XCTAssertEqual(viewModel.recruitButtonStyle, RedButtonStyleConfig.primary, "hero is not recruited yet")
        // when hero is recruited already
        mockHiringManager.stubHiredIDsSubject.send([ActionHeroStub.actionHeroStub2.id,  ActionHeroStub.actionHeroStub.id])
        // then the fire button should be shown
        XCTAssertEqual(viewModel.recruitButtonTitle, Strings.fireFromSquad, "hero is recruited")
        XCTAssertEqual(viewModel.recruitButtonStyle, RedButtonStyleConfig.secondary, "hero is recruited")
    }

    func testShowModalForFiringAHero() {
        // given I open some recruited hero details screen
        let givenHero = ActionHeroStub.actionHeroStub
        mockHiringManager.stubHiredIDsSubject.send([givenHero.id])
        // when fire button is tapped
        viewModel.recruitButtonSubject.send()
        // then correct modal type should be set
        XCTAssertTrue(viewModel.isModalPresented)
        let expectation = self.expectation(description: "correct modal set")
        if case .confirm(_) = viewModel.modalType {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testFireHeroLogic() {
        // given I open some recruited hero details screen and
        // fire button was tapped, confirm modal presented
        mockHiringManager.stubHiredIDsSubject.send([ActionHeroStub.actionHeroStub2.id, ActionHeroStub.actionHeroStub.id])
        viewModel.recruitButtonSubject.send()
        XCTAssertTrue(viewModel.isModalPresented)
        let fireExpectation = expectation(description: "fire hero with correct ID")
        mockHiringManager.mockToModifyHiredIDsSubject
            .sink {
                if case .remove(let id) = $0, id == ActionHeroStub.actionHeroStub.id {
                    fireExpectation.fulfill()
                }
            }
            .store(in: &cancellableBag)
        // when modal confirm button is pressed
        mockModalFactory.modalResultSubject.send(true)
        // then correct id should be deleted
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testRecruitHeroLogic() {
        // given I open some hero details screen
        // and hero is not recruited yet
        mockHiringManager.stubHiredIDsSubject.send([ActionHeroStub.actionHeroStub2.id])
        let recruitExpectation = expectation(description: "recruit hero with correct ID")
        mockHiringManager.mockToModifyHiredIDsSubject
            .sink {
                if case .add(let id) = $0, id == ActionHeroStub.actionHeroStub.id {
                    recruitExpectation.fulfill()
                }
            }
            .store(in: &cancellableBag)
        // when recruit button was tapped
        viewModel.recruitButtonSubject.send()
        // then correct id should be added without showing modal
        XCTAssertFalse(viewModel.isModalPresented, "modal should not be shown")
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
