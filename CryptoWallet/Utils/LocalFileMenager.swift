//
//  LocalFileMenager.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 26/08/2025.
//

import SwiftUI


final class LocalFileMenager {
    
    static let shared = LocalFileMenager()
    
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Save error:", error.localizedDescription)
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }

        return UIImage(contentsOfFile: url.path)
    }

    private func createFolderIfNeeded(folderName: String) {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return }

        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("Create dir error:", error.localizedDescription)
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        // Jeśli chcesz trwałość, zmień .cachesDirectory -> .documentDirectory
        guard let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }

        // Prosta sanityzacja – uniknij separatorów ścieżek w nazwie katalogu
        let safeFolder = folderName
            .components(separatedBy: CharacterSet(charactersIn: "/:\\"))
            .joined(separator: "_")

        return base.appendingPathComponent(safeFolder, isDirectory: true)
    }

    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }

        // Upewnij się, że nazwa kończy się na .png
        let fileBase = imageName.hasSuffix(".png") ? imageName : imageName + ".png"
        return folderURL.appendingPathComponent(fileBase)
        // Jeśli celujesz w iOS 16+: return folderURL.appendingPathComponent(fileBase, conformingTo: .png)
    }

}
