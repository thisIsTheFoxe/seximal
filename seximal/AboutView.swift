//
//  AboutView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Seximal").bold() +
                            Text(" (also senary or heximal) is a numbering system that uses the number six as a base.")
                    }
                    .font(.title2)
                    .padding(.vertical)
                    Text("Most people are very familiar and use the decimal (base-10) numbering system. However, also binary (base-2) or hexadecimal (base-16) systems are used e.g. in computer science. Even in our daily lifes we can encounter different numbering systems, like the Roman numberal system on some clocks and base-60 when counting seconds and minutes.")
                    Text("Things that make a base distinct from others are:")
                    
                    Text("1. It's size").bold().padding([.leading, .top])
                    Text("The bigger a base, the fewer digits it requires to write larger numbers. But also the more distinct digits are there to remember. Scientists say that the human brain's short-term memory has a capacity of seven (plus/minus two).")
                    Text("2. It's factors").bold().padding([.leading, .top])
                    Text("A base can describe a franction as a terminating string if it is a comosition of it's prime factors. E.g. decimal has the primefactors one and five, therefore fractions like a half, a fifth, or a tenth (2 * 5) can be represented with only a few digits. On the other hand, 1/3 needs to be described as 0,3333333... recurring. So, the more prime factors a base has, the more terminating fractions it has.")
                }
                .padding(.horizontal)
                Divider().padding().padding(.horizontal, 36)
                VStack(alignment: .leading) {
                    Text("Seximal has a smaller base than decimal, making simple arithmitic easier. It also has the prime factors two and three, which means that halfs and thirds and any combination of them have terminating fractions. Additionally, each human can normally show zero to five fingers on one hand, making it possible to count up to thirty six (or nif) using both hands.")
                    Text("However, since most measuremnts and units are based on the decimal system, if someone were to use seximal it would be quite confusing to keep using the same units with a different numbering system. Therfore, it makes sense to redefine common units for the use in seximal.")
                }
                .padding(.horizontal)
                Spacer(minLength: 25)
                Text("Resources")
                    .font(.subheadline)
                Link("Wikipedia", destination: URL(string: "https://en.wikipedia.org/wiki/Senary")!)
                    .padding(6)
                Link("seximal.net", destination: URL(string: "https://seximal.net")!)
                    .navigationTitle("About Seximal")
                    .padding(6)
                Spacer(minLength: 36)
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
