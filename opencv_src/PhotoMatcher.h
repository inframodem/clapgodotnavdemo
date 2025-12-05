
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
        PhotoMatcher();
        vector<Point2d> getCLAPTranslations();
        vector<Point2d> getRANSACTranslations();
        void setOperationMode(int opmode);
        bool loadFilePaths(const vector<string>& paths);
    
        private:
        vector<Point2d> CLAPTranslationVects;
        vector<Point2d> RANSACTranslationVects;
        int operationMode = 3;

        void CalculateTranslations(const vector<string>& paths);
        Point2d clapTranslateFinder(vector<Point2f>& pointsnew, vector<Point2f>& pointsold);
        Point2d ransacTranslateFinder(vector<Point2f>& pointsnew, vector<Point2f>& pointsold);

};

#endif