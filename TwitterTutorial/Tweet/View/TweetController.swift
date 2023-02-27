//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/27.
//

import UIKit
import Combine

private let headerIdentifier = "TweetHeader"
private let cellIdentifier = "TweetCell"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    var viewModel: TweetViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Lifecycle
    init(viewModel: TweetViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchReplies()
        bind()
        configureCollectionView()
    }
    
    //MARK: - bind
    private func bind() {
        viewModel.replies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    //MARK: - Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - CollectionView Datasource / Delegate
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRepliesCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.getRepliesCellViewModel(index: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? TweetHeader else { return UICollectionReusableView() }
        header.viewModel = viewModel
        return header
    }
}

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: viewModel.tweet)
        let captionHeight = viewModel.size(forwith: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
