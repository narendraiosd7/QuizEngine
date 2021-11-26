//
//  Flow.swift
//  QuizEngine
//
//  Created by UW-IN-LPT0108 on 11/24/21.
//

import Foundation

protocol Router {
    typealias AnswerCallBack = (String) -> Void
    func routeTo(question: String, answerCallBack: @escaping AnswerCallBack)
    func route(result: [String: String])
}

class Flow {
    
    private let router: Router
    private let questions: [String]
    
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: nextCallBack(from: firstQuestion))
        } else {
            router.route(result: result)
        }
    }
    
    private func nextCallBack(from question: String) -> Router.AnswerCallBack {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentIndex = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallBack: nextCallBack(from: nextQuestion))
            } else {
                router.route(result: result)
            }
        }
    }
}
