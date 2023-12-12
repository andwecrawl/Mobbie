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

class AddPostViewController: BaseViewController, TransitionProtocol {
    
    let scrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let placeholderView = UIView()
    
    let placeholderLabel = {
        let label = UILabel()
        label.text = "무슨 일이 일어나고 있나요?"
        label.textColor = .gray.withAlphaComponent(0.6)
        label.font = Design.Font.preRegular.largeFont
        return label
    }()
    
    let textView = {
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
    
    let emptyView = UIView()
    
    let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.backgroundColor = .clear
        return view
    }()
    
    let addButton = {
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
    
    let cameraButton = {
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
    
    let pictureButton = {
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
    
    let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        label.textColor = UIColor.highlightMint
        label.text = "12/200"
        label.snp.makeConstraints { make in
            make.width.equalTo(66)
        }
        return label
    }()
    
    lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.setCollectionViewLayout())
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        view.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .yellow
        return view
    }()
    
    
    let viewModel = AddPostViewModel()
    let disposeBag = DisposeBag()
    
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
        stackView.backgroundColor = .brown
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        placeholderView.backgroundColor = .cyan
        placeholderView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(200)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        textView.backgroundColor = .blue
        textView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.horizontalEdges.equalToSuperview()
        }
        
        emptyView.backgroundColor = .green
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
    
    
    func bind() {
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
                    owner.addButtonTapped()
                } else {
                    owner.sendOneSideAlert(title: value.1, message: "다시 시도해 주세요!")
                }
            }
            .disposed(by: disposeBag)
        
        output.text
            .bind(with: self) { owner, str in
                if str.isEmpty {
                    owner.placeholderLabel.isHidden = false
                } else {
                    owner.placeholderLabel.isHidden = true
                }
                owner.textView.textColor = .white
                owner.limitLabel.text = "\(str.count)/200"
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
    
    @objc func addButtonTapped() {
        // post code
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as? AddPhotoCollectionViewCell else { return UICollectionViewCell() }
            
            // 더 추가할 수 있는 경우
            cell.delegate = self
            
            return cell
        } else {
            guard images != 0 else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            
            let row = indexPath.item - add
            cell.image = viewModel.images[row]
            cell.configureUserImage()
            return cell
            
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 12
        
        // 여백을 제외한 content 전체의 가로 길이
        // 이런 식으로 가로를 잡아주면 각 핸드폰의 가로 길이를 바탕으로 Content의 가로를 잡아주므로 확장성이 좋아짐!
        let width = UIScreen.main.bounds.width / 3
        
        // itemSize를 여백에 맞춰 만들어 주기
        layout.itemSize = CGSize(width: width, height: width * 1.3)
        
        // 위아래 양옆 여백
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 4, right: space)
        
        // 사이 여백
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.scrollDirection = .horizontal
        
        return layout
        
    }
    
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddDelegate {
    
    @objc func takePhoto() {
        // 추후 권한 설정 추가할 것
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
                        // 다시 시도 Alert
                        print(error?.localizedDescription)
                        self.sendOneSideAlert(title: "이미지를 가져올 수 없습니다.", message: "다시 시도해 주세요!")
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            if viewModel.images.count + images.count > 5 {
                self.sendOneSideAlert(title: "이미지는 4개까지 추가할 수 있어요!", message: "")
                return
            } else {
                viewModel.imageCount += images.count
                viewModel.images.append(contentsOf: images)
            }
        }
    }
    
}
