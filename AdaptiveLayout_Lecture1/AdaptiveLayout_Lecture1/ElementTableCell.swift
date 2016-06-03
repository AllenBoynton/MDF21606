//
//  ElementTableCell.swift
//
//  Allen Boynton
//  MDF2 1605
//  June 2, 2016
//  AdaptiveLayout

import Foundation
import UIKit

class ElementTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var m_symbol: UILabel!
    @IBOutlet weak var m_name: UILabel!
    
    
    func setupCell(symbol: String, name: String) {
        m_symbol.text = symbol;
        m_name.text = name;
    }
    
}
