include<idastConstants.scad>

//Uncomment to render
//Trap();

module Trap(sideWallYT=sideWallY,channelXT=channelX,channelYT=channelY,channelZT=channelZ,portDT=portD,slideXT=slideX,slideZT=slideZ, bond=1, port=1){
PortZ = slideZ;
SlideY = (sideWallY*2)+(channelY);      //should equal 2.54mm
ChipY = (SlideY*2) + (Spacing*2);

  //Chip Geometries
  difference(){
    //Slide
    cube([slideX,SlideY,slideZ-0.001],center=false);
    //Center Channel
    color("blue"){
      translate([(slideX-channelX)/2, sideWallY, (slideZ-channelZ)]){
	cube([channelX, channelY, channelZ],center=false);
      }
    }
    if (port == 1){
      //Left Port
      translate([(slideX-channelX)/2, SlideY/2, slideZ]){
	rotate([0,180,0])cylinder(d=portD, h=PortZ, center=false);
      }
      //Right Port
      translate([(slideX+channelX)/2, SlideY/2, slideZ]){
	rotate([0,180,0])cylinder(d=portD, h=PortZ, center=false);
      }
    }
  };
  //Bonding Layer
  if (bond == 1){
    translate([0, SlideY+Spacing, 0]){
      cube([slideX, SlideY, slideZ], center=false);
    }
  }
};
  
  
