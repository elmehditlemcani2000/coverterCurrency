//
//  ViewController.swift
//  coverterCurrency
//
//  Created by user on 17/06/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    
    //proprietà
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchJSON()
        textField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    @objc func updateViews(input:Double){
        guard let ammountText = textField.text, let theAmmountText = Double(ammountText) else {return}
        if textField.text != "" {
            let total = theAmmountText * activeCurrency
            label.text = String(format: "%.2F", total)
                
        }
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
        
    }
    // metodo che richiama l'api
    func fetchJSON() {
    guard let url = URL(string:"https://open.er-api.com/v6/latest") else { return }
        URLSession.shared.dataTask(with: url) { (data,response, error) in
            //gestione errori
            if error != nil {
                print(error!)
                return
            
        }
        //scartare i dati in sicurezza
        guard let safeData = data  else  { return }
        
        //decodifica del JSON data
        do {
            let results = try JSONDecoder().decode(ExchangeRates.self,from:safeData)
            self.currencyCode.append(contentsOf: results.rates.keys)
            self.values.append(contentsOf: results.rates.values)
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        } catch {
            print(error)
        }
        
    }.resume()


}

}

