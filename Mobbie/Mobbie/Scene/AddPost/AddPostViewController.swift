//
//  AddPostViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import PhotosUI

final class AddPostViewController: BaseViewController, TransitionProtocol {
    
    private let scrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let placeholderView = UIView()
    
    private let placeholderLabel = {
        let label = UILabel()
        label.text = "무슨 일이 일어나고 있나요?"
        label.textColor = .gray.withAlphaComponent(0.6)
        label.font = Design.Font.preRegular.largeFont
        return label
    }()
    
    private let textView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.returnKeyType = .default
        view.keyboardAppearance = .dark
        view.keyboardDismissMode = .onDrag
        view.borderStyle = .none
        view.textColor = .white
        view.font = Design.Font.preRegular.largeFont
        view.becomeFirstResponder()
        view.sizeToFit()
        return view
    }()
    
    private let emptyView = UIView()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.backgroundColor = .clear
        return view
    }()
    
    private let addButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .highlightOrange
        config.title = "게시하기"
        var container = AttributeContainer()
        container.foregroundColor = UIColor.white
        container.font = Design.Font.preMedium.midFont
        config.attributedTitle = AttributedString("게시하기", attributes: container)
        view.configuration = config
        return view
    }()
    
    private let cameraButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "camera", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        return button
    }()
    
    private let pictureButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "photo", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        return button
    }()
    
    private let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        label.textColor = UIColor.highlightMint
        label.text = "12/200"
        label.snp.makeConstraints { make in
            make.width.equalTo(66)
        }
        return label
    }()
    
    private lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.setCollectionViewLayout())
        view.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
        view.register(AddButtonCollectionViewCell.self, forCellWithReuseIdentifier: AddButtonCollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var images: [UIImage] = []
    private let viewModel = AddPostViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.AddArrangedSubviews([placeholderView, photoCollectionView, emptyView])
        [placeholderLabel, textView].forEach { placeholderView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        placeholderView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(200)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(150)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(textView).inset(8)
        }
    }
    
    
    
    override func configureView() {
        textView.becomeFirstResponder()
        
        let toolbar = UIToolbar()

        let pic = UIBarButtonItem(customView: pictureButton)
        pictureButton.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        let camera = UIBarButtonItem(customView: cameraButton)
        cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        let label = UIBarButtonItem(customView: limitLabel)
        label.isEnabled = true
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([camera, pic, flexibleSpaceButton, label], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
    }
    
    
    private func bind() {
        viewModel.alert = sendOneSideAlert(title:message:)
        viewModel.transition = self
        
        let input = AddPostViewModel.Input(
            addButtonTapped: addButton.rx.tap,
            text: textView.rx.text.orEmpty
        )
        
        guard let output = viewModel.transform(input: input) else { return }
        
        Observable.combineLatest(output.isSaved, output.errorMessage)
            .bind(with: self) { owner, value in
                if value.0 { // saved
                    owner.view.makeToast("저장되었습니다.", position: .center)
                    owner.navigationController?.dismiss(animated: true)
                } else {
                    owner.sendOneSideAlert(title: value.1, message: "다시 시도해 주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        output.text
            .bind(with: self) { owner, str in
                let canSaved = str.count > 0 && str.count < 201 && !str.replacingOccurrences(of: " ", with: "").isEmpty
                owner.addButton.isEnabled = canSaved ? true : false
                owner.placeholderLabel.isHidden = str.isEmpty ? false : true
                owner.limitLabel.textColor = str.count > 200 ? .red : UIColor.highlightMint
                owner.limitLabel.text = "\(str.count)/200"
            }
            .disposed(by: disposeBag)
        
        output.images
            .bind(with: self) { owner, images in
                owner.images = images
                owner.photoCollectionView.reloadData()
                if images.count >= 4 {
                    owner.pictureButton.isEnabled = false
                    owner.cameraButton.isEnabled = false
                } else {
                    owner.pictureButton.isEnabled = true
                    owner.cameraButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: Design.Font.preMedium.getFonts(size: 17)
        ], for: .normal)
        
        let addButton = UIBarButtonItem(customView: self.addButton)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    
}


extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let add = viewModel.add
        let images = viewModel.calImg
        if add == 1 && indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddButtonCollectionViewCell.identifier, for: indexPath) as? AddButtonCollectionViewCell else { return UICollectionViewCell() }
            
            // 더 추가할 수 있는 경우
            cell.delegate = self
            cell.configureAddButton(imagesCount: images)
            
            return cell
        } else {
            guard images != 0 else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as? AddPhotoCollectionViewCell else { return UICollectionViewCell() }
            
            let row = indexPath.item - add
            cell.delegate = self
            cell.image = self.images[row]
            cell.configureUserImage()
            return cell
            
        }
    }
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3.6
        
        layout.itemSize = CGSize(width: width, height: 130)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        layout.scrollDirection = .horizontal
        
        return layout
        
    }
    
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddDelegate {
    
    @objc func takePhoto() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = false
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.images.append(image)
            viewModel.imageCount += 1
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


// 앨범에서 가져오깅
extension AddPostViewController: PHPickerViewControllerDelegate {
    
    @objc func openPhotoAlbum() {
        var config = PHPickerConfiguration()
        
        config.filter = .images
        config.selectionLimit = 4 - viewModel.imageCount
        config.selection = .ordered
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let dispatchGroup = DispatchGroup()
        
        var images = [UIImage]()
        
        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                let type: NSItemProviderReading.Type = UIImage.self
                itemProvider.loadObject(ofClass: type) { [weak self](image, error) in
                    guard let self = self else { return }
                    
                    if let image = image as? UIImage {
                        images.append(image)
                        dispatchGroup.leave()
                        
                    } else {
                        
                        print(error?.localizedDescription)
                        self.sendOneSideAlert(title: "이미지를 가져올 수 없습니다.", message: "다시 시도해 주세요!")
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            if viewModel.imageCount + images.count > 5 {
                self.sendOneSideAlert(title: "이미지는 4개까지 추가할 수 있어요!", message: "")
                return
            } else {
                viewModel.images.append(contentsOf: images)
                viewModel.imageCount += images.count
            }
        }
    }
    
}


extension AddPostViewController: DeleteDelegate {
    
    func deleteImages(image: UIImage) {
        if let firstIndex = self.images.firstIndex(of: image) {
            viewModel.images.remove(at: firstIndex)
            viewModel.imageCount -= 1
        }
    }
}
