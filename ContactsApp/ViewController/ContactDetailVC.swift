//
//  ContactDetailViewController.swift
//  ContactsApp
//
//  Created by Farukh Iskalinov on 6.07.20.
//  Copyright © 2020 Farukh Iskalinov. All rights reserved.
//

import UIKit

class ContactDetailVС: UIViewController {
    var contact: Contact
    private let contactViewModel = ContactVM()
    private let tableView = UITableView()
    private let tableHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let imageContact: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "userPhoto"))
        imageView.contentMode = .scaleAspectFit
        imageView.bounds.size = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    private let buttonMessage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "message.circle.fill"), for: .normal)
        return button
    }()
    private let labelMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "написать"
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    private lazy var stackViewMessage: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonMessage, labelMessage])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let buttonPhone: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "phone.circle.fill"), for: .normal)
        return button
    }()
    private let labelPhone: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "позвонить"
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    private lazy var stackViewPhone: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonPhone, labelPhone])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let buttonWhatsApp: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "video.circle.fill"), for: .normal)
        return button
    }()
    private let labelWhatsApp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "WhatsApp"
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    private lazy var stackViewWhatsApp: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonWhatsApp, labelWhatsApp])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let buttonEmail: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "envelope.circle.fill"), for: .normal)
        return button
    }()
    private let labelEmail: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "e-mail"
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    private lazy var stackViewEmail: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonEmail, labelEmail])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewMessage, stackViewPhone, stackViewWhatsApp, stackViewEmail])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var stackViewDetail: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContact, labelName, stackViewButtons])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    override func viewDidLayoutSubviews() {
        let size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if tableHeaderView.frame.size.height != size.height {
            tableHeaderView.frame.size.height = size.height
        }
        tableView.tableHeaderView = tableHeaderView
    }
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Configure Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(didTapEdit))
        
        // Configure TableView Controller
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Configure UI Layer
        makeConstraint()
        updateUI()
    }
    
    private func makeConstraint() {
        view.addSubview(tableView)
        imageContact.snp.makeConstraints { (make) in
             make.size.equalTo(UIScreen.main.bounds.width / 4)
        }
        // тут тоже самое можно ли как-то сократить код типо [buttonMessage,buttonPhone...].snp ...
        buttonMessage.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.width / 10)
        }
        buttonPhone.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.width / 10)
        }
        buttonWhatsApp.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.width / 10)
        }
        buttonEmail.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.width / 10)
        }
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableHeaderView.addSubview(stackViewDetail)
        stackViewDetail.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    private func updateUI() {
        labelName.text = "\(contact.name) \(contact.surname)"
        tableView.reloadData()
    }
    
    @objc private func didTapEdit(){
        let vc = AddContactVC(contact: contact)
        vc.contactUpdateDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Extension DataSource
extension ContactDetailVС: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "сотовый"
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.detailTextLabel?.text = contact.phone
            cell.detailTextLabel?.font = .systemFont(ofSize: 17)
            cell.detailTextLabel?.textColor = .systemBlue
        case 1:
            cell.textLabel?.text = "Заметки"
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.snp.makeConstraints({ (make) in // тут не смог дать обычный aligment .top.left для текста почему так сложноо(((
                make.top.equalToSuperview().inset(10)
                make.leading.equalToSuperview().inset(20)
            })
        case 2: // В андроиде есть отдельный файл (Strings.xml, Dimensions, Colors) где можно хранить все константы в айосе как это ?
            cell.textLabel?.text = "Отправить сообщение"
            cell.textLabel?.textColor = .systemBlue
        case 3:
            cell.textLabel?.text = "Поделиться контактом"
            cell.textLabel?.textColor = .systemBlue
        case 4:
            cell.textLabel?.text = "Добавить в Избранные"
            cell.textLabel?.textColor = .systemBlue
        case 5:
            cell.textLabel?.text = "Добавить в контакты на случай ЧП"
            cell.textLabel?.textColor = .systemRed
        default:
            cell.textLabel?.textColor = .black
        }
        return cell
    }
}
//MARK: Extension Delegate
extension ContactDetailVС: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 150
        } else {
            return tableView.rowHeight
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactDetailVС: ContactUpdateDelegate{
    func updateContact(_ contactObject: Contact){
        contact = contactObject
        // не нашел подходящий способ как обновить данные сразу две котроллеров(это случай когда данные контакта меняется).
        //A->B->C Контроллер C должен обновить контроллер B и A сразу
        let vc = navigationController?.viewControllers.first as! ContactsVС
        vc.contactViewModel.updateContact(contactObject)
    }
}
