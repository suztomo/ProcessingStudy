void writePointFile() {
    PrintWriter writer = null;
    writer = createWriter(PointsFileName);
    if (corners.size() != 3) {
        println("Not three element");
    }
    for (int i=0; i<3; ++i) {
        writer.println(str(((Point)corners.get(i)).x));
        writer.println(str(((Point)corners.get(i)).y));
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
            corners.add(new Point(x, y));
            if (corners.size() == 3) {
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
