#include <string>
#include <vector>
#include <fstream>
#include <string.h>
#include <iostream>
#include <cstdlib>
#include "processImage.h"

int main(int argc, char* argv[]) {
    std::ifstream rawFile;
    rawFile.open(argv[1], std::ios::binary);

    //get image dimensions
    uint16_t x_res = atoi(argv[3]);
    uint16_t y_res = atoi(argv[4]);

    //get sleep time
    uint16_t sleepTime = atoi(argv[5]);

    //get mac address
    std::string mac_address = argv[6];

    //allocate memory for image buffer
    uint8_t* image = (uint8_t*) malloc(x_res*y_res/8);

    //read image
    rawFile.read((char*) image, x_res*y_res/8);
    rawFile.close();

    //generate processed image
    std::vector<unsigned char> processed = processImage(image, sleepTime, x_res, y_res, mac_address);

    free(image);

    std::ofstream(argv[2], std::ios::binary).write((const char*) processed.data(), processed.size());
    return 0;
}
