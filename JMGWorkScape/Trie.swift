import Foundation
import SwiftData
import SwiftUI
import PhotosUI

/// A class that implements a Trie data structure.
/// Used for efficient string insertion, search, and prefix matching in the HomeScreen's search feature.
class Trie {
    /// The root node of the trie.
    private let root = TrieNode()
    
    /// A count of the number of words stored in the trie.
    private var count = 0

    /// A class representing a node in the Trie.
    /// Each node holds references to its child nodes and a flag indicating if it is the end of a word.
    private class TrieNode {
        /// A dictionary mapping each character to its corresponding child node.
        var children: [Character: TrieNode] = [:]
        
        /// A flag indicating whether the node marks the end of a word.
        var isEndOfWord: Bool = false
        
        /// Retrieves the child node associated with the given character, or creates it if it doesn't exist.
        /// - Parameter char: The character for which to retrieve or create a child node.
        /// - Returns: The child node associated with the given character.
        func getOrCreateChild(for char: Character) -> TrieNode {
            if let existingChild = children[char] {
                return existingChild
            } else {
                let newChild = TrieNode()
                children[char] = newChild
                return newChild
            }
        }
    }
    
    init(words: [String]) {
        for word in words{
            self.insert(word)
        }
    }
    
    // MARK: - Public Methods
    
    /// Retrieves the total count of words stored in the trie.
    /// - Returns: The number of words in the trie.
    func getCount() -> Int {
        return count
    }

    /// Inserts a word into the trie.
    /// - Parameter word: The word to insert.
    func insert(_ word: String) {
        var currentNode = root
        for char in word {
            currentNode = currentNode.getOrCreateChild(for: char)
        }
        currentNode.isEndOfWord = true
        count += 1
    }
    
    /// Searches for a word in the trie.
    /// - Parameter word: The word to search for.
    /// - Returns: `true` if the word exists in the trie, otherwise `false`.
    func search(_ word: String) -> Bool {
        var currentNode = root
        for char in word {
            guard let nextNode = currentNode.children[char] else {
                return false
            }
            currentNode = nextNode
        }
        return currentNode.isEndOfWord
    }
    
    /// Checks if there is any word in the trie that starts with the given prefix.
    /// - Parameter prefix: The prefix to search for.
    /// - Returns: `true` if there is a word in the trie that starts with the prefix, otherwise `false`.
    func startsWith(_ prefix: String) -> Bool {
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                return false
            }
            currentNode = nextNode
        }
        return true
    }

    /// Deletes a word from the trie.
    /// - Parameters:
    ///   - word: The word to delete.
    ///   - currentNode: The current node in the recursive deletion process.
    ///   - index: The current index in the word being deleted.
    /// - Returns: `true` if the current node can be deleted, otherwise `false`.
    private func delete(_ word: String, currentNode: TrieNode, index: Int) -> Bool {
        if index == word.count {
            // End of word reached
            if !currentNode.isEndOfWord {
                // Word does not exist
                return false
            }
            currentNode.isEndOfWord = false
            // If the current node has no children, it can be deleted
            let canDeleteCurrentNode = currentNode.children.isEmpty
            if canDeleteCurrentNode {
                count -= 1 // Decrement the count when a word is removed
            }
            return canDeleteCurrentNode
        }
        
        let charIndex = word.index(word.startIndex, offsetBy: index)
        let char = word[charIndex]
        
        guard let nextNode = currentNode.children[char] else {
            // Character not found, word does not exist
            return false
        }
        
        let shouldDeleteChild = delete(word, currentNode: nextNode, index: index + 1)
        
        if shouldDeleteChild {
            // Remove the reference to the child node if it can be deleted
            currentNode.children[char] = nil
            // Return true if the current node should be deleted
            return currentNode.children.isEmpty && !currentNode.isEndOfWord
        }
        
        return false
    }

    /// Finds all words in the trie that start with the given prefix.
    /// - Parameter prefix: The prefix to search for.
    /// - Returns: An array of words that start with the given prefix.
    func wordsWithPrefix(_ prefix: String) -> [String] {
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                return []
            }
            currentNode = nextNode
        }
        var results: [String] = []
        collectWords(node: currentNode, prefix: prefix, results: &results)
        return results
    }
    
    /// Recursively collects all words in the subtree rooted at the given node.
    /// - Parameters:
    ///   - node: The current node in the recursive collection process.
    ///   - prefix: The current prefix being built.
    ///   - results: The array to store the collected words.
    private func collectWords(node: TrieNode, prefix: String, results: inout [String]) {
        if node.isEndOfWord {
            results.append(prefix)
        }
        for (char, childNode) in node.children {
            collectWords(node: childNode, prefix: prefix + String(char), results: &results)
        }
    }
}

