void writePointFile() {
    PrintWriter writer = null;
    writer = createWriter(PointsFileName);
    for (int i=0; i<3; ++i) {
        writer.println(str(corners[i].x));
        writer.println(str(corners[i].y));
    }
    writer.flush();
    writer.close();
    println(PointsFileName + " was created.");
}

void readPointFile() {
    BufferedReader reader = null;
    reader = createReader(PointsFileName);
    String lineX, lineY;
    while(true) {
        try {
            lineX = reader.readLine();
            lineY = reader.readLine();
            int x = int(lineX);
            int y = int(lineY);
            corners[cornersSize++] = new Point(x, y);
            if (cornersSize == 3) {
                println("Points found from file");
                PointsExistFlag = true;
                calculateVecs();
                //                calculateDet();
                break;
            }
        } catch (Exception e) {
            println("No file named " + PointsFileName);
            break;
        }
    }
}
