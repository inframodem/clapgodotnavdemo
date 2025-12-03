/* Project: Final project: SIFT Feature Matching
	Student: Alexander Peterson
   File: Main.cpp
   Date: 10/26/2025
   Description: This program performs SIFT Keypoint Matching on two images of kittens and matches features between the two using brute force.
*/
#include <iostream>
#include "windows.h"
#include <algorithm>
#include <string>
//It was Today I learned that all OpenCV offical releases are compiled with c++98/03
//Rip cross platform filesystems

#include <opencv2/features2d.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "PhotoMatcher.h"

using namespace cv;
using namespace std;

/* This was just boiler plate coode to get a sorted list of png file names
*/

int extract_number(const std::string& filename) {
    // find last '-' (test1-0.png → '-0.png')
    std::string::size_type dash = filename.rfind('-');
    if (dash == std::string::npos)
        return -1;

    // find the '.' after the dash
    std::string::size_type dot = filename.find('.', dash);
    if (dot == std::string::npos)
        return -1;

    // substring containing the digits
    std::string num = filename.substr(dash + 1, dot - (dash + 1));

    return atoi(num.c_str());
}

bool numeric_png_compare(const std::string& a, const std::string& b) {
    int na = extract_number(a);
    int nb = extract_number(b);
    return na < nb;
}

void loadPhotoPaths(const string& dirPath, vector<string>& pathstrs, vector<string>& fileNames){
    DWORD attributes = GetFileAttributesA(dirPath.c_str());
    if (attributes == INVALID_FILE_ATTRIBUTES) {
        return;
    }

    char endingSlash = '/';
    size_t found = dirPath.find('\\');
    if(found != string::npos){
        endingSlash = '\\';
    }


    string searchPath = dirPath;
    if (!searchPath.empty() && searchPath[searchPath.size() - 1] != endingSlash){
        searchPath += endingSlash;
    }
    searchPath += "*.png";

    WIN32_FIND_DATAA fdata;
    HANDLE seachhandle = FindFirstFileA(searchPath.c_str(), &fdata);

    if (seachhandle == INVALID_HANDLE_VALUE){
        return;
    }

    do{
        if (!(fdata.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
            fileNames.push_back(fdata.cFileName);
        }
    }while(FindNextFileA(seachhandle, &fdata));

    FindClose(seachhandle);

    sort(fileNames.begin(), fileNames.end(), numeric_png_compare);
    for(string file : fileNames){
        if(dirPath[dirPath.size() - 1] != endingSlash){
            pathstrs.push_back(dirPath + endingSlash + file);

        }
        else{
            pathstrs.push_back(dirPath + file);
        }
    }
}

int main(int, char**){

    //Sanity Test
	std::cout << "This OpenCV program is running on OpenCV Version "<< CV_VERSION << endl;
    //Debug Inputs
    //Godot's distance measurement is explicitly pixels so a scaling input is not neccessary
    string dirPath = "C:/Users/algal/AppData/Roaming/Godot/app_userdata/OpenCV Project/test1/";
    string opmodeStr = "clap_ransac";
    int opmode = 3;

    if(opmodeStr == "clap_ransac"){
        opmode = 3;
    }
    else if(opmodeStr == "clap"){
        opmode = 1;
    }
    else if(opmodeStr == "ransac"){
        opmode = 2;
    }
    else{
        cout << "Operation Mode String is Unsupported" << endl;
        return -1;
    }

    vector<string> imagePaths;
    vector<string> imageFileNames;

    loadPhotoPaths(dirPath, imagePaths, imageFileNames);

    PhotoMatcher transCalc;
    transCalc.setOperationMode(opmode);

    transCalc.loadFilePaths(imagePaths);


}

