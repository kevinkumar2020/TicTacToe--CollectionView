//
//  ViewController.swift
//  TicTacToe
//
//  Created by DCS on 24/06/21.
//  Copyright © 2021 DCS. All rights reserved.
//



import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var collectionView: UICollectionView?
    
    private var state = [2,2,2,2,
                         2,2,2,2,
                         2,2,2,2,
                         2,2,2,2]
    
    private let winningCombinations = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], [0, 5, 10, 15], [3, 6, 9, 12], [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]]
    
    private var zeroFlag = false
    
    private let myLabel:UILabel = {
        let label = UILabel()
        label.text = "Lets Play The Game...."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    private let myLabel1:UILabel = {
        let label1 = UILabel()
        label1.text = "Turn : "
        label1.font = UIFont.boldSystemFont(ofSize: 24)
        label1.textAlignment = .center
        label1.textColor = UIColor.black
        return label1
    }()
    
    private let turnLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 200, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: 80, height: 80)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        guard let collectionView = collectionView else{
            return
        }
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        view.addSubview(myLabel)
        view.addSubview(myLabel1)
        view.addSubview(turnLabel)
        collectionView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myLabel.frame = CGRect(x: 20, y: 70, width: view.width - 40, height: 40)
        myLabel1.frame = CGRect(x: 20, y: 140, width: view.width - 40, height: 40)
        turnLabel.frame = CGRect(x: 70, y: 140, width: view.width - 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //        cell.contentView.backgroundColor = UIColor.gray
        //        cell.contentView.layer.borderWidth = 2
        //        cell.contentView.layer.borderColor = UIColor.red.cgColor
        cell.setupCell(with: state[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if state[indexPath.row] != 0 && state[indexPath.row] != 1 {
            state.remove(at: indexPath.row)
            
            if zeroFlag {
                turnLabel.text = "X"
                state.insert(0, at: indexPath.row)
            } else {
                turnLabel.text = "O"
                state.insert(1, at: indexPath.row)
            }
            
            zeroFlag = !zeroFlag
            collectionView.reloadData()
            checkWinner()
        }
    }
    
    private func checkWinner() {
        
        if !state.contains(2) {
            let alert = UIAlertController(title: "Game over!", message: "Draw. Try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
                self?.resetState()
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        for i in winningCombinations {
            if state[ i[0] ] == state[ i[1] ] && state[ i[1] ] == state[ i[2] ] && state[ i[2] ] == state[ i[3] ] && state[ i[0] ] != 2 {
                announceWinner(player: state[ i[0] ] == 0 ? "0" : "X")
                break
            }
        }
    }
    
    private func announceWinner(player: String) {
        let alert = UIAlertController(title: "Game over!", message: "\(player) won", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
            self?.resetState()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func resetState() {
        state = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
        zeroFlag = false
        collectionView!.reloadData()
    }
    
}
