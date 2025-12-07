/* Project: Final project: SIFT Feature Matching
	Student: Alexander Peterson
   File: PhotoMatcher.h
   Date: 11/26/2025
   Description: This program performs SIFT Keypoint Matching on two images of kittens and matches features between the two using brute force.
*/

#ifndef PHOTOMATCHER_H_
#define PHOTOMATCHER_H_

#include <opencv2/features2d.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include <tuple>
#include <vector>

using namespace std;
using namespace cv;
class PhotoMatcher {
    public:
        //Input: Empty Constructor
        //Output: Empty Constructor
        PhotoMatcher();
        //Input: Vector of filePaths
        //Output: Empty Constructor
        vector<Point2d> getCLAPTranslations();
        //Input: Vector of filePaths
        //Output: Sets Classes' CLAP and RANSAC Translation Vector
        vector<Point2d> getRANSACTranslations();
        //Input: INT representing operation mode
        //Output: Sets classes' operation mode
        void setOperationMode(int opmode);

        bool loadFilePaths(const vector<string>& paths);
    
        private:
        vector<Point2d> CLAPTranslationVects;
        vector<Point2d> RANSACTranslationVects;
        int operationMode = 3;

        //Input: Vector of filePaths
        //Output: Runs Calculations
        void CalculateTranslations(const vector<string>& paths);
        //Input: Vectors of new and old SIFT Points 
        //Output: Returns a point 2d with translation vector
        Point2d clapTranslateFinder(const vector<Point2f>& pointsnew, const vector<Point2f>& pointsold);
        //Input: Vectors of new and old SIFT Points
        //Output: Returns a point 2d with translation vector
        Point2d ransacTranslateFinder(const vector<Point2f>& pointsnew, const vector<Point2f>& pointsold);

};

#endif