# Simple CLAP implementation with Godot and OpenCV

Basic description of your project.

## !!! - WARNING - !!!
THIS PROJECT IS NOT CLOSE TO BEING COMPLETE!  
  
This project is public so my professor can monitor my progress. I will be publishing my in-progress code in the "indev" branch  
which will be incomplete and will probably produce compile issues and other significant bugs.  
When confident main will be updated until proceed with caution.


## Set-up
### Godot Set-up
Download [Godot ](https://godotengine.org/download/archive/) - version 4.5.1, which is the latest at the time of starting this project.  
Launch Godot and simply import the godot_src directory as a project.  
  
### OpenCV Set-up
Currently I will only be including a Windows instructions for set-up mostly due to the seeming  
neccessity of the Visual Studio 2022 x64 compiler for building OpenCV cmake projects. I'll be looking into Linux compliment if there's time.

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
  
_Note: As of writing this, Visual Studio Community has updated to 2026 which is not compatible with OpenCV 4.12, you will have to find a Visual Studio 2022 Comunity installer._


Open up opencv_src in VSCode and type:
```
> CMake: Quick Start
```
Since a CMakeList.txt file already exists it will ask for a preset.  
  
Select _Add an New Preset_  then choose _Create from Compilers_.  
After choose the _Visual Studio Community 2022 Release - x86_amd64_ compiler option.  
  

Then _Configure All Projects_ next to Project Outline under the CMake extension tab in VSCode.


## Building

Building Instructions are not available right now.


## Releases
No Releases are available right now.

## Usage

Will fill out as the project has a proper release.

