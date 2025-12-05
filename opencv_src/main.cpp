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

#include <fstream>

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

int main(int argc, char* argv[]){
    //Turns out the measurement in Godot is Pixels so it doesn't need scaling for distance

    if(argc != 3){
        cout << "Usage: Absolute_Path_to_Directory_of_name_Formated_PNGs Operation_Mode{clap, ransac, clap_ransac}" << endl;
        cout << "Press Enter to Close the Console" << endl;
        std::cin.get();
        return -1;
    }

    //Sanity Test
	std::cout << "This OpenCV program is running on OpenCV Version "<< CV_VERSION << endl;

    /*
    */
    //Godot's distance measurement is explicitly pixels so a scaling input is not neccessary
    string dirPath = argv[1];
    string opmodeStr = argv[2];
    int opmode = 3;
    //Debug Inputs
    //string opmodeStr = "clap_ransac";
    //string dirPath = "C:\\Users\\algal\\AppData\\Roaming\\Godot\\app_userdata\\OpenCV Project\\test3";

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

    if(imagePaths.size() <= 1 || imageFileNames.size() <= 1){
        cout << "Given Directory Contains to few properly formated PNGs" << endl;
        cout << "Press Enter to Close the Console" << endl;
        std::cin.get();
        return 0;
    }

    PhotoMatcher transCalc;
    transCalc.setOperationMode(opmode);
    transCalc.loadFilePaths(imagePaths);

    vector<Point2d> clapTrans = transCalc.getCLAPTranslations();
    vector<Point2d> ransacTrans = transCalc.getRANSACTranslations();

    string correctdPath = dirPath;

    char endingSlash = '/';
    size_t found = correctdPath.find('\\');
    if(found != string::npos){
        endingSlash = '\\';
    }

    if (!correctdPath.empty() && correctdPath[correctdPath.size() - 1] != endingSlash){
        correctdPath += endingSlash;
    }

    string dirName = correctdPath;


        // Remove trailing slashes
    while (!dirName.empty() && (dirName.back() == '/' || dirName.back() == '\\')) {
        dirName.pop_back();
    }
    
        // Find the last path separator
    int pos = dirName.find_last_of("/\\");

    if (pos != std::string::npos) {
        dirName = dirName.substr(pos + 1);  // Everything after the last separator
    }
    

    if(opmode == 1 || opmode == 3){
        ofstream outFile(correctdPath + dirName + "_CLAP.txt");
        for(int i = 1 ; i < imageFileNames.size(); i++){
            Point2d cPoint = clapTrans[i - 1];
            outFile << imageFileNames[i - 1] << " > " << imageFileNames[i] << " : " << cPoint.x << " " << cPoint.y << endl;
        }
        outFile.close();
    }

    if(opmode = 2 || opmode == 3){
        ofstream outFile(correctdPath + dirName + "_RANSAC.txt");
        for(int i = 1 ; i < imageFileNames.size(); i++){
            Point2d cPoint = ransacTrans[i - 1];
            outFile << imageFileNames[i - 1] << " > " << imageFileNames[i] << " : " << cPoint.x << " " << cPoint.y << endl;
        }
        outFile.close();
    }

    cout << "Press Enter to Close the Console" << endl;
    std::cin.get();
    return 0;
}

