//
//  MemeViewModel.swift
//  MemeTemp
//
//  Created by Ziad Alfakharany on 12/03/2023.
//

import Foundation
protocol MemeViewModelDelegate: AnyObject {
    func didFetch()
    func didFail(error: Error)
}

class MemeViewModel {
    
    private(set) var memes = [memeData]()
    
    weak var delegate: MemeViewModelDelegate?
    
    @MainActor
    func getMemes() {
        
        Task { [weak self] in
            
            do {
                let url = URL(string: "https://api.imgflip.com/get_memes")!
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let decoder = JSONDecoder()
                
                self?.memes = try decoder.decode(memeResponse.self, from: data).data.memes
                
                self?.delegate?.didFetch()
                
            } catch {
                
                self?.delegate?.didFail(error: error)
                
            }
            
            
        }
        
    }
}
