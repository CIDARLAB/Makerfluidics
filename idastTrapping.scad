include<idastConstants.scad>

//Uncomment to render
//Trap();

module Trap(){

  //Chip Geometries
  difference(){
    //Slide
    cube([slideX,SlideY,slideZ],center=false);
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
};
  
  
