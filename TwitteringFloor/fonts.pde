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
        "DFKaiShu-SB-Estd-BF",
        /*        "MS-Gothc"*/
    };

    /*
      20, 25, ... 45, 50
     */
    for (int fs = 20, i=0; fs <= 50; fs += 10, ++i) {
        ArrayList pf = new ArrayList();
        for (int j = 0; j < fontNames.length; ++j) {
            font = createFont(fontNames[j], fs, true);
            pf.add(font);
            println("Created font : " + fontNames[j] + "-" + str(fs));
        }
        FontsBySize[i] = pf;
    }
}


PFont selectFont(String message) {
    int size_max = FontsBySize.length;
    int size_index = int(random(0, size_max));
    ArrayList pf = (ArrayList) FontsBySize[size_index];
    if (pf == null) {
        return DefaultFont;
    }
    int kind_max = pf.size();
    int kind_index = int(random(0, kind_max));
    PFont font = (PFont) pf.get(kind_index);
    return font;
}

String foldMessage(String message) {
    String ret = "";
    int len = message.length();
    ArrayList is = new ArrayList();
    println(len);
    for (int i=0; i<len-3; ++i) {
        char c = message.charAt(i);
        switch(c) {
        case ' ':
        case '\n':
        case '，':
        case '、':
        case '。':
            is.add(i);
        }
    }
    println(is.size());
    int prev_ret_pos = 0;
    int j=0;
    int isi = 0;
    for (int i=0; i<len; ++i) {
        if (i > isi && j < is.size()) {
            isi = (Integer)is.get(j++);
        } else if (i == isi && i - prev_ret_pos > 8) {
            ret = ret + message.substring(prev_ret_pos, i) + "\n";
            i++;
            prev_ret_pos = i;
        }
        ret = ret + message.substring(prev_ret_pos);
    }
    return ret;
}
