//
//  Publishers.swift
//  YouPlay
//
//  Created by Sebastian on 3/31/24.
//

import Combine
import Foundation
import SwiftUI

extension Publishers {
    static var keyboardHeight: KeyboardHeightPublisher {
        return KeyboardHeightPublisher()
    }
}

struct KeyboardHeightPublisher: Publisher {
    typealias Output = CGFloat
    typealias Failure = Never

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = KeyboardHeightSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private final class KeyboardHeightSubscription<S: Subscriber>: Subscription where S.Input == CGFloat, S.Failure == Never {
    private var subscriber: S?
    private var keyboardWillShowObserver: Any?
    private var keyboardWillHideObserver: Any?

    init(subscriber: S) {
        self.subscriber = subscriber

        let keyboardWillShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }

        self.keyboardWillShowObserver = keyboardWillShow.sink { height in
            _ = subscriber.receive(height)
        }

        self.keyboardWillHideObserver = keyboardWillHide.sink { height in
            _ = subscriber.receive(height)
        }
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
        if let observer = keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
