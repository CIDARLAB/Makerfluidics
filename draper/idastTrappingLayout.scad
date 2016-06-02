//include<idastTrappingPlusBonding.scad>
include<idastTrapping.scad>

//Uncomment to render
TrappingLayout();

module TrappingLayout(){
  //for (i = [0: MaxXCopies > chipCopies ? MaxXCopies : chipCopies]){
  for (i = [0:(XCopies-1)]){
    for (j = [0:(YCopies)]){
      translate([i * ChipX, j * ChipY, 0]){
	if ((i+1)+j*MaxXCopies <= (ChipCopies)){
	  if (modVariable != "0") {
	    if (modVariable == "channelY"){
	      //channelY = start + (increment*(i+(j*MaxXCopies)));
	      Trap();
	    }
	  }
	  else {
	    Trap();
	  }
	}
      }
    }
  }
};
