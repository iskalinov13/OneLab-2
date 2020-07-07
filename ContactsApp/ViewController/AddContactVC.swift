//
//  AddContactViewController.swift
//  ContactsApp
//
//  Created by Farukh Iskalinov on 2.07.20.
//  Copyright © 2020 Farukh Iskalinov. All rights reserved.
//

import UIKit
// здесь, использовать разных делегатов как то тупо
// не нашел подходящий способ как обновить данные сразу две котроллеров(это случай когда данные контакта меняется).
//A->B->C Контроллер C должен обновить контроллер B и A сразу
protocol ContactAddDelegate{
    func addContact(_ contactObject: Contact)
}
protocol ContactUpdateDelegate {
    func updateContact(_ contactObject: Contact)
}

class AddContactVC: UIViewController {
    var contactAddDelegate: ContactAddDelegate?
    var contactUpdateDelegate: ContactUpdateDelegate?
    var contact: Contact?
    var flag = false
    private let contactViewModel = ContactVM()
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let pageTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "Контакт"
        return label
    }()
    private let imageUser: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "userPhoto"))
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let labelAddPhoto: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemBlue
        label.text = "Добавить фото"
        return label
    }()
    private lazy var stackViewAddPhoto: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageUser, labelAddPhoto])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        return textField
    }()
    private let textFieldSurname: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.addBottomBorder()
        return textField
    }()
    
    private let borderView1: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    private let borderView2: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    private let borderView3: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    private let textFieldPhone: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "Телефон"
        textField.tag = 1
        return textField
    }()
    private lazy var stackViewUserInfo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldName, textFieldSurname, textFieldPhone])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //Configure Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.titleView = pageTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(didTapSubmit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(didTapCancel))
        
        //TextField Delegate
        textFieldPhone.delegate = self
        
        makeConstraint()
        updateUI()
    }
    
    private func makeConstraint() {
        [stackViewAddPhoto, stackViewUserInfo].forEach {
            view.addSubview($0)
        }
        stackViewAddPhoto.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        imageUser.snp.makeConstraints { (make) in
            make.size.equalTo(UIScreen.main.bounds.width / 2)
            
        }
        stackViewUserInfo.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(stackViewAddPhoto.snp.bottom).offset(20)
        }
        //тут можно добавить один borderView для всеx а не создавать для каждого отдельно?
        textFieldName.addSubview(borderView1)
        textFieldSurname.addSubview(borderView2)
        textFieldPhone.addSubview(borderView3)
        
        // тут не знал как построит канстрейнты сразу всем в одно время типо [borderView1,borderView2,borderView3].snp ...
        borderView1.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(textFieldName.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        borderView2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(textFieldSurname.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        borderView3.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(textFieldPhone.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let contact = contact else {
            return
        }
        flag = true
        textFieldName.text = contact.name
        textFieldSurname.text = contact.surname
        textFieldPhone.text = contact.phone
    }
    
    @objc private func didTapSubmit() {
        
        let nameText = textFieldName.text
        let surnameText = textFieldSurname.text
        let phoneText = textFieldPhone.text
        
        guard let name = nameText, let surname = surnameText, let phone = phoneText else {
            let alert = UIAlertController(title: "Ошибка", message: "Поле не должно быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Oк", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } 
        
        if name == "" || surname == "" || phone == "" {
            let alert = UIAlertController(title: "Ошибка", message: "Поле не должно быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if flag {
                let contactObject = Contact(id: contact!.id, name: name, surname: surname, phone: phone)
                contactUpdateDelegate?.updateContact(contactObject)
                flag = false
                contact = nil
                self.navigationController?.popViewController(animated: true)
            } else {
                let contactObject = Contact(id: UUID().uuidString, name: name, surname: surname, phone: phone)
                if contactViewModel.contains(contactObject) { // Тут не работает, contains всегда false и из за этого он добавит одинаковых номеров
                    let alert = UIAlertController(title: "Ошибка", message: "Контакт с таким номером уже существует", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Oк", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    contactAddDelegate?.addContact(contactObject)
                    print(contactViewModel.contacts)
                    print("vse ok")
                    self.navigationController?.popViewController(animated: true)
                }
  
            }
        }
    }
    
    @objc private func didTapCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: TextField Delegate
extension AddContactVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if textField.tag == 1 {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = textField.formattedNumber(number: newString)
        }
        return false
    }
}
extension UITextField {
    //не знал как добавить обычный border для textField и пришлось написать extension
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XX-XX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}

