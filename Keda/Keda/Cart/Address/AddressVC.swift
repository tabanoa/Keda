//
//  AddressVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

protocol AddressVCDelegate: class {
    func handlePopVC(vc: AddressVC)
}

class AddressVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: AddressVCDelegate?
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private let firstNameLbl = UILabel()
    private let firstNameTF = CustomizedTF()
    
    private let lastNameLbl = UILabel()
    private let lastNameTF = CustomizedTF()
    
    private let addressLine1Lbl = UILabel()
    private let addressLine1TF = CustomizedTF()
    
    private let addressLine2Lbl = UILabel()
    private let addressLine2TF = CustomizedTF()
    
    private let countryView = UIView()
    private let countryIcon = UIImageView()
    private let countryBtn = UIButton()
    private let countryLbl = UILabel()
    private let countryContentLbl = UILabel()
    
    private var stateView: UIView?
    private let stateIcon = UIImageView()
    private let stateBtn = UIButton()
    private let stateLbl = UILabel()
    private var stateTF: CustomizedTF?
    private let stateContentLbl = UILabel()
    
    private var cityView: UIView?
    private let cityIcon = UIImageView()
    private let cityBtn = UIButton()
    private let cityLbl = UILabel()
    private var cityTF: CustomizedTF?
    private let cityContentLbl = UILabel()
    
    private let zipcodeLbl = UILabel()
    private let zipcodeTF = CustomizedTF()
    
    private let phoneNumberLbl = UILabel()
    private let phoneNumberTF = CustomizedTF()
    
    private let addNewAddBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    private let backBtn = UIButton()
    
    private var popUpView = PopUpView()
    private let containerView = UIView()
    private let popUpTV = UITableView(frame: .zero, style: .grouped)
    
    private var countries: [String] = []
    private var states: [String] = []
    private var cities: [String] = []
    
    private let caTxt = "Canada"
    private var isCanada = true
    
    var firstNameTxt = ""
    var lastNameTxt = ""
    var addressLine1Txt = ""
    var addressLine2Txt = ""
    var countryTxt = ""
    var stateTxt = ""
    var cityTxt = ""
    var zipcodeTxt = ""
    var phoneNumberTxt = ""
    
    var titleNavi = ""
    var addNewAddrTxt = ""
    var popUpTxt = ""
    var isEdit = false
    
    var address: Address?
    lazy var addresses: [Address] = []
    var cell: ShippingToTVCell!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCancel), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAdress()
        fetchCountriesData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchStatesData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        isEdit = false
    }
}

//MARK: - Configures
extension AddressVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = titleNavi
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVNonSepar(ds: self, dl: self, view: view)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddressTVCell")
        tableView.rowHeight = 96.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func endEditing() {
        tableView.endEditing(true)
    }
}

//MARK: - Functions
extension AddressVC {
    
    func fetchCountriesData() {
        countries.removeAll()
        DispatchQueue.main.async {
            guard let path = Bundle.main.path(forResource: "countries.json", ofType: nil)
                else { return }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let array = result as? NSArray {
                    for dict in array {
                        if let dict = dict as? [String : Any] {
                            if let country = dict["name"] as? String {
                                if !self.countries.contains(country) {
                                    self.countries.append(country)
                                }
                            }
                        }
                    }
                }
                
            } catch let error as NSError { print("Load country error: \(error.localizedDescription)") }
        }
    }
    
    
    func fetchStatesData() { //Canada
        states.removeAll()
//        cities.removeAll()
        DispatchQueue.main.async {
            guard let path = Bundle.main.path(forResource: "provinces.json", ofType: nil)
                else { return }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let array = result as? NSArray {
                    for dict in array {
                        if let dict = dict as? [String : Any] {
                            if let province = dict["name"] as? String {
                                if !self.states.contains(province) {
                                    self.states.append(province)
                                }
                            }
                        }
                    }
                }
                
            } catch let error as NSError { print("Load province error: \(error.localizedDescription)") }
        }
    }
    
    func fetchCitiesData() { //Canada
        cities.removeAll()
        DispatchQueue.main.async {
            guard let path = Bundle.main.path(forResource: "cities.json", ofType: nil)
                else { return }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let array = result as? NSArray {
                    for dict in array {
                        if let dict = dict as? [String : Any] {
                            if let cities = dict["name"] as? String {
                                if !self.cities.contains(cities) {
                                    self.cities.append(cities)
                                }
                            }
                        }
                    }
                }
                
            } catch let error as NSError { print("Load cities error: \(error.localizedDescription)") }
        }
    }
    

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
            navigationController?.popViewController(animated: true)
        case .changed:
            if let interractiveTransition = interactiveTransition {
                interractiveTransition.update(progress)
            }
            
            shouldFinish = progress > percentThreshold
        case .cancelled, .failed:
            interactiveTransition.cancel()
        case .ended:
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = .zero
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    func fetchAdress() {
        if let address = address {
            firstNameTxt = address.firstName
            lastNameTxt = address.lastName
            addressLine1Txt = address.addrLine1
            addressLine2Txt = address.addrLine2 ?? ""
            countryTxt = address.country
            stateTxt = address.state
            cityTxt = address.city
            zipcodeTxt = address.zipcode
            phoneNumberTxt = address.phoneNumber
        }
    }
}

//MARK: - UITableViewDataSource
extension AddressVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 6 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath)
        cell.selectionStyle = .none
        
        if section == 0 {
            switch row {
            case 0:
                let fnTxt = NSLocalizedString("First Name", comment: "AddressVC.swift: First Name")
                let lnTxt = NSLocalizedString("Last Name", comment: "AddressVC.swift: Last Name")
                
                setupLeftRightTF(firstNameTF, lastNameTF, lTxt: firstNameTxt, rTxt: lastNameTxt, cell: cell)
                setupLeftRightLbl(firstNameLbl, lastNameLbl, leftTxt: fnTxt, rightTxt: lnTxt, leftTF: firstNameTF, rightTF: lastNameTF, cell: cell)
                firstNameTF.delegate = self
                lastNameTF.delegate = self
                firstNameTF.addTarget(self, action: #selector(firstNameChanged(tf:)), for: .editingChanged)
                lastNameTF.addTarget(self, action: #selector(firstNameChanged(tf:)), for: .editingChanged)
            case 1:
                let txt = NSLocalizedString("Address Line 1", comment: "AddressVC.swift: Address Line 1")
                
                setupFullTF(addressLine1TF, txt: addressLine1Txt, cell: cell)
                setupLabel(addressLine1Lbl, txt: txt, tf: addressLine1TF, cell: cell)
                addressLine1TF.delegate = self
            case 2:
                let txt = NSLocalizedString("Address Line 2", comment: "AddressVC.swift: Address Line 2")
                let placeholder = NSLocalizedString("Optional", comment: "AddressVC.swift: Optional")
                
                setupFullTF(addressLine2TF, txt: addressLine2Txt, cell: cell)
                setupLabel(addressLine2Lbl, txt: txt, tf: addressLine2TF, cell: cell)
                addressLine2TF.placeholder = placeholder
                addressLine2TF.delegate = self
            case 3:
                let lTxt = NSLocalizedString("Country/Region", comment: "AddressVC.swift: Country/Region")
                
                setupLeftView(countryView, cell: cell)
                setupLeftLbl(countryLbl, leftTxt: lTxt, leftV: countryView, cell: cell)
                setupContentLbl(countryContentLbl, txt: countryTxt, view: countryView)
                setupImgView(countryIcon, view: countryView)
                setupBtn(countryBtn, selector: #selector(countryDidTap), imgV: countryIcon, view: countryView)
                
                var rTxt = NSLocalizedString("State", comment: "AddressVC.swift: State")
                let isState = rTxt == "Provinces" ? true : false
                if isCanada {
                    rTxt = isState ? "Provinces" : "State" //province 2
                    stateView = UIView()
                    setupRightView(stateView!, cell: cell)
                    setupRightLbl(stateLbl, rightTxt: rTxt, rightV: stateView!, cell: cell)
                    setupContentLbl(stateContentLbl, txt: stateTxt, view: stateView!)
                    setupImgView(stateIcon, view: stateView!)
                    setupBtn(stateBtn, selector: #selector(stateDidTap), imgV: stateIcon, view: stateView!)
                    
                } else {
                    rTxt = isState ? "Provinces" : "State"
                    stateTF = CustomizedTF()
                    setupRightTF(stateTF!, txt: stateTxt, cell: cell)
                    setupRightLbl(stateLbl, rightTxt: rTxt, rightV: stateTF!, cell: cell)
                    stateTF!.delegate = self
                }
            case 4:
                let lTxt = NSLocalizedString("City", comment: "AddressVC.swift: City")
                let rTxt = "Zipcode"
                
                if isCanada {
                    cityView = UIView()
                    setupLeftView(cityView!, cell: cell)
                    setupLeftLbl(cityLbl, leftTxt: lTxt, leftV: cityView!, cell: cell)
                    setupContentLbl(cityContentLbl, txt: cityTxt, view: cityView!)
                    setupImgView(cityIcon, view: cityView!)
                    setupBtn(cityBtn, selector: #selector(cityDidTap), imgV: cityIcon, view: cityView!)
                    
                } else {
                    cityTF = CustomizedTF()
                    setupLeftTF(cityTF!, txt: cityTxt, cell: cell)
                    setupLeftLbl(cityLbl, leftTxt: lTxt, leftV: cityTF!, cell: cell)
                    cityTF!.delegate = self
                }
                
                setupRightTF(zipcodeTF, txt: zipcodeTxt, cell: cell)
                setupRightLbl(zipcodeLbl, rightTxt: rTxt, rightV: zipcodeTF, cell: cell)
                zipcodeTF.delegate = self
                zipcodeTF.keyboardType = .default
            default:
                let txt = NSLocalizedString("Phone Number", comment: "AddressVC.swift: Phone Number")
                setupFullTF(phoneNumberTF, txt: phoneNumberTxt, cell: cell)
                setupLabel(phoneNumberLbl, txt: txt, tf: phoneNumberTF, cell: cell)
                phoneNumberTF.delegate = self
                phoneNumberTF.keyboardType = .numberPad
            }
            
        } else {
            setupAddNewAddBtn(addNewAddBtn, cell: cell)
        }
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupTraitCollection()
            case .dark: setupTraitCollection(true)
            default: break
            }
        } else {
            setupTraitCollection()
        }
        
        return cell
    }
    
    @objc func countryDidTap() {
        let txt = NSLocalizedString("Select Country", comment: "AddressVC.swift: Select Country")
        popUpView = PopUpView(frame: kWindow!.bounds)
        popUpView.delegate = self
        popUpView.countries = countries
        popUpView.naviTitle = txt
        popUpView.country = countryTxt
        kWindow!.addSubview(popUpView)
        popUpView.setupUI(containerView)
        popUpView.setupTV(containerView, popUpTV)
        darkModePopUpView()
    }
    
    @objc func stateDidTap() {
        let txt = NSLocalizedString("Select State", comment: "AddressVC.swift: Select State")
        popUpView = PopUpView(frame: kWindow!.bounds)
        popUpView.delegate = self
        popUpView.states = states
        popUpView.naviTitle = txt
        popUpView.state = stateTxt
        kWindow!.addSubview(popUpView)
        popUpView.setupUI(containerView)
        popUpView.setupTV(containerView, popUpTV)
        darkModePopUpView()
    }
    
    @objc func cityDidTap() {
        if stateTxt.isEmpty {
            setupAnimBorderView(cityView!)
            
        } else {
            let txt = NSLocalizedString("Select City", comment: "AddressVC.swift: Select City")
            popUpView = PopUpView(frame: kWindow!.bounds)
            popUpView.delegate = self
            popUpView.cities = cities
            popUpView.naviTitle = txt
            popUpView.city = cityTxt
            kWindow!.addSubview(popUpView)
            popUpView.setupUI(containerView)
            popUpView.setupTV(containerView, popUpTV)
            borderView(cityView!, color: .lightGray)
            darkModePopUpView()
        }
    }
    
    func darkModePopUpView() {
        popUpView.setupDarkMode()
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMPopUpView()
            case .dark: setupDMPopUpView(true)
            default: break
            }
        } else {
            setupDMPopUpView()
        }
    }
    
    private func setupDMPopUpView(_ isDarkMode: Bool = false) {
        containerView.backgroundColor = isDarkMode ? .black : .white
        popUpTV.backgroundColor = isDarkMode ? .black : .white
    }
    
    func setupLeftRightLbl(_ leftLbl: UILabel, _ rightLbl: UILabel, leftTxt: String, rightTxt: String, leftTF: UITextField, rightTF: UITextField, cell: UITableViewCell) {
        setupLeftLbl(leftLbl, leftTxt: leftTxt, leftV: leftTF, cell: cell)
        setupRightLbl(rightLbl, rightTxt: rightTxt, rightV: rightTF, cell: cell)
    }
    
    func setupLeftLbl(_ leftLbl: UILabel, leftTxt: String, leftV: UIView, cell: UITableViewCell) {
        setupLbl(leftLbl, txt: leftTxt, cell: cell)
        
        NSLayoutConstraint.activate([
            leftLbl.bottomAnchor.constraint(equalTo: leftV.topAnchor, constant: -8.0),
            leftLbl.leadingAnchor.constraint(equalTo: leftV.leadingAnchor),
        ])
    }
    
    func setupRightLbl(_ rightLbl: UILabel, rightTxt: String, rightV: UIView, cell: UITableViewCell) {
        setupLbl(rightLbl, txt: rightTxt, cell: cell)
        
        NSLayoutConstraint.activate([
            rightLbl.bottomAnchor.constraint(equalTo: rightV.topAnchor, constant: -8.0),
            rightLbl.leadingAnchor.constraint(equalTo: rightV.leadingAnchor),
        ])
    }
    
    func setupLeftRightTF(_ leftTF: UITextField, _ rightTF: UITextField, lTxt: String, rTxt: String, cell: UITableViewCell) {
        setupLeftTF(leftTF, txt: lTxt, cell: cell)
        setupRightTF(rightTF, txt: rTxt, cell: cell)
    }
    
    func setupLeftTF(_ leftTF: UITextField, txt: String, cell: UITableViewCell) {
        setupTF(leftTF, txt: txt, cell: cell)
        
        let height: CGFloat = 50.0
        let width: CGFloat = (screenWidth-40)/2
        NSLayoutConstraint.activate([
            leftTF.heightAnchor.constraint(equalToConstant: height),
            leftTF.widthAnchor.constraint(equalToConstant: width),
            leftTF.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            leftTF.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func setupRightTF(_ rightTF: UITextField, txt: String, cell: UITableViewCell) {
        setupTF(rightTF, txt: txt, cell: cell)
        
        let height: CGFloat = 50.0
        let width: CGFloat = (screenWidth-40)/2
        NSLayoutConstraint.activate([
            rightTF.heightAnchor.constraint(equalToConstant: height),
            rightTF.widthAnchor.constraint(equalToConstant: width),
            rightTF.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15.0),
            rightTF.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0)
        ])
    }
    
    func setupLabel(_ lbl: UILabel, txt: String, tf: UITextField, cell: UITableViewCell) {
        setupLbl(lbl, txt: txt, cell: cell)
        
        NSLayoutConstraint.activate([
            lbl.bottomAnchor.constraint(equalTo: tf.topAnchor, constant: -8.0),
            lbl.leadingAnchor.constraint(equalTo: tf.leadingAnchor),
        ])
    }
    
    func setupFullTF(_ tf: UITextField, txt: String, cell: UITableViewCell) {
        setupTF(tf, txt: txt, cell: cell)
        
        let height: CGFloat = 50.0
        let width: CGFloat = screenWidth-30
        NSLayoutConstraint.activate([
            tf.heightAnchor.constraint(equalToConstant: height),
            tf.widthAnchor.constraint(equalToConstant: width),
            tf.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            tf.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func setupLeftView(_ leftView: UIView, cell: UITableViewCell) {
        setupView(leftView, cell: cell)
        
        let height: CGFloat = 50.0
        let width: CGFloat = (screenWidth-40)/2
        NSLayoutConstraint.activate([
            leftView.heightAnchor.constraint(equalToConstant: height),
            leftView.widthAnchor.constraint(equalToConstant: width),
            leftView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            leftView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func setupRightView(_ rightView: UIView, cell: UITableViewCell) {
        setupView(rightView, cell: cell)
        
        let height: CGFloat = 50.0
        let width: CGFloat = (screenWidth-40)/2
        NSLayoutConstraint.activate([
            rightView.heightAnchor.constraint(equalToConstant: height),
            rightView.widthAnchor.constraint(equalToConstant: width),
            rightView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15.0),
            rightView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8.0)
        ])
    }
    
    func setupImgView(_ imgV: UIImageView, view: UIView) {
        imgV.configureIMGViewForCell(view, imgName: "icon-triangle", ctMore: .scaleAspectFit)
        NSLayoutConstraint.activate([
            imgV.widthAnchor.constraint(equalToConstant: 15.0),
            imgV.heightAnchor.constraint(equalToConstant: 15.0),
            imgV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            imgV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupBtn(_ btn: UIButton, selector: Selector, imgV: UIImageView, view: UIView) {
        btn.addTarget(self, action: selector, for: .touchUpInside)
        view.insertSubview(btn, aboveSubview: imgV)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: view.topAnchor),
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupTF(_ tf: UITextField, txt: String, cell: UITableViewCell) {
        tf.text = txt
        tf.font = UIFont(name: fontNamed, size: 17.0)
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 5.0
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 0.5
        tf.backgroundColor = groupColor
        cell.contentView.addSubview(tf)
        tf.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLbl(_ lbl: UILabel, txt: String, cell: UITableViewCell) {
        lbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: txt, fontN: fontNamed)
        cell.contentView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.sizeToFit()
    }
    
    func setupView(_ view: UIView, cell: UITableViewCell) {
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = groupColor
        cell.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupAddNewAddBtn(_ btn: UIButton, cell: UITableViewCell) {
        let attributed = setupTitleAttri(addNewAddrTxt, size: 17.0)
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = .black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        btn.addTarget(self, action: #selector(addNewAddDidTap), for: .touchUpInside)
        cell.contentView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5.0),
            btn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            btn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15.0),
            btn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5.0),
        ])
    }
    
    func setupContentLbl(_ lbl: UILabel, txt: String, view: UIView) {
        lbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: txt, fontN: fontNamed)
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.sizeToFit()
        
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            lbl.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20.0),
            lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func addNewAddDidTap(_ sender: UIButton) {
        endEditing()
        handleTXTNotEmpty(&stateTxt, lbl: stateContentLbl, tf: stateTF)
        handleTXTNotEmpty(&cityTxt, lbl: cityContentLbl, tf: cityTF)
        
        print("===============//===============")
        print("First: \(firstNameTxt)")
        print("Last: \(lastNameTxt)")
        print("Add1: \(addressLine1Txt)")
        print("Add2: \(addressLine2Txt)")
        print("Country: \(countryTxt)")
        print("State: \(stateTxt)")
        print("City: \(cityTxt)")
        print("Zipcode: \(zipcodeTxt)")
        print("Phone: \(phoneNumberTxt)")
        print("\n")
        
        touchAnim(sender) {
            self.handleError(self.firstNameTxt, view: self.firstNameTF)
            self.handleError(self.lastNameTxt, view: self.lastNameTF)
            self.handleError(self.addressLine1Txt, view: self.addressLine1TF)
            self.handleError(self.countryTxt, view: self.countryView)
            self.handleError(self.stateTxt, view: self.stateTF)
            self.handleError(self.stateTxt, view: self.stateView)
            self.handleError(self.cityTxt, view: self.cityTF)
            self.handleError(self.cityTxt, view: self.cityView)
            self.handleError(self.zipcodeTxt, view: self.zipcodeTF)
            self.handleError(self.phoneNumberTxt, view: self.phoneNumberTF)
            
            guard !self.firstNameTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.lastNameTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.addressLine1Txt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.countryTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.stateTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.cityTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.zipcodeTxt.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.phoneNumberTxt.trimmingCharacters(in: .whitespaces).isEmpty
                else { return }
            
            self.firstNameTxt = self.firstNameTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.lastNameTxt = self.lastNameTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.addressLine1Txt = self.addressLine1Txt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.countryTxt = self.countryTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.stateTxt = self.stateTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.cityTxt = self.cityTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.zipcodeTxt = self.zipcodeTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            self.phoneNumberTxt = self.phoneNumberTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard isInternetAvailable() else { internetNotAvailable(); return }
            self.view.isUserInteractionEnabled = false
            
            let model = AddressModel(firstName: self.firstNameTxt,
                                     lastName: self.lastNameTxt,
                                     addrLine1: self.addressLine1Txt,
                                     addrLine2: self.addressLine2Txt,
                                     country: self.countryTxt,
                                     state: self.stateTxt,
                                     city: self.cityTxt,
                                     zipcode: self.zipcodeTxt,
                                     phoneNumber: self.phoneNumberTxt,
                                     createdTime: createTime(),
                                     defaults: self.addresses == [])
            
            if self.isEdit {
                print("Update")
                let addr = Address(model: model)
                addr.updateAddress(addr: self.address!) {
                    handleInternet(self.popUpTxt, imgName: "icon-checkmark") {
                        self.delegate?.handlePopVC(vc: self)
                    }
                }
                
            } else {
                print("New")
                let addr = Address(model: model)
                addr.saveAddress {
                    handleInternet(self.popUpTxt, imgName: "icon-checkmark") {
                        self.delegate?.handlePopVC(vc: self)
                    }
                }
            }
        }
    }
    
    func handleTXTNotEmpty(_ txt: inout String, lbl: UILabel, tf: UITextField?) {
        if !isCanada {
            if let tf = tf { txt = tf.text! }
            
        } else {
            if let str = lbl.text {
                txt = str
            }
        }
    }
    
    func handleError(_ txt: String, view: UIView?) {
        if let view = view {
            handleError(txt, view: view)
        }
    }
    
    func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
    
    @objc func firstNameChanged(tf: UITextField) {
        if let text = tf.text {
            tf.text = text.capitalized
        }
    }
    
    @objc func lastNameChanged(tf: UITextField) {
        if let text = tf.text {
            tf.text = text.capitalized
        }
    }
}

//MARK: - UITableViewDelegate
extension AddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 1 }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 { return 60.0 }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        if #available(iOS 12, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: kView.backgroundColor = groupColor
            case .dark: kView.backgroundColor = .black
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        return kView
    }
}

//MARK: - UINavigationControllerDelegate
extension AddressVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionCurve = .easeOut
            
        } else {
            interactiveTransition = nil
        }
        
        return interactiveTransition
    }
}

//MARK: - UITextFieldDelegate
extension AddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            if let text = firstNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(firstNameTF, color: .lightGray)
                    firstNameTxt = text
                    lastNameTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(firstNameTF)
                    firstNameTxt = ""
                    firstNameTF.becomeFirstResponder()
                }
            }
            
        } else if textField == lastNameTF {
            if let text = lastNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(lastNameTF, color: .lightGray)
                    lastNameTxt = text
                    addressLine1TF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(lastNameTF)
                    lastNameTxt = ""
                    lastNameTF.becomeFirstResponder()
                }
            }
            
        } else if textField == addressLine1TF {
            if let text = addressLine1TF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    borderView(addressLine1TF, color: .lightGray)
                    addressLine2TF.becomeFirstResponder()
                    addressLine1Txt = text
                    
                } else {
                    setupAnimBorderView(addressLine1TF)
                    addressLine1Txt = ""
                    addressLine1TF.becomeFirstResponder()
                }
            }
            
        } else if textField == addressLine2TF {
            if countryTxt == caTxt {
                textField.resignFirstResponder()
                
            } else {
                if let stateTF = stateTF { stateTF.becomeFirstResponder() }
            }
            
        } else if textField == stateTF {
            if let stateTF = stateTF {
                if let text = stateTF.text {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                        text.containsOnlyLetters, text.count < 30 {
                        borderView(stateTF, color: .lightGray)
                        stateTxt = text
                        if let cityTF = cityTF { cityTF.becomeFirstResponder() }
                        
                    } else {
                        setupAnimBorderView(stateTF)
                        stateTxt = ""
                        stateTF.becomeFirstResponder()
                    }
                }
            }
            
        } else if textField == cityTF {
            if let cityTF = cityTF {
                if let text = cityTF.text {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                        text.containsOnlyLetters, text.count < 30 {
                        borderView(cityTF, color: .lightGray)
                        cityTxt = text
                        zipcodeTF.becomeFirstResponder()
                        
                    } else {
                        setupAnimBorderView(cityTF)
                        cityTxt = ""
                        cityTF.becomeFirstResponder()
                    }
                }
            }
            
        } else if textField == zipcodeTF {
            if let text = zipcodeTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.count < 9 {
                    borderView(zipcodeTF, color: .lightGray)
                    zipcodeTxt = text
                    phoneNumberTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(zipcodeTF)
                    zipcodeTxt = ""
                    zipcodeTF.becomeFirstResponder()
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = phoneNumberTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits, text.count < 15 {
                    borderView(phoneNumberTF, color: .lightGray)
                    phoneNumberTxt = text
                    textField.resignFirstResponder()
                    
                } else {
                    setupAnimBorderView(phoneNumberTF)
                    phoneNumberTxt = ""
                    phoneNumberTF.becomeFirstResponder()
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTF {
            if let text = firstNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(firstNameTF, color: .lightGray)
                    firstNameTxt = text
                    
                } else {
                    setupAnimBorderView(firstNameTF)
                    firstNameTxt = ""
                }
            }
            
        } else if textField == lastNameTF {
            if let text = lastNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(lastNameTF, color: .lightGray)
                    lastNameTxt = text
                    
                } else {
                    setupAnimBorderView(lastNameTF)
                    lastNameTxt = ""
                }
            }
            
        } else if textField == addressLine1TF {
            if let text = addressLine1TF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    borderView(addressLine1TF, color: .lightGray)
                    addressLine1Txt = text
                    
                } else {
                    setupAnimBorderView(addressLine1TF)
                    addressLine1Txt = ""
                }
            }
            
        } else if textField.text == addressLine2TF.text {
            if let text = addressLine2TF.text { addressLine2Txt = text }
            
        } else if textField == stateTF {
            handleTxt(&stateTxt, tf: stateTF)
            
        } else if textField == cityTF {
            handleTxt(&cityTxt, tf: cityTF)
            
        } else if textField == zipcodeTF {
            if let text = zipcodeTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.count < 9 {
                    borderView(zipcodeTF, color: .lightGray)
                    zipcodeTxt = text
                    
                } else {
                    setupAnimBorderView(zipcodeTF)
                    zipcodeTxt = ""
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = phoneNumberTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits, text.count < 15 {
                    borderView(phoneNumberTF, color: .lightGray)
                    phoneNumberTxt = text
                    
                } else {
                    setupAnimBorderView(phoneNumberTF)
                    phoneNumberTxt = ""
                }
            }
        }
    }
    
    func handleTxt(_ txt: inout String, tf: UITextField?) {
        if let str = tf?.text {
            if !str.trimmingCharacters(in: .whitespaces).isEmpty,
                str.containsOnlyLetters, str.count < 30 {
                borderView(tf!, color: .lightGray)
                txt = str
                
            } else {
                setupAnimBorderView(tf!)
                txt = ""
            }
        }
    }
}

//MARK: - PopUpViewDelegate
extension AddressVC: PopUpViewDelegate {
    
    func fetchCountry(_ country: String, view: PopUpView) {
        countryTxt = country
        view.handleCancel(containerView, popUpTV)
        isCanada = country == caTxt
        if !isCanada { stateLbl.text = nil; cityLbl.text = nil; stateTxt = ""; cityTxt = "" }
        tableView.reloadData()
    }
    
    func fetchState(_ state: String, view: PopUpView) {
        stateTxt = state
        view.handleCancel(containerView, popUpTV)
        isCanada = true
        tableView.reloadData()
        
        if let text = stateContentLbl.text {
            if stateTxt != text {
                cityLbl.text = nil
                cityTxt = ""
            }
        }
        
        if !stateTxt.isEmpty {
            fetchStatesData()
        }
    }
    
    func fetchCity(_ city: String, view: PopUpView) {
        cityTxt = city
        view.handleCancel(containerView, popUpTV)
        isCanada = true
        tableView.reloadData()
        
        if !cityTxt.isEmpty {
            fetchCitiesData()
        }
    }
    
    func handleCancelDidTap(_ view: PopUpView) {
        view.handleCancel(containerView, popUpTV)
    }
    
    @objc func handleCancel() {
        containerView.transform = .identity
        UIView.animate(withDuration: 0.33, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            self.containerView.alpha = 0.0
            self.popUpTV.alpha = 0.0
            self.popUpView.alpha = 0.0
        }) { (_) in
            self.popUpView.removeFromSuperview()
        }
    }
}

//MARK: - DarkMode
extension AddressVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        view.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
        tableView.reloadData()
        setupDMPopUpView(isDarkMode)
        setupTraitCollection(isDarkMode)
    }
    
    private func setupTraitCollection(_ isDarkMode: Bool = false) {
        firstNameLbl.textColor = isDarkMode ? .white : .black
        lastNameLbl.textColor = isDarkMode ? .white : .black
        addressLine1Lbl.textColor = isDarkMode ? .white : .black
        addressLine2Lbl.textColor = isDarkMode ? .white : .black
        countryLbl.textColor = isDarkMode ? .white : .black
        countryContentLbl.textColor = isDarkMode ? .white : .black
        countryIcon.tintColor = isDarkMode ? .white : .black
        stateLbl.textColor = isDarkMode ? .white : .black
        stateIcon.tintColor = isDarkMode ? .white : .black
        stateContentLbl.textColor = isDarkMode ? .white : .black
        cityLbl.textColor = isDarkMode ? .white : .black
        cityIcon.tintColor = isDarkMode ? .white : .black
        cityContentLbl.textColor = isDarkMode ? .white : .black
        zipcodeLbl.textColor = isDarkMode ? .white : .black
        phoneNumberLbl.textColor = isDarkMode ? .white : .black
        
        let attC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(addNewAddrTxt, txtColor: attC, size: 17.0)
        addNewAddBtn.setAttributedTitle(attributed, for: .normal)
        addNewAddBtn.backgroundColor = isDarkMode ? .white : .black
    
        firstNameTF.backgroundColor = isDarkMode ? darkColor : groupColor
        lastNameTF.backgroundColor = isDarkMode ? darkColor : groupColor
        addressLine1TF.backgroundColor = isDarkMode ? darkColor : groupColor
        addressLine2TF.backgroundColor = isDarkMode ? darkColor : groupColor
        countryView.backgroundColor = isDarkMode ? darkColor : groupColor
        stateTF?.backgroundColor = isDarkMode ? darkColor : groupColor
        stateView?.backgroundColor = isDarkMode ? darkColor : groupColor
        cityTF?.backgroundColor = isDarkMode ? darkColor : groupColor
        cityView?.backgroundColor = isDarkMode ? darkColor : groupColor
        zipcodeTF.backgroundColor = isDarkMode ? darkColor : groupColor
        phoneNumberTF.backgroundColor = isDarkMode ? darkColor : groupColor
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
}
