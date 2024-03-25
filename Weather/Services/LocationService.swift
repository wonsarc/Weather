//
//  LocationService.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import MapKit

final class LocationService {

    func cityFromCoordinates(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            if let city = placemark.locality {
                completion(city)
            } else {
                completion(nil)
            }
        }
    }

    func coordinatesFromCity(city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = city

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let mapItems = response?.mapItems, let firstItem = mapItems.first else {
                completion(nil)
                return
            }

            completion(firstItem.placemark.coordinate)
        }
    }
}
