//
//  ViewController.swift
//  ContactsApp
//
//  Created by Farukh Iskalinov on 1.07.20.
//  Copyright © 2020 Farukh Iskalinov. All rights reserved.
//

import UIKit
import SnapKit

class ContactsVС: UIViewController {
    
    let contactViewModel = ContactVM()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    private let tableHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let imageUser: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "userPhoto"))
        imageView.contentMode = .scaleAspectFit
        imageView.bounds.size = CGSize(width: 80, height: 80)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let labelFullName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.text = "Farukh Iskalinov"
        return label
    }()
    private let labelMyCard: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "Моя карточка"
        return label
    }()
    
    private lazy var stackViewUserName: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelFullName, labelMyCard])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var stackViewUserInfo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageUser,stackViewUserName ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
        tableView.tableHeaderView = tableHeaderView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //Configure Navigation Controller
        title = "Контакты"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Группы", style: .plain, target: self, action: #selector(didTapGroup))
        
        //Configure Search Controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        // так и не понял что он делает
        definesPresentationContext = true
        
        //Configure TableView Controller
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Configure UI Layer
        // у меня такой вопрос, как completion handler вызывается когдв необходимо хотя он лежит в viewDidLoad()
        // я везде удалил tableView.reloadData() но работает обычно viewDidLoad() вызывается когда прилажуха раннится и все
        contactViewModel.updateTableContent = {
            self.tableView.reloadData()
        }
        makeConstraint()
        contactViewModel.showSortedContacts()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        contactViewModel.showSortedContacts()
    }
    
    @objc private func didTapAdd() {
        let vc = AddContactVC()
        vc.contactAddDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGroup() {
        
    }
    
    private func makeConstraint() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        imageUser.snp.makeConstraints { (make) in
            make.size.equalTo(80)
            
        }
        tableHeaderView.addSubview(stackViewUserInfo)
        stackViewUserInfo.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
//MARK: Search Delegate
extension ContactsVС: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contactViewModel.searchContact(name: searchText)
        //tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        contactViewModel.showSortedContacts()
        //tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            contactViewModel.searchContact(name: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
//MARK: TableView Data Source
extension ContactsVС: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = Int()
        if searchController.isActive && searchController.searchBar.text != "" {
            count = 1
        } else {
            count = contactViewModel.sectionKeys.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        if searchController.isActive && searchController.searchBar.text != "" {
            count = contactViewModel.filteredContacts.count
        } else  {
            count = contactViewModel.contacts[section].count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if searchController.isActive && searchController.searchBar.text != "" {
            let contact = contactViewModel.filteredContacts[indexPath.row]
            cell.textLabel?.text = "\(contact.name) \(contact.surname)"
            
        } else {
            let contact = contactViewModel.getContactAt(section: indexPath.section, row: indexPath.row)
            cell.textLabel?.text = "\(contact.name) \(contact.surname)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = String()
        if searchController.isActive && searchController.searchBar.text != "" {
            sectionTitle = contactViewModel.getSectionTitle()
        } else {
            if section < contactViewModel.sectionKeys.count {
                sectionTitle = contactViewModel.sectionKeys[section]
            }
        }
        return sectionTitle
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactViewModel.removeContactAt(section: indexPath.section, row: indexPath.row)
            contactViewModel.showSortedContacts()
        }
    }
}
//MARK: TableView: Delegeate
extension ContactsVС: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = searchController.isActive && searchController.searchBar.text != "" ? contactViewModel.filteredContacts[indexPath.row] : contactViewModel.getContactAt(section: indexPath.section, row: indexPath.row)
        let vc = ContactDetailVС(contact: contact)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ContactsVС: ContactAddDelegate{
    func addContact(_ contactObject: Contact){
        contactViewModel.addContact(contactObject)
    }
}

