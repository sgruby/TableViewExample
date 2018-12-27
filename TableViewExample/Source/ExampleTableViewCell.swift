//
//  ExampleTableViewCell.swift
//  TableViewExample
//
//  Created by Scott Gruby on 12/3/18.
//  Copyright © 2018 Scott Gruby. All rights reserved.
//

import UIKit

struct CellData {
    let label1: String?
    let label2: String?
    let label3: String?
    let label4: String?
    let label5: String?
    let label6: String?
    let imageUrlString: String?
}

public extension UIView {
    public func clearLabels() {
        for view in subviews {
            (view as? UILabel)?.text = nil
            view.clearLabels()
        }
    }
}

class ExampleImageView: UIImageView {
    var minimumHeight: CGFloat = 0
    override var intrinsicContentSize: CGSize {
        if minimumHeight == 0 {
            return super.intrinsicContentSize
        }
        return CGSize(width: 0, height: minimumHeight)
    }
}

class ExampleTableViewCell: UITableViewCell, URLSessionDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cellImageView: ExampleImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var cellImageViewWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellImageViewHeightLayoutConstraint: NSLayoutConstraint!
    var downloadSession: URLSession = URLSession.shared
    var downloadTask: URLSessionDownloadTask?
    var cellWidth: CGFloat = 0 {
        didSet {
            maxImageWidth = cellWidth / 3
            setImageWidth()
        }
    }

    fileprivate var maxImageWidth: CGFloat = 120

    var cellData: CellData? {
        didSet {
            cellImageViewWidthLayoutConstraint.constant = maxImageWidth
            setupText()
            loadImage()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        cellImageViewWidthLayoutConstraint.constant = maxImageWidth
        activityIndicator.stopAnimating()

        label1.isHidden = false
        label2.isHidden = false
        label3.isHidden = false
        label4.isHidden = false
        label5.isHidden = false
        label6.isHidden = false
    }

    func setupText() {
        label1.text = cellData?.label1
        label2.text = cellData?.label2
        label3.text = cellData?.label3
        label4.text = cellData?.label4
        label5.text = cellData?.label5
        label6.text = cellData?.label6

        label1.isHidden = label1.text == nil
        label2.isHidden = label2.text == nil
        label3.isHidden = label3.text == nil
        label4.isHidden = label4.text == nil
        label5.isHidden = label5.text == nil
        label6.isHidden = label6.text == nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        contentView.clearLabels()
        cellImageView.minimumHeight = cellImageViewHeightLayoutConstraint.constant
        cellImageViewWidthLayoutConstraint.constant = maxImageWidth

        label1.textColor = .red
        label2.textColor = .green
        label3.textColor = .blue
        label4.textColor = .orange
        label5.textColor = .purple
        label6.textColor = .black
    }

    fileprivate func setImageWidth() {
        if let image = cellImageView.image {
            let scale = image.size.height / contentView.frame.size.height
            var newWidth = image.size.width / scale
            if newWidth > maxImageWidth {
                newWidth = maxImageWidth
            }

            contentView.layoutIfNeeded()
            let animator = UIViewPropertyAnimator.init(duration: 0.1, curve: .easeOut) {[weak self] in
                guard let self = self else {return}
                self.cellImageViewWidthLayoutConstraint.constant = newWidth
                self.contentView.layoutIfNeeded()
            }

            animator.startAnimation()
        }
    }

    fileprivate func loadImage() {
        cellImageView.image = nil
        if let imageUrlString: String = cellData?.imageUrlString, let url: URL = URL(string: imageUrlString) {
            activityIndicator.startAnimating()
            downloadTask = downloadSession.downloadTask(with: url) { [weak self] (downloadUrl, _, error) in
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.activityIndicator.stopAnimating()
                    if error == nil {
                        if let downloadUrl = downloadUrl, let data = try? Data(contentsOf: downloadUrl) {
                            if let image = UIImage(data: data) {
                                self.cellImageView.image = image
                            } else {
                                // We had a problem downloading the image
                                self.cellImageView.image = UIImage(named: "NoImage")
                            }
                            self.setImageWidth()
                        }
                    }
                }
            }
            downloadTask?.resume()
        }
    }
}
