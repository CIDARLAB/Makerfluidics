$fn=100;

//Chip Variables
sideWallY = 1.0414;
channelX = 29.972;
channelY = 0.4318;
channelZ = 0.2032;
portD = 0.8128;
slideX = 57.404;
slideZ = 0.9906;

//Chip Maths
//PortZ = max(slideZ);
//SlideY = (max(sideWallY)*2)+max(channelY);      //should equal 2.54mm
MaxSlideY = (max(sideWallY)*2)+max(channelY);      //should equal 2.54mm

//Layout Variables
endMillD = 3.175;		      //1/8" end mill
chipCopies = 9;
buildAreaY = 114;
buildAreaX = 140;

//Layout Maths
Spacing = endMillD + 0.1;	      //0.1mm buffer for toolpath gen
ChipX = max(slideX) + Spacing;
ChipY = (MaxSlideY*2) + (Spacing*2);
BuildArea = buildAreaY * buildAreaX;
ChipArea = ChipX * ChipY;
MaxChipCopies = floor(BuildArea / ChipArea);
MaxXCopies = floor(buildAreaX / ChipX);
MaxYCopies = floor(buildAreaY / ChipY);
ChipCopies = chipCopies > MaxChipCopies ? MaxChipCopies : chipCopies;
XCopies = ChipCopies > MaxXCopies ? MaxXCopies : ChipCopies;
YCopies = ChipCopies > MaxXCopies ? (ChipCopies - MaxXCopies) : 0;

//Sweep Variables
modVariable = "channelY";
start = 1;
increment = 1;

//function steps(start, increment, copyNum) = [start : increment : start + (increment*(copyNum-1))];
//for (i = steps(startVal, inc, ChipCopies)){
  //SweepVarVec = concat(i, SweepVar);
  //echo(SweepVarVec);
//};

SweepVar = 0;
echo("chipCopies", chipCopies);
echo("MaxXCopies", MaxXCopies);
echo("MaxChipCopies", MaxChipCopies);
echo("XCopies", XCopies);
echo("MaxYCopies", MaxYCopies);
echo("YCopies", YCopies);
echo("ChipY", ChipY);
echo("ChipX", ChipX);
echo("maxX", max(chipCopies));
echo("MaxSlideY", max(MaxSlideY));
//echo("modVariable", modVariable);
//echo("SweepVar", SweepVar);
//echo("SweepVar[2]", SweepVar[2]);
