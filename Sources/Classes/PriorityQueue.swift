//
//  PriorityQueue.swift
//  S2Geometry
//
//  Created by Ian Keen on 2025-10-31.
//

struct PriorityQueue {
	private var heap: [S2RegionCoverer.QueueEntry] = []

	var isEmpty: Bool {
		return heap.isEmpty
	}

	var count: Int {
		return heap.count
	}

	mutating func removeAll() {
		heap.removeAll()
	}

	/// Reserve capacity for better performance (reduces reallocations)
	mutating func reserveCapacity(_ capacity: Int) {
		heap.reserveCapacity(capacity)
	}

	/// Insert a new entry into the priority queue - O(log N)
	mutating func insert(_ entry: S2RegionCoverer.QueueEntry) {
		heap.append(entry)
		heapifyUp(heap.count - 1)
	}

	/// Extract the maximum priority entry - O(log N)
	mutating func extractMax() -> S2RegionCoverer.QueueEntry? {
		guard !heap.isEmpty else { return nil }

		if heap.count == 1 {
			return heap.removeLast()
		}

		let max = heap[0]
		heap[0] = heap[heap.count - 1]
		heap.removeLast()
		heapifyDown(0)
		return max
	}

	/// Restore heap property upward (for insert)
	private mutating func heapifyUp(_ index: Int) {
		var currentIndex = index

		while currentIndex > 0 {
			let parentIndex = (currentIndex - 1) / 2

			// Use < for max heap (smaller id = higher priority)
			if heap[currentIndex].id >= heap[parentIndex].id {
				break
			}

			heap.swapAt(currentIndex, parentIndex)
			currentIndex = parentIndex
		}
	}

	/// Restore heap property downward (for extract)
	private mutating func heapifyDown(_ index: Int) {
		var currentIndex = index

		while true {
			let leftChild = 2 * currentIndex + 1
			let rightChild = 2 * currentIndex + 2
			var maxIndex = currentIndex

			if leftChild < heap.count && heap[leftChild].id < heap[maxIndex].id {
				maxIndex = leftChild
			}
			if rightChild < heap.count && heap[rightChild].id < heap[maxIndex].id {
				maxIndex = rightChild
			}

			if maxIndex == currentIndex { break }

			heap.swapAt(currentIndex, maxIndex)
			currentIndex = maxIndex
		}
	}
}
