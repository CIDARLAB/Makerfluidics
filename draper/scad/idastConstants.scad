$fn=100;

//Chip Variables
sideWallY = 1.0414;
channelX = 50.8;
channelY = 0.430;
channelZ = 0.200;
portD = 0.8128;
slideX = 63.5;
slideZ = 1;
baseLineWidth = 2.54;
portNodeLength = 10;
trappingNodes = 8;		    //must be >=1
trappingNodeBlockY = baseLineWidth;
trappingNodeBlockX = baseLineWidth;
nodeSpacing = baseLineWidth;
kerfXSpacing = baseLineWidth;
kerfX = 0.25; 
kerfZ = 0.25;
chipY = baseLineWidth;
sidePortZ=0.7112;
sidePortY=0.6858;
sidePortX=2.032;
sidePortZBond = 0.2032;

wideChannelPortWidth = 0.5;
wideChannelTaperX = 5;

//Taguchi Variables
//Channel Width
wcLo = .300;
wcMed = .650;
wcHi = 1;

//Channel Height
hcLo = .075;
hcMed = .290;
hcHi = .5;

//Side Wall Width
wsLo = .5;
wsMed = .85;
wsHi = 1.2;

//Chip Maths
MaxSlideY = (sideWallY*2)+channelY;      //should equal 2.54mm


//Layout Variables
//endMillD = 3.175;		      //1/8" end mill
//endMillD = 2.38125;		      //3/32" end mill
endMillD = 0.79375;		      //1/32" end mill

chipCopies = 6;
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
//echo("chipCopies", chipCopies);
//echo("MaxXCopies", MaxXCopies);
//echo("MaxChipCopies", MaxChipCopies);
//echo("XCopies", XCopies);
//echo("MaxYCopies", MaxYCopies);
//echo("YCopies", YCopies);
//echo("ChipY", ChipY);
//echo("ChipX", ChipX);
//echo("maxX", max(chipCopies));
//echo("MaxSlideY", max(MaxSlideY));
//echo("modVariable", modVariable);
//echo("SweepVar", SweepVar);
//echo("SweepVar[2]", SweepVar[2]);
