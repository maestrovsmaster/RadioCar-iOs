//
//  NSManagedObjectContext.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
import CoreData
import Combine

extension NSManagedObjectContext {

    func publisher<T: NSFetchRequestResult>(for fetchRequest: NSFetchRequest<T>) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)

        let delegate = FetchedResultsControllerDelegate(subject: subject)
        controller.delegate = delegate

        do {
            try controller.performFetch()
            subject.send(controller.fetchedObjects ?? [])
        } catch {
            subject.send(completion: .failure(error))
        }

        return subject.handleEvents(receiveCancel: {
            controller.delegate = nil
        }).eraseToAnyPublisher()
    }
}

class FetchedResultsControllerDelegate<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    private let subject: PassthroughSubject<[T], Error>

    init(subject: PassthroughSubject<[T], Error>) {
        self.subject = subject
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let objects = controller.fetchedObjects as? [T] else { return }
        subject.send(objects)
    }
}

