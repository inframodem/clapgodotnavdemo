#include "PhotoMatcher.h"
#include <opencv2/features2d.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/calib3d.hpp>
#include <utility>
#include <iostream>
#include <cmath>

PhotoMatcher::PhotoMatcher(){

}

bool PhotoMatcher::loadFilePaths(const vector<string>& paths){
    if(paths.size() <= 1){
        return false;
    }
    CLAPTranslationVects.clear();
    RANSACTranslationVects.clear();
    CalculateTranslations(paths);
    return true;
}

void PhotoMatcher::CalculateTranslations(const vector<string>& paths){

    CLAPTranslationVects.clear();
    RANSACTranslationVects.clear();

    Mat imageOld = imread(paths[0], IMREAD_GRAYSCALE);
    Mat imageNew = imread(paths[1], IMREAD_GRAYSCALE);
    Ptr<SIFT> dectector = SIFT::create();

    vector<KeyPoint> keypointsOld, keypointsNew;
    Mat desciptorOld, descriptorNew;
    dectector->detectAndCompute(imageOld, noArray(), keypointsOld, desciptorOld);

    for(int i = 2; i <= paths.size(); i++){

        dectector->detectAndCompute(imageNew, noArray(), keypointsNew, descriptorNew);

        FlannBasedMatcher matcher;

        std::vector<std::vector<DMatch>> knn_matches;

        matcher.knnMatch(descriptorNew, desciptorOld, knn_matches, 2);

        std::vector<DMatch> good_matches;
        const float ratio_thresh = 0.70f;

        for (size_t i = 0; i < knn_matches.size(); i++) {
            if (knn_matches[i].size() < 2) continue; // skip if not enough matches
                const DMatch &best = knn_matches[i][0];
                const DMatch &second_best = knn_matches[i][1];

            if (best.distance < ratio_thresh * second_best.distance) {
                good_matches.push_back(best);
            }
        }

        vector<Point2f> pointsold, pointsnew;
        for(const auto& match : good_matches) {
            pointsold.push_back(keypointsOld[match.trainIdx].pt); // point in image 1
            pointsnew.push_back(keypointsNew[match.queryIdx].pt); // corresponding point in image 2
        } 

        if(operationMode == 2 || operationMode == 3){
            Point2d transpt = ransacTranslateFinder(pointsnew, pointsold);
            RANSACTranslationVects.push_back(transpt);
            cout << "Images: " << i - 2 << " and " << i - 1 << " finished Processing using RANSAC." << endl;
        }
        if(operationMode == 1 || operationMode == 3){
            Point2d transpt = clapTranslateFinder(pointsnew, pointsold);
            CLAPTranslationVects.push_back(transpt);
            cout << "Images: " << i - 2 << " and " << i - 1 << " finished Processing using CLAP." << endl;
        }
        /*
        namedWindow("Good Matches");
        Mat img_matches;
        drawMatches(imageNew, keypointsNew, imageOld, keypointsOld, good_matches, img_matches);
        cv::Mat big;
        cv::resize(img_matches, big, cv::Size(), 2.0, 2.0, cv::INTER_NEAREST); // 4× scale
        imshow("Good Matches", big);
        waitKey(0);
        */
       if(i < paths.size()){
            imageOld = move(imageNew);
            keypointsOld = move(keypointsNew);
            desciptorOld = move(descriptorNew);
            imageNew = imread(paths[i], IMREAD_GRAYSCALE);
        }
    }


}

Point2d PhotoMatcher::clapTranslateFinder(vector<Point2f>& pointsnew, vector<Point2f>& pointsold){
    vector<Point2f> diffpoints(pointsnew.size());
    for (int i = 0; i < pointsnew.size(); i++){
        Point2f diff = pointsold[i] - pointsnew[i];
        diffpoints[i] = diff;
    }

    Mat clusterData(diffpoints.size(), 2, CV_32F);
    Point2d retpoint(0.0, 0.0);
    if(diffpoints.size() <= 1){
        return retpoint;
    }
    Mat labels, centers;
    
    for(int reps = 0 ; reps < 5; reps++){

        for(int i = 0; i < diffpoints.size(); i++){
            clusterData.at<float>(i, 0) = diffpoints[i].x;
            clusterData.at<float>(i, 1) = diffpoints[i].y;
        }
        kmeans(clusterData, 1, labels, TermCriteria(TermCriteria::EPS + TermCriteria::MAX_ITER, 50, 0.1), 3, KMEANS_PP_CENTERS, centers );
        vector<pair<float, Point2f>> distPairs;
        float centerX = centers.at<float>(0, 0);
        float centerY = centers.at<float>(0, 1);
        retpoint.x = round(centerX);
        retpoint.y = round(centerY);
        for(int i = 0; i < diffpoints.size(); i++){
            float dx = diffpoints[i].x - centerX;
            float dy = diffpoints[i].y - centerY;
            float dist = dx * dx + dy * dy;
            distPairs.push_back(make_pair(dist, diffpoints[i]));
        }
        if(diffpoints.size() > 2){
            int numToKeep = static_cast<int>(0.8f * diffpoints.size());
            sort(distPairs.begin(), distPairs.end(),
            [](const std::pair<float, Point2f> &a, const std::pair<float, Point2f> &b) {
                return a.first < b.first;
            });
            diffpoints.clear();
            for(int i = 0 ; i < numToKeep; i++){
                diffpoints.push_back(distPairs[i].second);
            }
        }

        clusterData = Mat(diffpoints.size(), 2, CV_32F);
        labels.release();
        centers.release();
    }


    return retpoint;
}

Point2d PhotoMatcher::ransacTranslateFinder(vector<Point2f>& pointsnew, vector<Point2f>& pointsold ){

    Point2d retpoint(0.0, 0.0);
    if(pointsnew.size() <= 3 || pointsold.size() <= 3){
        return retpoint;
    }
    Mat homography = findHomography(pointsnew, pointsold, RANSAC);
    double tx = 0.0;
    double ty = 0.0;
    if (!homography.empty()){
        tx = round(homography.at<double>(0,2));
        ty = round(homography.at<double>(1,2));
    }

    retpoint.x = tx;
    retpoint.y = ty;

    return retpoint;
}

void PhotoMatcher::setOperationMode(int opmode){
    operationMode = opmode;
}

vector<Point2d> PhotoMatcher::getCLAPTranslations(){
    return CLAPTranslationVects;
}

vector<Point2d> PhotoMatcher::getRANSACTranslations(){
    return RANSACTranslationVects;
}