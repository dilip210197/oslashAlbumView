//
//  ViewController.swift
//  OSlashAlbumViewTask
//
//  Created by Dilip on 25/10/22.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var AlbumCollectionView: UICollectionView!
    
    var layoutDelegates = Layout()
    var responseData:albumData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
        self.AlbumApiHit()
    }

    private func setupView(){
        
        self.AlbumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        layoutDelegates.delegate = self
        
        self.AlbumCollectionView.delegate = self
        self.AlbumCollectionView.dataSource = self
        
        self.AlbumCollectionView.collectionViewLayout = layoutDelegates
        
    }
    
    private func AlbumApiHit(){

        let urlString = baseURL + APIName + paramInit + count + addParam + clientId
        print("url:",urlString)
        let url = URL(string: urlString)! //change the url
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as GET
        
        // add headers for the request
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print(response as? HTTPURLResponse as Any)
                print("Invalid Response received from the server")
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            DispatchQueue.main.async {
            do {
                // create json object from data or use JSONDecoder to convert to Model stuct
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String:Any]]{
                    print(json)
                    // handle json response
                    do{
                        self.responseData = try JSONDecoder().decode(albumData.self, from: responseData)
                        self.AlbumCollectionView.reloadData()
                    }
                    catch let error{
                        print(error)
                    }
                } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            }
        }
        task.resume()
    }
}


// Collection View
extension AlbumViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (self.responseData != nil) ? self.responseData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = AlbumCollectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath as IndexPath) as? AlbumCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        
        guard let data = self.responseData else{
            return cell
        }
        
        
        cell.AlbumImageView.imageFromServerURL(urlString: data[indexPath.row].urls.small)

        
        return cell
        
    }
    
    
}


//Layout Delegate Methods

extension AlbumViewController:LayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        (self.responseData != nil) ? CGFloat(Double(responseData[indexPath.row].height)*0.05) : 250
    }
    
    
}
