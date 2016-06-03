//
//  ViewController.swift
//
//  Allen Boynton
//  MDF2 1605
//  June 2, 2016
//  AdaptiveLayout

//  Global Identifier
let cellIdentifier = "elementCell"

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Main Outlet for tableView
    @IBOutlet weak var tableView: UITableView!
    
    // Outlets for labels and textView
    @IBOutlet weak var elementSymbol: UILabel!
    @IBOutlet weak var elementName: UILabel!
    
    @IBOutlet weak var atomicNumber: UILabel!
    @IBOutlet weak var atomicWeight: UILabel!
    @IBOutlet weak var meltingPoint: UILabel!
    @IBOutlet weak var boilingPoint: UILabel!
    @IBOutlet weak var yearDiscovered: UILabel!
    
    @IBOutlet weak var bottomTextView: UITextView!
    

    //Info Source - Wikipedia because I don't really care if it's correct.
    //Temps are in Fahrenheit
    //I realize this isn't a complete list of radioactive elements. Don't Science Me!
    let elementArray:[(symbol: String, name: String, atomicNum: Int, atomicWeight:Double, meltPoint:Double?, boilPoint:Double?, notes:String, discYear:Int )] = [
        ("Pu", "Plutonium", 94, 244, 1182.9, 5842, "Prepared by bombardment of uranium with deuterons.", 1941),
        ("U", "Uranium", 92, 238.02891, 2070, 4404, "Mistakenly identified a uranium oxide obtained from pitchblende as the element itself and named it after the recently discovered planet Uranus.", 1789),
        ("Pm", "Promethium", 61, 145, 1908, 5432, "It was probably first prepared in 1942 by bombarding neodymium and praseodymium with neutrons, but separation of the element could not be carried out. Isolation was performed under the Manhattan Project in 1945.", 1942),
        ("Rn", "Radon", 86, 222, nil, nil, "E. Dorn discovered a radioactive gas resulting from the radioactive decay of radium, isolated later by W. Ramsay and R.W. Gray.", 1898),
        ("Th", "Thorium", 90, 232.0377, 3182, 8650, "J. Berzelius obtained the oxide of a new earth in thorite.", 1829),
        ("Ra", "Radium", 88, 226, 1760, 3159, "The Curies reported on December 26, 1898, a new element different from polonium, which Marie later isolated from uraninite.", 1898),
        ("Ds", "Darmstadtium", 110, 281, nil, nil, "Prepared by bombardment of lead with nickel.", 1994),
        ("Po", "Polonium", 84, 209, 489, 1764, "In an experiment done on July 13, 1898, the Curies noted an increased radioactivity in the uranium obtained from pitchblende, which they ascribed to an unknown element.", 1898),
        ("Fr", "Francium", 87, 223, 80 , 1250, "Perey discovered it as a decay product of Ac. Francium is the last element to be discovered in nature, rather than synthesized in the lab, although some of the synthetic elements that were discovered later (plutonium, neptunium, astatine) were eventually found in trace amounts in nature as well.", 1939),
        ("Ac", "Actinum", 89, 227, 2240, 5800, "A.L. Debierne obtained from pitchblende a substance that had properties similar to those of thorium.", 1899),
        ("Cm", "Curium", 96, 247, 2444, 5630, "Prepared by bombarding plutonium with alpha particles during the Manhattan Project", 1944),
        ("Es", "Einsteinium", 99, 252, 1580, 1825, "Formed in the first thermonuclear explosion in November 1952, by irradiation of uranium with neutrons; kept secret for several years.", 1952)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table view delegate
        tableView.delegate = self
        
        //  Turn on auto cell dimentions
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //  Esitmated row height
        tableView.estimatedRowHeight = 120
    }
    
    //  Informs tableView how many cells will be populating in the prototype
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementArray.count
    }
    
    //  Populates tableViewCells with data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ElementTableViewCell
        let currentElement = elementArray[indexPath.row]
        cell.setupCell(currentElement.symbol, name: currentElement.name)
        
        return cell
    }
    
    //  Creates the connection to the tableViewCell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentElement = elementArray[indexPath.row]
        
        elementSymbol.text = currentElement.symbol
        elementName.text = currentElement.name
        
        atomicNumber.text = String(currentElement.atomicNum)
        atomicWeight.text = String(currentElement.atomicWeight)
        
        // If statement solves problem of value being nil optional binding
        if let melt = currentElement.meltPoint, boil = currentElement.boilPoint {
            meltingPoint.text = "\(melt) F°"
            boilingPoint.text = "\(boil) F°"
        }
        else {
            meltingPoint.text = "N/A"
            boilingPoint.text = "N/A"
        }
        
        yearDiscovered.text = String(currentElement.discYear)
        
        bottomTextView.text = currentElement.notes
    }
}

