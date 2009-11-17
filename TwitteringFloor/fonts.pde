PFont DefaultFont;
ArrayList[] FontsBySize;

PFont getFontSizeof(int s) {
    if (s < 0) s = 0;
    if (s >= FontsBySize.length) {
        s = FontsBySize.length-1;
    }
    ArrayList fonts = FontsBySize[s];
    if (fonts == null) {
        println("DefaultFont because s : " + str(s));
        return DefaultFont;
    }
    return (PFont)(fonts.get(int(random(0, fonts.size()))));
}

String[] installedFontList;

Boolean fontIsInstalled(String fontName) {
  for (int i=0; i<installedFontList.length; ++i) {
    if (fontName.equals(installedFontList[i])) {
      
      return true;
    } else {
      if (fontName.equals("HGPKyokashotai")) {
        println("HGPKoykashotai : " + installedFontList[i]);
      }

    }
  }
  return false;
}

void createFonts() {
    PFont font;
    DefaultFont = createFont("Osaka", 20);
    textFont(DefaultFont);
    installedFontList = DefaultFont.list();
    FontsBySize = new ArrayList[4];
    String[] fontNames = {
        /* for Win */
        "Osaka",
        "HG教科書体",
        "HG創英角ｺﾞｼｯｸUB",
        "HGS行書体",
/*        "HG創英角ﾎﾟｯﾌﾟ体",*/
        "HG丸ｺﾞｼｯｸM-PRO",
        /* for Mac */
        "AdobeFangsongStd-Regular",
        "DFKaiShu-SB-Estd-BF",
        "STKaiti",
        "HiraMaruPro",
        "HiraKakuStd",
        "GB18030Bitmap",
        /*        "MS-Gothc"*/
    };

    /*
      20, 25, ... 45, 50
     */
    int fs = 20;
    for (int i=0; i < FontsBySize.length; fs+=10, ++i) {
        ArrayList pf = new ArrayList();
        for (int j = 0; j < fontNames.length; ++j) {
            String fontName = fontNames[j];
            if (fontIsInstalled(fontName)) {
                font = createFont(fontName, fs, true);
                pf.add(font);
                println("Created font : " + fontNames[j] + "-" + str(fs));
            } else {
              println("Failed to create font: " + fontName);
            }
        }
        FontsBySize[i] = pf;
    }
}


PFont selectFont(String message) {
    if (FontsBySize == null) {
        println("FontsBySize is null, use DefaultFont");
        return DefaultFont;
    }
    int size_max = FontsBySize.length;
    int size_index = int(random(0, size_max));
    ArrayList pf = (ArrayList) FontsBySize[size_index];
    if (pf == null) {
        return DefaultFont;
    }
    int kind_max = pf.size();
    int kind_index = int(random(0, kind_max));
    PFont font = (PFont) pf.get(kind_index);
    if (font == null) {
      println("selectFont failed (size_index, kind_index) = " + str(size_index) + ", " + str(kind_index));
      font = DefaultFont; 
    }
    return font;
}

// strとwidthは予約語かも、ローカルなので問題はないと思う
String foldMessage(String str, int width, PFont font){
  return foldMessage(str, width, font, false);
}

String foldMessage(String str, int width, PFont font, boolean printDebug){
  String _str = new String();
  textFont(font);
  int pointer = 0;
  for(int i=0; i<str.length(); ++i){
    // pointer ~ i文字目でwidthを超えるかどうかをチェックする
    if( textWidth(str.substring(pointer, i+1)) > width ){
      // 最後の文字なら無視
      //if(i+1==str.length()){ break; }
      // 改行した場合の行頭の文字を見る
      char c = str.charAt(i);
      switch(c){
        // 行頭がスペース/タブ/改行の場合、その文字を無視するためpointerを1つ進める
        case ' ':
        case '　':
        case '\t':
        case '\n':
          if(printDebug){ print("スペース/タブ/改行の場合、"); }
          _str += str.substring(pointer, i) + "\n";
          pointer = i+1;
          break;
        // 行頭が句読点の場合、句読点を行末に移動させる
        case '、':
        case '。':
        case '!':
        case '！':
        case '?':
        case '？':
          if(printDebug){ print("句読点の場合、"); }
          _str += str.substring(pointer, i+1) + "\n";
          pointer = i+1;
          break;
        default:
          // 英数字の場合
          if(33<=c && c<=126){
            if(printDebug){ print("英数字だよ、"); }
            for(int j=i-1; j>=max(i-4, 0); --j){
              if(33<=str.charAt(j) && str.charAt(j)<=126){
                if(j==max(i-4,0)){
                  _str += str.substring(pointer, i) + "\n";
                  pointer = i;
                }
              }
              else{
                _str += str.substring(pointer, j+1) + "\n";
               pointer = j+1;
               break;
              }
            }
          }
          // 通常の改行
          else{
            _str += str.substring(pointer, i) + "\n";
            pointer = i;
          }
          break;
      }
    }
  }
  _str += str.substring(pointer, str.length());
  if(printDebug){ println(); }
  
  /*
  String _str = new String();
  int pointer = 0;
  for(int i=1; i<=str.length(); ++i){
    if( textWidth(str.substring(pointer, i)) > width ){
      _str += str.substring(pointer, i-1) + "\n";
      pointer = i-1;
    }
  }
  _str += str.substring(pointer, str.length());
  */
  return _str;
}


Point textPointDiff(String str, PFont font) {
    Point p = new Point(0, 0);
    textFont(font);
    int w = int(textWidth(str));
    int h = 200;
    p.x -= w/2;
    p.y -= h;
    return p;
}

