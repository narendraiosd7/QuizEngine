//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by UW-IN-LPT0108 on 11/24/21.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    let router = RouterSpy()
    
    func testStartWithNoQuestionsDoesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func testStartWithOneQuestionsRoutesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartWithOneQuestionsRoutesToCorrectQuestion2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func testStartWithTwoQuestionsRoutesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartTwiseWithTwoQuestionsRoutesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerFirstSecondQuestionWithThreeQuestionsRoutesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerFirstQuestionWithOneQuestionDoesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        router.answerCallBack("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartWithNoQuestionsDoesNotRouteToResults() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResults!, [:])
    }
    
    func testStartWithOneQuestionsDoesNotRouteToResults() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResults)
    }
    
    func testStartAndAnswerFirstQuestionWithTwoQuestionsDoesNotRouteToResults() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallBack("A1")
        
        XCTAssertNil(router.routedResults)
    }
    
    func testStartAndAnswerFirstAndSecondQuestionWithTwoQuestionsRouteToResults() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        
        XCTAssertEqual(router.routedResults!, ["Q1": "A1", "Q2": "A2"])
    }
    
    
    //MARK: - Helpers
    
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        
        var routedQuestions: [String] = []
        var routedResults: [String: String]? = nil
        
        var answerCallBack: Router.AnswerCallBack = {_ in}
        
        func routeTo(question: String, answerCallBack: @escaping Router.AnswerCallBack) {
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
        
        func route(result: [String : String]) {
            routedResults = result
        }
    }
}
