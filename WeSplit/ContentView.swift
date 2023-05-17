//
//  ContentView.swift
//  WeSplit
//
//  Created by Thomas Phan on 2023-05-08.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numPeople = 0
    @State private var tipPercentage = 20
    @State private var useRedText = false
    @FocusState private var amountIsFocused: Bool
    
    var currencyFormatter: FloatingPointFormatStyle<Double>.Currency  {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    var totalPerPerson: Double  {
        // Calculate total per person
        let peopleCount = Double(numPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let total = tipValue + checkAmount
        let amtPerPerson = total / peopleCount
        
        return amtPerPerson
    }
    
    var grandTotal: Double {
        totalPerPerson * Double(numPeople + 2)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value : $checkAmount, format: currencyFormatter)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
               
                    Picker("Number of People", selection: $numPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text("\($0, format: .percent)")
                        }
                    }
                    .onChange(of: tipPercentage) { tip in
                        if tip == 0 {
                            useRedText = true
                        } else {
                            useRedText = false
                        }
                    }
                } header: {
                    Text("Choose a tip percentage")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyFormatter)
                } header: {
                    Text("Amount per person")
                }
                
                Section {
                    Text(grandTotal, format: currencyFormatter)
                        .foregroundColor(useRedText ? .red: .blue)
                } header: {
                    Text("Total check amount")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
