include<idastTrapping.scad>

//Uncomment to render
//TrapPlusBonding();

module TrapPlusBonding(){
  Trap();
  //Bonding Layer
  translate([0, SlideY+Spacing, 0]){
    cube([slideX, SlideY, slideZ], center=false);
  }
};
