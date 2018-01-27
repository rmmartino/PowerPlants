//
//  PlantTableViewCell.swift
//  PowerPlants
//


import UIKit

class PlantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var plantTypeLabel: UILabel!
    @IBOutlet weak var happyPlantImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    
}
