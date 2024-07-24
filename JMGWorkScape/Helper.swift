//
//  helper.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/13/24.
//
//  File where App Logic will be stored

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

func filter(){
    print("Filter")
}

func search(){
    print("search")
}

class Trie {
    // The starting node for the trie
    private let root = TrieNode()
    private var count = 0

    // This class that holds the node infromation 
    private class TrieNode {
        var children: [Character: TrieNode] = [:]
        var isEndOfWord: Bool = false
        
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
    
    func getCount() -> Int{
        return count
    }

    func insert(_ word: String) {
        var currentNode = root
        for char in word {
            currentNode = currentNode.getOrCreateChild(for: char)
        }
        currentNode.isEndOfWord = true
        count += 1
    }
    
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

    func delete(_ word: String) {
        delete(word, currentNode: root, index: 0)
    }
    
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
    
    private func collectWords(node: TrieNode, prefix: String, results: inout [String]) {
        if node.isEndOfWord {
            results.append(prefix)
        }
        for (char, childNode) in node.children {
            collectWords(node: childNode, prefix: prefix + String(char), results: &results)
        }
    }
}


// // Initialize the Trie
// let trie = Trie()

// // Insert words into the Trie
// trie.insert("apple")
// trie.insert("app")
// trie.insert("application")
// trie.insert("append")
// print(trie.wordsWithPrefix("ap"))
// trie.delete("ap")
// print("\n")
// print(trie.wordsWithPrefix("ap"))
