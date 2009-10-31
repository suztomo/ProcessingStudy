PFont DefaultFont;
ArrayList[] FontsBySize;

void createFonts() {
    PFont font = createFont("Osaka", 20);
    DefaultFont = font;
    textFont(font);
    FontsBySize = new ArrayList[5];
    String[] fontNames = {
        "Osaka",
        "AdobeFangsongStd-Regular",
        "DFKaiShu-SB-Estd-BF"
    };

    for (int fs = 20, i=0; fs <= 40; fs += 5, ++i) {
        ArrayList pf = new ArrayList();
        for (int j = 0; j < fontNames.length; ++j) {
            font = createFont(fontNames[j], fs);
            pf.add(font);
            println("Created font : " + fontNames[j] + "-" + str(fs));
        }
        FontsBySize[i] = pf;
    }
}


PFont selectFont(String message) {
    return DefaultFont;
}

