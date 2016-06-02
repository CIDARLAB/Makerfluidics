include<idastConstants.scad>

//Uncomment to render
//Trap();

module Trap(sideWallYT=sideWallY,channelXT=channelX,channelYT=channelY,channelZT=channelZ,portDT=portD,slideXT=slideX,slideZT=slideZ){
PortZ = slideZ;
SlideY = (sideWallY*2)+(channelY);      //should equal 2.54mm

  //Chip Geometries
  difference(){
    //Slide
    cube([slideX,SlideY,slideZ-0.001],center=false);
    //Center Channel
    translate([(slideX-channelX)/2, sideWallY, (slideZ-channelZ)]){
      cube([channelX, channelY, channelZ],center=false);
    }
    //Left Port
    translate([(slideX-channelX)/2, SlideY/2, 0]){
      cylinder(d=portD, h=PortZ, center=false);
    }
    //Right Port
    translate([(slideX+channelX)/2, SlideY/2, 0]){
      cylinder(d=portD, h=slideZ, center=false);
    }
  };
  //Bonding Layer
  translate([0, SlideY+Spacing, 0]){
    cube([slideX, SlideY, slideZ], center=false);
  }
};
  
  
