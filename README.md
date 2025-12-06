# Simple CLAP implementation with Godot and OpenCV

The process is divided into two different applications: the Godot Application and the OpenCV Application. The Godot application and OpenCV application exchange data using the OS’s filesystem. The two Godot Application has two major “spaces” that need to be built: the U.I.-Space you can use to view/operate the controls (and hopefully change them) and select which scene you want to use for screenshots.  
  Then there are the scenes themselves where you’re asked to determine the screenshot interval time and start recording. These screenshots are used in the second application, the OpenCV application. The OpenCV application is where the bulk of the work is done.  
  It will input the screenshots of the OpenCV project and process the images using SIFT, FLANN Matching, and k-means. Outputting a file containing a list of translation vectors.


## Set-up
### Godot Set-up
Download [Godot ](https://godotengine.org/download/archive/) - version 4.5.1, which is the latest at the time of starting this project.  
Launch Godot and simply import the godot_src directory as a project.  
  
### OpenCV Set-up
Currently I will only be including a Windows instructions for set-up mostly due to the seeming  
neccessity of the Visual Studio 2022 x64 compiler for building OpenCV cmake projects. Unfortunately due to how OpenCV pre-compiled releases are done, this project will only work on Windows.

### Windows Set-up for OpenCV with VSCode
Download and install [OpenCV](https://code.visualstudio.com/download)'s Windows Release, for this project I used 4.12.  
You will need to include your own .env file in the opencv_src directory.  
Insert the following in your .env :
```
OpenCV_DIR={opencv/build directory}

example:
OpenCV_DIR=C:/opencv/build
```
You will also need to install [VSCode](https://code.visualstudio.com/download)  
  
Install these extensions in VSCode:  
* C/C++
* CMake Tools

  
Although this project is built in VSCode we will need to install [VS Studio](https://visualstudio.microsoft.com/downloads/) for the compiler.  
  
_Note: As of writing this, Visual Studio Community has updated to 2026 which is not compatible with OpenCV 4.12, you will have to find a Visual Studio 2022 Community installer._


Open up opencv_src in VSCode and type:
```
> CMake: Quick Start
```
Since a CMakeList.txt file already exists it will ask for a preset.  
  
Select _Add an New Preset_  then choose _Create from Compilers_.  
After choose the _Visual Studio Community 2022 Release - x86_amd64_ compiler option.  
  

Then _Configure All Projects_ next to Project Outline under the CMake extension tab in VSCode.


## Building

### Build the OpenCV Project
If you followed the set up instuctions above simpily press the build button in the same Project Outline button tray next to Configure All Projects called Build All Projects.  
The executable will appear in out\build\Visual Studio Community 2022 Release - x86_amd64\Debug directory.

### Build the OpenCV Project
You can follow Godots offcal [Documentation](https://docs.godotengine.org/en/latest/tutorials/export/exporting_projects.html) for exporting Projects.

## Usage

The project is fairly simple to use:  

* Start the opencvclapgodot.exe program with both opencvclap.exe and opencvclapgodot.exe in the same directory.
* Choose a tileset resolution and the name of the "Scene" you want to save your execution data and sceenshot interval with 0.1 being the smallest and 1 second being the longest then start it.
* Move the camera around and then stop it once you have enough frames.
* The program will then launch the OpenCV program in an external shell along with a file explorer containing all you "Scene" data.
* Once the OpenCV program's finished executing the scene will reopen so you can look at the path

## References

### Original Paper

[A Generalization of CLAP from 3D Localization to Image Processing, A Connection With RANSAC & Hough Transforms](https://arxiv.org/abs/2509.13605v1)  
by Ruochen Hou, Gabriel I. Fernandez, Alex Xu, Dennis W. Hong
### Assets
[32 x 32 Sprites](https://michaelgames.itch.io/2d-action-adventure-rpg-assets) by Michael Games
[128 x 128 Sprites](https://schwarnhild.itch.io/basic-hand-drawn-tileset-and-asset-pack) by schwarnhild
