//
//  Constants.swift
//  Cute Animals
//
//  Created by Jaxson Mann on 2/2/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

struct Constants {
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    struct FlickrParamKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Text = "text"
        static let SafeSearch = "safe_search"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    struct FlickrParamValues {
        static let APIKey = "d5a3d1c5fb99be4a84d12a0e8552c6a6"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let PhotosMethod = "flickr.photos.search"
        static let Text = "cute+adorable+animals"
        static let SafeSearch = "1"
        static let MediumURL = "url_m"
    }
    
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
    }
    
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
