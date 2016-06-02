$fn=50;

h_channel = 0.5;
h_control_channel = 0.5;
w_channel = 0.5;
w_control_channel = 0.5;
h_upper_port = 0.3;
d_lower_port_top = 1.65;
d_lower_port_bottom = 1.1;
d_upper_port_top = 2.2;
d_upper_port_bottom = d_lower_port_top;
d_M3_nut = 7; //6.7
h_M3_nut = 1.5;
d_M3_screw=3.1;
wall_thickness= 2.5;
//w_valve_barrier = w_channel/2;
w_valve_barrier = w_channel/2;
d_tap1032 = 4.04;

w_segment_thickness = 3;
l_segment_thickness = 3.5;
d_valve = 2;


//glass slide dimensions
w_slide = w_segment_thickness*6;
l_slide = l_segment_thickness*7;
h_slide = 5.55;

echo("y", w_slide + w_slide-2*w_segment_thickness);
echo("x", l_slide*3 +5*2);

module transposer_flow(){
difference() {
  //slide dimensions
  cube([l_slide, w_slide, h_slide-0.001], center = false);
  flow_half();
  translate([l_slide, w_slide, 0])
    rotate([0,0,180])flow_half();
  }
}

module pass_thru_top(){
  difference() {
    cube([l_slide, w_slide-2*w_segment_thickness, h_slide-0.001], center=false);
    translate([0, 3*w_segment_thickness-w_channel/2, h_slide-h_channel]){
      cube([l_slide, w_channel, h_channel], center=false);
    }
  }
}

module pass_thru_bottom(){
  difference() {
    cube([l_slide, w_slide-2*w_segment_thickness, h_slide-0.001], center=false);
    translate([0, w_segment_thickness-w_channel/2, h_slide-h_channel]){
      cube([l_slide, w_channel, h_channel], center=false);
    }
  }
}

module control_blank(){
  translate([0, 0, h_slide-h_control_channel+d_valve/2]){
    cube([l_slide, w_slide-2*w_segment_thickness, h_slide], center = false);
  }
}

module transposer_control(){
difference() {
  //slide dimensions
  translate([0, 0, h_slide-h_control_channel+d_valve/2]){
    cube([l_slide, w_slide, h_slide], center = false);
  }
  translate([0,0, d_valve/2-0.001]){
    mirrored_transposer_check();
  }
}
}


module valve_flow(){
  difference() {
    cylinder(d=d_valve, h=h_channel, center=false);
    translate([-w_valve_barrier/2,-d_valve/2,0]){
      cube([w_valve_barrier, d_valve, h_channel], center=false);
    }
  }  
}

module valve_control(){
  translate([0, -w_slide/4, 0]){
    cube([w_control_channel, w_slide/2, h_control_channel], center=true);
  }
  cylinder(d=d_valve, h=h_control_channel, center=true);
}

module flow_half(){
  //left groove
  translate([l_slide/2+w_channel/2-2*l_segment_thickness, w_slide/2+w_channel/2, h_slide-h_channel]){
    rotate([0,0,180])cube([w_channel, w_segment_thickness+w_channel/2-w_valve_barrier/2, h_channel], center=false);
    translate([-w_channel/2, -w_segment_thickness-w_channel/2, 0]){
      rotate([0,0,90])valve_flow();
      translate([w_channel/2, -w_valve_barrier/2, 0]){
    	rotate([0,0,180])cube([w_channel, w_segment_thickness+w_valve_barrier/2, h_channel], center=false);
      } 
    }
  }  
  //center groove
  translate([l_slide/2+w_channel/2, w_slide/2+w_channel, h_slide-h_channel]){
    rotate([0,0,180])cube([w_channel, w_segment_thickness+w_channel-w_valve_barrier/2, h_channel], center=false);
    translate([-w_channel/2, -w_segment_thickness-w_channel, 0]){
      rotate([0,0,90])valve_flow();
      translate([w_channel/2, -w_valve_barrier/2, 0]){
	rotate([0,0,180])cube([w_channel, w_segment_thickness+w_valve_barrier/2, h_channel], center=false);
	translate([-w_channel/2,-w_segment_thickness-w_valve_barrier/2,0]){
	  //#cube([3*l_segment_thickness, w_channel, h_channel], center=false); 
	  //extend transposer outside of slide
	  cube([l_slide/2, w_channel, h_channel], center=false); 
	  translate([0, w_channel, 0]){
	    rotate([0,0,180])cube([l_segment_thickness-w_valve_barrier/2, w_channel, h_channel], center=false);
	    translate([-l_segment_thickness,-w_channel/2,0]){
	      valve_flow();
	      translate([-w_valve_barrier/2,w_channel/2,0]){
		rotate([0,0,180])cube([l_segment_thickness-w_valve_barrier/2, w_channel, h_channel], center=false);	
		translate([-l_segment_thickness-w_valve_barrier/2+w_channel/2,0,0]){
		  rotate([0,0,180])cube([1.5*l_segment_thickness+0.001, w_channel, h_channel], center=false);	
		}
	      }
	    }
	  }
	}
      } 
    }
  }  
}

module control_half(){
  //left groove
  translate([l_slide/2-2*l_segment_thickness, w_slide/2-w_segment_thickness, h_slide-h_control_channel]){
    cylinder(d=d_valve, h=h_control_channel);
    translate([-l_segment_thickness, -w_control_channel/2,0]){
    }
  }  
  //center groove
  translate([l_slide/2, w_slide/2-w_segment_thickness, h_slide-h_control_channel]){
    cylinder(d=d_valve, h=h_control_channel);
    translate([-l_segment_thickness, -w_segment_thickness-w_valve_barrier+w_control_channel/2, 0]){
      cylinder(d=d_valve, h=h_control_channel);
    } 
  }  
}

module mirrored_transposer_check(){
  control_half();
  translate([l_slide, w_slide, 0]){
    rotate([0,0,180])control_half();
  }
  translate([l_slide/2-w_channel/2-2*l_segment_thickness, w_slide/2-w_channel/2, h_slide-h_channel]){
    cube([4*l_segment_thickness+w_channel, w_control_channel, h_control_channel], center=false);
  }
  translate([l_slide/2-3*l_segment_thickness, w_slide/2-w_segment_thickness-w_control_channel/2, h_slide-h_control_channel]){
    #cube([w_control_channel, 2*w_segment_thickness+w_control_channel, h_control_channel], center=false);
    cube([3*l_segment_thickness, w_control_channel, h_control_channel], center=false);
  } 
  translate([l_slide/2-3*l_segment_thickness, w_slide/2+w_segment_thickness-w_control_channel/2, h_slide-h_control_channel]){
    cube([5*l_segment_thickness, w_control_channel, h_control_channel], center=false);
  } 
  translate([l_slide/2-l_segment_thickness, w_slide/2-2*w_segment_thickness-d_valve/2-w_control_channel/2+w_valve_barrier, h_slide-h_control_channel]){
    cube([4*l_segment_thickness, w_control_channel, h_control_channel], center=false);
    translate([4*l_segment_thickness-w_control_channel,0,0]){
      #cube([w_control_channel, 4*w_segment_thickness+d_valve, h_control_channel], center=false); 
    } 
  } 
  translate([l_slide/2+l_segment_thickness, w_slide/2+2*w_segment_thickness+d_valve/2-w_control_channel/2-w_valve_barrier, h_slide-h_control_channel]){
    cube([2*l_segment_thickness, w_control_channel, h_control_channel], center=false);
  } 
}

module port_control(){
  translate([0,0,d_valve/2+1.275]){
    //cylinder(d2=d_upper_port_top, d1=d_lower_port_bottom, h=h_slide-h_control_channel, center=false);
    #cylinder(d = d_tap1032, h=h_slide, center=false);
  }
}

module port(){
  //cylinder(d1=d_upper_port_top, d2=d_lower_port_bottom, h=h_slide-h_channel, center=false);
  cylinder(d=d_tap1032, h=h_slide, center=false);
}

module flow_ports_diff(){
  translate([l_slide/2-3*l_segment_thickness+w_channel/2, w_slide/2-2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2+3*l_segment_thickness-w_channel/2, w_slide/2-2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2+3*l_segment_thickness-w_channel/2, w_slide/2+2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2-3*l_segment_thickness+w_channel/2, w_slide/2+2*w_segment_thickness, 0]){
    port();
  }
}

module flow_ports(){
difference() {
  //slide dimensions
  cube([l_slide, w_slide, h_slide], center = false);
  translate([l_slide/2-3*l_segment_thickness+w_channel/2, w_slide/2-2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2+3*l_segment_thickness-w_channel/2, w_slide/2-2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2+3*l_segment_thickness-w_channel/2, w_slide/2+2*w_segment_thickness, 0]){
    port();
  }
  translate([l_slide/2-3*l_segment_thickness+w_channel/2, w_slide/2+2*w_segment_thickness, 0]){
    port();
  }
  }
}

module control_ports_diff(){
//control ports
  translate([l_slide/2-3*l_segment_thickness+w_control_channel/2, w_slide/2, h_slide/2+d_valve/2]){
    port_control();
  }
  translate([l_slide/2+3*l_segment_thickness-w_control_channel/2, w_slide/2, h_slide/2+d_valve/2]){
    port_control();
  }
}

module control_ports(){
difference() {
  //slide dimensions
  translate([0, 0, h_slide-h_control_channel+d_valve/2]){
    cube([l_slide, w_slide, h_slide], center = false);
  }
//control ports
  translate([l_slide/2-3*l_segment_thickness+w_control_channel/2, w_slide/2, h_slide/2+d_valve/2]){
    port_control();
  }
  translate([l_slide/2+3*l_segment_thickness-w_control_channel/2, w_slide/2, h_slide/2+d_valve/2]){
    port_control();
  }
}
}

module port_test(){
  difference(){
    cube([l_slide, w_slide, h_slide], center=false);
    translate([l_slide/2,w_slide/2,0]){
      #port();
    }
    translate([l_slide/2,w_slide/4+w_control_channel/2,0]){
      port_control();
    }
    translate([0,w_slide/4,h_slide-h_control_channel]){
      #cube([l_slide, w_control_channel, h_control_channel]);
    }
  }
}

module threeInputs_flow(){
difference(){
union(){
  //end caps
  translate([-5,-4*w_segment_thickness,0]){
    cube([5, 10*w_segment_thickness, h_slide-0.001], center=false);
  }
  translate([3*l_slide,-4*w_segment_thickness,0]){
    cube([5, 10*w_segment_thickness, h_slide-0.001], center=false);
  }

  transposer_flow();

  translate([l_slide, 2*w_segment_thickness, 0]) {
    pass_thru_top();
  }

  translate([0, -4*w_segment_thickness, 0]) {
    pass_thru_bottom();
  }

  translate([2*l_slide, -4*w_segment_thickness, 0]) {
    pass_thru_bottom();
  }

  translate([l_slide, -4*w_segment_thickness, 0]){
    transposer_flow();
  }

  translate([2*l_slide, 0, 0]){
    transposer_flow();
  }
}
  translate([0,w_segment_thickness,0])port();
  translate([0,5*w_segment_thickness,0])port();
  translate([0,-3*w_segment_thickness,0])port();

  translate([3*l_slide,w_segment_thickness,0])port();
  translate([3*l_slide,5*w_segment_thickness,0])port();
  translate([3*l_slide,-3*w_segment_thickness,0])port();
}
}

module threeInputs_control(){
union(){
  translate([-5,-4*w_segment_thickness,h_slide-h_control_channel+d_valve/2]){
    cube([5, 10*w_segment_thickness, h_slide], center=false);
  }
  translate([3*l_slide,-4*w_segment_thickness,h_slide-h_control_channel+d_valve/2]){
    cube([5, 10*w_segment_thickness, h_slide], center=false);
  }

  difference(){
    transposer_control();
    control_ports_diff();
  }
  translate([l_slide, 2*w_segment_thickness, 0]) {
    control_blank();
  }

  translate([0, -4*w_segment_thickness, 0]) {
    control_blank();
  }

  translate([2*l_slide, -4*w_segment_thickness, 0]) {
    control_blank();
  }

  translate([l_slide, -4*w_segment_thickness, 0]){
  difference(){
    transposer_control();
    control_ports_diff();
  }
  }

  translate([2*l_slide, 0, 0]){

  difference(){
    transposer_control();
    control_ports_diff();
  }
  }
}
}

//threeInputs_control();
threeInputs_flow();
//#mirrored_transposer_check();
//flow_ports();
translate([21*l_segment_thickness, 15*w_segment_thickness, (h_slide-h_channel+d_valve/2)+h_slide]){
  rotate([0,180,0]){
  //control_ports();
  //transposer_control();
  threeInputs_control();
  } 
}
//port_test();
//valve_flow();
