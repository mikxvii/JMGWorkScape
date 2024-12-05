import Foundation

/// Manages a collection of houses and supports operations such as adding, removing,
/// updating, and searching for houses based on their names or addresses.
/// Utilizes a Trie data structure for efficient prefix-based searches.
final class HouseSearchManager {
    
    /// A dictionary mapping house names to another dictionary that maps addresses to `House` objects.
    /// This allows for efficient retrieval and management of houses based on both name and address.
    private var houses: [String: [String: House]] = [:]
    
    /// The root node of the Trie used for storing house names to support prefix-based searches.
    private let root = TrieNode()
    
    /// The total number of houses managed by this manager.
    private var count = 0
    
    /// A set that stores all unique addresses to facilitate quick lookups and ensure address uniqueness.
    private var addresses: Set<String> = []
    
    /// Inserts a word (house name) into the Trie.
    /// - Parameter word: The house name to be inserted into the Trie.
    private func insert(_ word: String) {
        var currentNode = root
        for char in word {
            currentNode = currentNode.getOrCreateChild(for: char)
        }
        currentNode.isEndOfWord = true
        count += 1
    }
    
    /// Deletes a word from the trie.
    /// - Parameters:
    ///   - word: The word to delete.
    ///   - currentNode: The current node in the recursive deletion process.
    ///   - index: The current index in the word being deleted.
    /// - Returns: `true` if the current node can be deleted, otherwise `false`.
    private func removeFromTrie(_ word: String, currentNode: TrieNode, index: Int) -> Bool {
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
        
        let shouldDeleteChild = removeFromTrie(word, currentNode: nextNode, index: index + 1)
        
        if shouldDeleteChild {
            // Remove the reference to the child node if it can be deleted
            currentNode.children[char] = nil
            // Return true if the current node should be deleted
            return currentNode.children.isEmpty && !currentNode.isEndOfWord
        }
        
        return false
    }

    
    /// Collects all words in the Trie that have the given prefix.
    /// - Parameters:
    ///   - node: The current TrieNode to start collecting words from.
    ///   - prefix: The prefix that words should start with.
    ///   - results: An array to store the collected words.
    private func collectWords(node: TrieNode, prefix: String, results: inout [String]) {
        if node.isEndOfWord {
            results.append(prefix)
        }
        for (char, childNode) in node.children {
            collectWords(node: childNode, prefix: prefix + String(char), results: &results)
        }
    }
    
    /// A class representing a node in the Trie.
    /// Each node holds references to its child nodes and a flag indicating if it marks the end of a word.
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
    
    /// Initializes the manager with an array of houses.
    /// Each house is added to the dictionary and Trie, and its address is added to the addresses set.
    /// - Parameter housesArray: An array of `House` objects to initialize the manager with.
    init(_ housesArray: [House]) {
        for house in housesArray {
            if houses[house.getName()] == nil {
                houses[house.getName()] = [house.getAddress(): house]
            } else {
                if var innerDict = houses[house.getName()] {
                    innerDict[house.getAddress()] = house
                    houses[house.getName()] = innerDict
                } else {
                    houses[house.getName()] = [house.getAddress(): house]
                }
            }
            
            count += 1
            addresses.insert(house.getAddress())
            self.insert(house.getName())
        }
    }
    
    /// Retrieves an array of `House` objects for the specified house name.
    /// This overloads the [] operator
    /// - Parameter houseName: The name of the house to retrieve.
    /// - Returns: An array of `House` objects that match the provided name, or an empty array if no matches are found.
    subscript(houseName: String) -> [House]? {
        if let housesDict = houses[houseName] {
            return Array(housesDict.values)
        } else {
            return []  // Return an empty array if `houses[houseName]` is `nil`
        }
    }
    
    /// Retrieves all houses whose names start with the specified prefix.
    /// - Parameter prefix: The prefix to search for in house names.
    /// - Returns: An array of `House` objects whose names start with the given prefix.
    func houseNamesWithPrefix(_ prefix: String) -> [House] {
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                return []
            }
            currentNode = nextNode
        }
        var results: [String] = []
        collectWords(node: currentNode, prefix: prefix, results: &results)
        return getHouses(results) ?? []
    }
    
    /// Retrieves an array of `House` objects based on a list of house names.
    /// - Parameter houseNameList: An array of house names to search for.
    /// - Returns: An array of `House` objects that match the provided names, or `nil` if no matches are found.
    func getHouses(_ houseNameList: [String]) -> [House]? {
        var housesToReturn: [House] = []
        
        for name in houseNameList {
            if let housesFromName = houses[name] {
                housesToReturn.append(contentsOf: Array(housesFromName.values))
            }
        }
        
        return housesToReturn
    }
    
    /// Checks if a house with the given address already exists in the dictionary.
    /// - Parameter houseAddress: The address of the house to check.
    /// - Returns: `True` if a house with the given address exists, `False` otherwise.
    func alreadyExists(_ houseAddress: String) -> Bool {
        return addresses.contains(houseAddress)
    }
    
    /// Removes a `House` object from the dictionary.
    /// - Parameter house: The `House` object to remove.
    func remove(_ house: House) {
        houses[house.getName()]?.removeValue(forKey: house.getAddress())
        addresses.remove(house.getAddress())
        self.removeFromTrie(house.getName(), currentNode: self.root, index: 0)
        count -= 1
    }
    
    /// Updates the address of a `House` object in the dictionary.
    /// - Parameters:
    ///   - house: The `House` object to update.
    ///   - newAddress: The new address for the house.
    func changeAddress(_ house: House, _ newAddress: String) {
        let houseName = house.getName()
        let currentAddress = house.getAddress()

        // Check if the house exists in the dictionary under the current address
        if var housesByAddress = houses[houseName], let houseToUpdate = housesByAddress[currentAddress] {
            
            // Remove the house from the current address in the dictionary
            housesByAddress.removeValue(forKey: currentAddress)
            addresses.remove(currentAddress)

            // Update the house's address (Assuming House has a method or property to change the address)
            houseToUpdate.update(newAddress) // Implement this method in the House class
            
            // Insert the house into the dictionary under the new address
            housesByAddress[newAddress] = houseToUpdate
            houses[houseName] = housesByAddress
            
            // Add the new address to the addresses set
            addresses.insert(newAddress)
        }
    }
    
    /// Retrieves the total number of houses managed by this manager.
    /// - Returns: The total count of houses.
    func getCount() -> Int {
        return self.count
    }
}
