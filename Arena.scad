include <dnd_config.scad>

function arena_size_x (x) = (x) * rfield * sin(60); 
function arena_size_y (y) = (y) * rfield * sin(60) * (2*sin(60)); 

module field () {
    rotate([0,0,30]){
        difference() {
            cylinder(d = rfield + sfield, h = dfield, $fn = 6);
            translate([0,0,-0.1])
                cylinder(d = rfield - sfield, h = dfield + 0.2, $fn = 6);
        }
        translate([0,0, dfield]) rotate([180,0,0]) connector_w();
    }
}

module field_connector() {
    intersection() {
        difference() {
            cylinder(d = rfield + mify(sfield), h = mify(dfield), $fn = 6);
            translate([0,0,-0.1])
                cylinder(d = rfield - mify(sfield), h = mify(dfield) + 0.2, $fn = 6);
        }
        translate([0, -rfield, 0]) cube([rfield, 2*rfield, mify(dfield)]);
    }
}

module field_connector_w() {
    intersection() {
        difference() {
            cylinder(d = rfield + sfield, h = dfield, $fn = 6);
            translate([0,0,-0.1])
                cylinder(d = rfield - sfield, h = dfield + 0.2, $fn = 6);
        }
        translate([0, -rfield, 0]) cube([rfield, 2*rfield, dfield]);
    }
}

module arena (x, y) {
    a = rfield * sin(60);
    intersection() { 
        for(xnum = [0: x]) {
            for(ynum = [0: y]) {
                //translate([xnum * 15 * sin(60), ynum * 15, 0]) rotate([0,0,90]) field();
                xpos = xnum * rfield * sin(60);
                ypos = ynum * rfield * sin(60) * (2*sin(60));
                
                translate([xpos, ypos, 0]) field();
                translate([xpos + a*cos(60), ypos + a*sin(60), 0]) field();
            }
        }
        cube([arena_size_x(x), arena_size_y(y), dfield]);
    }
}

//arena(1,1);
//translate([0,0,-1]) color("red") cube([arena_size_x(5), arena_size_y(5), 1]);


//field_connector();