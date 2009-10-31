void mouseClicked() {
    if (corners.size() >= 3){ return; }
    corners.add(new Point(mouseX, mouseY));
    if (corners.size() == 3) {
        /*
          For all points in the S which includes the four points,
          get the value (0.0 to 1.0) of the two components.
        */
        // calculateDet();
        PointsExistFlag = true;
        calculateVecs();
        writePointFile();
        opencv.remember();  // store the actual image in memory
    }
}

void keyPressed() {
    if (keyCode == ENTER || keyCode == RETURN) {
        resetPoints();
        PointsExistFlag = false;
    } else {
        opencv.remember();  // store the actual image in memory
    }
}
