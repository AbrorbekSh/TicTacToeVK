//
//  TicTacToeViewController.swift
//  TicTacVK
//
//  Created by Аброрбек on 10.04.2024.
//

import UIKit

final class TicTacToeViewController: UIViewController {
    private let boardSize = 3
    private var currentPlayer = Player.X
    private var board = [[Player?]]()

    private let cellSize: CGFloat = 100.0
    private let padding: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupBoard()
    }

    private func setupBoard() {
        board = Array(repeating: Array(repeating: nil, count: boardSize), count: boardSize)

        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let button = UIButton()
                button.frame = CGRect(x: CGFloat(col) * (cellSize + padding) + (view.frame.size.width - 320)/2,
                                      y: CGFloat(row) * (cellSize + padding) + (view.frame.size.height - 320)/2,
                                      width: cellSize, 
                                      height: cellSize
                )
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                button.layer.borderWidth = 1.5
                button.layer.borderColor = UIColor.black.cgColor
                button.tag = row * boardSize + col
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
    }

    @objc 
    private func buttonTapped(_ sender: UIButton) {
        let row = sender.tag / boardSize
        let col = sender.tag % boardSize

        guard board[row][col] == nil else { return }

        board[row][col] = currentPlayer
        UIView.animate(withDuration: 1) {
            sender.setTitle(self.currentPlayer.rawValue, for: .normal)
        }

        if checkForWinner() {
            showAlert(message: "\(currentPlayer.rawValue) Выиграл!")
            resetBoard()
            return
        }

        if isBoardFull() {
            showAlert(message: "Ничья!")
            resetBoard()
            return
        }

        currentPlayer = (currentPlayer == .X) ? .O : .X
    }

    private func checkForWinner() -> Bool {
        for i in 0..<boardSize {
            if board[i][0] == board[i][1] && board[i][0] == board[i][2] && board[i][0] != nil {
                return true
            }
            if board[0][i] == board[1][i] && board[0][i] == board[2][i] && board[0][i] != nil {
                return true
            }
        }
        if board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] != nil {
            return true
        }
        if board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] != nil {
            return true
        }
        return false
    }

    private func isBoardFull() -> Bool {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if board[row][col] == nil {
                    return false
                }
            }
        }
        return true
    }

    private func resetBoard() {
        for view in self.view.subviews {
            if let button = view as? UIButton {
                button.setTitle("", for: .normal)
            }
        }
        board = Array(repeating: Array(repeating: nil, count: boardSize), count: boardSize)
        currentPlayer = .X
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

enum Player: String {
    case X = "X"
    case O = "O"
}

