//Parameters
  //Cube sizes to test
  zDepth = [0.01, 0.02, 0.03, 0.04, 0.05, 0.075, 0.1, 0.15, 0.2, 0.25, 0.5, 0.75, 1];  
  //End mill diameter 
  endMillD = 0.79375;  //1/32"
  //Stock and test piece definitions
  stockZ = 5.556;
  stockX = 20;
  //Spacing between depth tests
  spacing = 5; 

//Maths
  //Add 1mm to end mill diameter to space out replicates
  CutWidth = endMillD + 1;
  StockY = (((CutWidth)+spacing)*len(zDepth))+spacing;
  echo(StockY=StockY);
  
//uncomment to render
ZTestDevice();

//Module Definition
module ZTestDevice(){
  difference(){
    cube([stockX,StockY,stockZ], center=false);
    for(i = [0 : len(zDepth)-1]){
      let(YLocation = i*(CutWidth+spacing)){
	translate([0,YLocation+spacing,stockZ-zDepth[i]])cube([stockX,CutWidth,zDepth[i]], center=false);	
      }
    }
  }
}
