import Foundation
import UIKit

class DittoStore : NSObject {
    
    let defaults = NSUserDefaults(suiteName: "group.io.kern.ditto")!
    
    let presetDittos =
        [   "Instructions" :
            [   "Welcome to Ditto. 👋",
                "Add Ditto in Settings > General > Keyboard > Keyboards.",
                "You must Allow Full Access for Ditto to work properly.",
                "We DO NOT access ANYTHING that you type on the Ditto keyboard.",
                "Everything is saved privately on your device",
                "Use the Ditto app to customize your Dittos.",
                "\n\n\n\nA very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito.A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito.A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito. A very long dito."
            ],
            
            "Driving" :
                [
                    "Can't talk, I'm driving.",
                    "Can you send me the address?",
                    "I'll be there in ___ minutes!"
            ],
            "Business" :
                [   "Hi ___,\n\nIt was great meeting you today. I'd love to chat in more detail about possible business opportinities. Please let me know your avilability.\n\nBest,\nAsaf",
                    "My name is Asaf. I'm a recruiter at Shmoogle on the search team. We are always looking for talented candidates to join our team, and with your impressive background, we think you could be a great fit. Please let me know if you are interested, and if so, your availability to chat this week."
            ],
            "Tinder" :
                [
                    "Was your dad a thief? Because someone stole the stars from teh sky and put them in your eyes.",
                    "I'm not a photographer, but I can picture as together.",
                    "Do you have a Band-Aid? Because I just scraped my knee falling for you."
                    
            ]
            
        ]
    
    let presetCategories = ["Instructions", "Driving", "Business", "Tinder"]
    
    var cachedDittos: [String: [String]] = [String:[String]]()
    var cachedCategories: [String] = []
    
    override init() {
        super.init()
        reload()
    }
    
    func reload() {
        defaults.synchronize()
        if let dittos = defaults.dictionaryForKey("dittos") as? [String:[String]] {
            if let categories = defaults.arrayForKey("categories") as? [String]{
                cachedDittos = dittos
                cachedCategories = categories
            }
        } else {
            cachedDittos = presetDittos
            cachedCategories = presetCategories
        }
    }
    
    func save() {
        defaults.setObject(cachedDittos, forKey: "dittos")
        defaults.setObject(cachedCategories, forKey: "categories")
        defaults.synchronize()
    }
    
    func get(categoryIndex: Int, dittoIndex : Int) -> String {
        let category: String = cachedCategories[categoryIndex]
        let dittos: [String] = cachedDittos[category]!
        return dittos[dittoIndex]
    }
    
    func getDittosByCategory(categoryIndex: Int) -> [String] {
        let category: String = cachedCategories[categoryIndex]
        return cachedDittos[category]!
    }
    
    func getCategory(categoryIndex: Int) -> String {
        return cachedCategories[categoryIndex]
    }
    
    func count(categoryIndex: Int) -> Int {
        let category: String = cachedCategories[categoryIndex]
        let dittos: [String] = cachedDittos[category]!
        return dittos.count
    }
    
    func numCategories() -> Int {
        return cachedCategories.count
    }
    
    func add(categoryIndex : Int, ditto : String) {
        let category = cachedCategories[categoryIndex]
        cachedDittos[category]!.append(ditto)
        save()
    }
    
    func set(categoryIndex: Int, dittoIndex : Int, ditto : String) {
        let category = cachedCategories[categoryIndex]
        cachedDittos[category]![dittoIndex] = ditto
        save()
    }
    
    func move(fromCategoryIndex : Int, fromDittoIndex : Int, toCatogryIndex : Int, toDittoIndex : Int) {
        let fromCategory = cachedCategories[fromCategoryIndex]
        let toCategory = cachedCategories[toCatogryIndex]
        let ditto = cachedDittos[fromCategory]![fromDittoIndex]
        cachedDittos[fromCategory]!.removeAtIndex(fromDittoIndex)
        cachedDittos[toCategory]!.insert(ditto, atIndex: toDittoIndex)
        save()
    }
    
    func remove(categoryIndex: Int, dittoIndex : Int) {
        let category = cachedCategories[categoryIndex]
        cachedDittos[category]!.removeAtIndex(dittoIndex)
        save()
    }
    
    func removeCategory(categoryIndex: Int) {
        cachedCategories.removeAtIndex(categoryIndex)
        save()
    }
    
    func getColorForIndex(index: Int) -> UIColor {
        return UIColor(red: 153/255, green: 0, blue: 153/255, alpha: 1 - ((4 / (4 * CGFloat(self.numCategories()))) * CGFloat(index)))
    }
    
    
    
}