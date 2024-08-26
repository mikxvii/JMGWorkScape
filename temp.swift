if searchText != ""{
    let foundHouses = searchTrie?.wordsWithPrefix(searchText) ?? []
    let itemsPerPage = 6
    let pages = Int(ceil(Double(foundHouses.count) / Double(itemsPerPage)))
    
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 35) {
            ForEach(1..<pages + 1, id: \.self) { page in
                VStack {
                    LazyVGrid(columns: numberColumns, spacing: 20) {
                        let housesArray = pullItems(foundHouses)
                        ForEach(housesArray, id: \.self) { item in
                            ZStack {
                                Button(action: {
                                    if !longPressDetected {
                                        selectedHouse = item
                                        goToDetails = true
                                    }
                                }, label: {
                                    ZStack {
                                        if let imageData = item.getImg(), let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(40)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        } else {
                                            RoundedRectangle(cornerRadius: 40)
                                                .fill(gray)
                                                .frame(width: 150, height: 150)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        }
                                        VStack {
                                            Spacer()
                                            Text(item.getName())
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(darkOlive)
                                                .cornerRadius(15)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        }
                                        .padding(.bottom, 20)
                                    }
                                })
                                .simultaneousGesture(
                                    LongPressGesture().onEnded { _ in
                                        houseToDelete = item
                                        showAlert = true
                                        longPressDetected = true
                                    }
                                )
                                .simultaneousGesture(
                                    TapGesture().onEnded {
                                        longPressDetected = false
                                    }
                                )
                            }
                        }
                    }
                    .frame(width: 361)
                    Spacer() // Need this spacer so when page isn't full of items, it starts on top
                }
            }
        }
        .scrollTargetLayout()
    }
    .padding(.top, 20)
    .scrollClipDisabled()
    .scrollTargetBehavior(.viewAligned)
}
else{
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 35) {
            ForEach(1..<pages + 1, id: \.self) { page in
                let housesArray = getItems(for: page, itemsPerPage: itemsPerPage)
                VStack {
                    LazyVGrid(columns: numberColumns, spacing: 20) {
                        ForEach(housesArray, id: \.self) { item in
                            ZStack {
                                Button(action: {
                                    if !longPressDetected {
                                        selectedHouse = item
                                        goToDetails = true
                                    }
                                }, label: {
                                    ZStack {
                                        if let imageData = item.getImg(), let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(40)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        } else {
                                            RoundedRectangle(cornerRadius: 40)
                                                .fill(gray)
                                                .frame(width: 150, height: 150)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        }
                                        VStack {
                                            Spacer()
                                            Text(item.getName())
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(darkOlive)
                                                .cornerRadius(15)
                                                .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                        }
                                        .padding(.bottom, 20)
                                    }
                                })
                                .simultaneousGesture(
                                    LongPressGesture().onEnded { _ in
                                        houseToDelete = item
                                        showAlert = true
                                        longPressDetected = true
                                    }
                                )
                                .simultaneousGesture(
                                    TapGesture().onEnded {
                                        longPressDetected = false
                                    }
                                )
                            }
                        }
                    }
                    .frame(width: 361)
                    Spacer() // Need this spacer so when page isn't full of items, it starts on top
                }
            }
        }
        .scrollTargetLayout()
    }
    .padding(.top, 20)
    .scrollClipDisabled()
    .scrollTargetBehavior(.viewAligned)
}