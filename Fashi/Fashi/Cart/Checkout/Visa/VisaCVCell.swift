//
//  VisaCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol VisaCVCellDelegate: class {
    func handlePaymentMethod(_ isSelect: Bool, index: Int)
}

class VisaCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "VisaCVCell"
    private let tableView = UITableView(frame: .zero, style: .grouped)
    weak var delegate: VisaCVCellDelegate?
    
    var total: Double = 0.0
    
    lazy var names: [String] = {
        return [
            "Apple Pay",
            "Visa Ending In ",
            "Shipping"
        ]
    }()
    
    var selectName: String?
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension VisaCVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        tableView.configureTVNonSepar(.clear, ds: self, dl: self, view: contentView)
        tableView.register(VisaTVCell.self, forCellReuseIdentifier: VisaTVCell.identifier)
        tableView.register(VisaTotalTVCell.self, forCellReuseIdentifier: VisaTotalTVCell.identifier)
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

//MARK: - UITableViewDataSource

extension VisaCVCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return names.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VisaTVCell.identifier, for: indexPath) as! VisaTVCell
            cell.selectionStyle = .none
            let name = names[indexPath.row]
            cell.iconImgV.image = UIImage(named: "icon-\(name.lowercased())".replacingOccurrences(of: " ", with: ""))
            cell.titleLbl.text = name
            if indexPath.row == 1 {
                let text = cell.titleLbl.text!
                cell.titleLbl.text = text + "...4242"
            }
            
            setupCell(name, cell: cell)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VisaTotalTVCell.identifier, for: indexPath) as! VisaTotalTVCell
            cell.selectionStyle = .none
            cell.totalLbl.text = total.formattedWithCurrency
            return cell
        }
    }
    
    func setupCell(_ name: String, cell: VisaTVCell) {
        cell.checkmarkLbl.isHidden = selectName != name
    }
}

//MARK: - UITableViewDelegate

extension VisaCVCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! VisaTVCell
            touchAnim(cell, frValue: 0.8) {
                self.selectName = nil
                self.selectName = self.names[indexPath.row]
                self.tableView.reloadData()
                self.delegate?.handlePaymentMethod(true, index: indexPath.row)
            }
            
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}
