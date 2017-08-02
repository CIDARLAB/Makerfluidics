# Image Processing Workflow

## Data Preparation 
1. If you have taken individual pictures using ImageJ, you will need to consolidate them into a single directory in order to make a stack in ImageJ.
  - **Windows:** Run fileMove.cmd.
    - Your file structure should be in the form of {root directory}\{frequency in MHz}MHz\Pos0\{imagej img number}.tif
    - Change the path in the first line of the script file to match that of your root directory
  - **OSX:** Run moveFiles
    - Your file structure should be in the form of {root directory}\{geometry name}\{file name}\Pos0\{imagej img number}.tif
      - {file name} may be any descriptive name for the image; the script will rename the image (ex., img\_0000000\_Default\_000.tif) to match {file name} (ex. {file name}.tif).
    - Change the name of the "geometry" variable to match your tested geometry
    - Run the script from {root directory} 
2. Using ImageJ, import all images in the consolidate folder (File --> Import --> Image Sequence)
3. Invert the images in the stack (Edit --> Invert)
4. Draw a line 300 units wide across the width of the channel
![draw line](https://github.com/CIDARLAB/Makerfluidics/tree/master/drawper/img/line.png)
5. Open stackToPlotData.txt in ImageJ (File --> Open)
6. Run the macro (Macros --> Run Macro)
7. Save the plot profile data as a csv (File --> Save As)

## Data Processing

### maxPeakAnalysis.m
- **Input:** Plot profile csv file from step 7 of Data Preparation
- **Output:** For each image in the stack, this script will find the maximum peak in the center fifth of the channel. Exports peak pixel intensity, location, prominence, $\chi$, and various plots
- **Unit Test File:** resultsBaseline\_3.csv

### noiseFilterPeakAnalysis.m
- **Input:** Plot profile csv file from step 7 of Data Preparation
- **Output:** For each image in the stack, this script will find all peaks in the center fifth of the channel above {stdDevCoef} standard deviations above the mean. It then exports all peak pixel intensities, locations, prominences, $chi$ values, and various plots.
