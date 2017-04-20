//include<idastTrappingPlusBonding.scad>
include<idastTrapping.scad>

//Uncomment to render
TrappingLayout();

module TrappingLayout(){
  //for (i = [0: MaxXCopies > chipCopies ? MaxXCopies : chipCopies]){
  for (i = [0:(XCopies-1)]){
    for (j = [0:(YCopies)]){
      //translate([i * ChipX, j * ChipY, 0]){
	if ((i+1)+j*MaxXCopies <= (ChipCopies)){
	  if (modVariable != "0") {
	    if (modVariable == "channelY"){
	      channelY = start + (increment*(i+(j*MaxXCopies)));
	      SlideY = (sideWallY*2)+(channelY);
	      ChipY = (SlideY*2);
	      translate([i * ChipX, j * (ChipY-(increment*((i-2)+(j*MaxXCopies)))), 0])Trap(channelY=channelY);
	    }
	  }
	  else {
	    translate([i * ChipX, j * ChipY, 0])Trap();
	    //Trap();
	  }
	}
      }
    //}
  }
};
