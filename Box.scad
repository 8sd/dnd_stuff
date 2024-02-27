include <dnd_config.scad>
include <Arena.scad>
sbox = 1;

module magnet_holder (h=0) {
    translate([dmagnet/2+p_male + sbox, dmagnet/2+p_male + sbox, sbox])
        cylinder(h=hmagnet + p_male + 0.01, d=dmagnet + p_male);
}
    
module magnet_holder_top () {
    rcontainer = 0.5*(dmagnet+p_male+2*sbox);
    hbase = 3;

    points = [
        [0,0,0],
        [0,rcontainer,0],
        [rcontainer,0,0],
        [rcontainer,rcontainer,0],
        [0,0,-hbase]
    ];

    faces = [
        [0,1,3,2],
        [0,4,1],
        [0,2,4],
        [1,4,3],
        [2,3,4]
    ];
    
    difference() {
        union () {
            translate([rcontainer, rcontainer, 0])
                cylinder(h=hmagnet + sbox + p_male, r=rcontainer);
            cube([2*rcontainer, rcontainer, hmagnet + sbox + p_male]);
            cube([rcontainer, 2*rcontainer, hmagnet + sbox + p_male]);
            //TODO: Add 3d print friendly base
            translate([rcontainer, rcontainer, -hbase])
                cylinder(h=hbase, r1=0, r2=rcontainer);
            translate([rcontainer, 0, 0])
                rotate([270,0,0]) 
                linear_extrude(height=rcontainer) 
                polygon([[0,0], [rcontainer,0], [0,hbase]]);
            translate([0, rcontainer, 0])
                rotate([0,90,0]) 
                linear_extrude(height=rcontainer) 
                polygon([[0,0], [hbase,0], [0,rcontainer]]);
            translate([0, 0, -hbase])
                cube([rcontainer,rcontainer,hbase]);
            translate([0, 0, -hbase])
                polyhedron(points=points, faces =faces);
        }
        //make space for magnet
        magnet_holder();
    }
}

module vanilla_box(x,y,z) {
    difference() {
        //cube([x,y,z]);
        minkowski() {
            cube([x,y,z-1]);
            cylinder(d=sbox, h=1);
        }
        translate([sbox, sbox, sbox]) cube([x - 2*sbox ,y -  2*sbox ,z - sbox + 0.01]);
    }
}
    
module box(x, y, z, bottom = false) {
    difference() {
        union () {
            vanilla_box(x,y,z);
    
            //add guide if it's not the last box
            if(!bottom) {
                translate([sbox + p_male, sbox + p_male, -sbox + p_male]) 
                    cube([x - p_male - 2*sbox, y - p_male - 2*sbox, sbox - p_male]);
            }
            
            //magnet stuff    
            translate([0,0,-sbox])
            rotate([0,0,0])
                translate([sbox, sbox, z - (hmagnet + sbox + p_male)])
                magnet_holder_top();
            translate([x,0,-sbox])
            rotate([0,0,90])
                translate([sbox, sbox, z - (hmagnet + sbox + p_male)])
                magnet_holder_top();
            translate([x,y,-sbox])
            rotate([0,0,180])
                translate([sbox, sbox, z - (hmagnet + sbox + p_male)])
                magnet_holder_top();
            translate([0,y,-sbox])
            rotate([0,0,270])
                translate([sbox, sbox, z - (hmagnet + sbox + p_male)])
                magnet_holder_top();
        }
        union () {
            translate([sbox, sbox, -sbox-hmagnet+p_male-0.01])
                magnet_holder();
            translate([sbox, y - 3*sbox - dmagnet - p_male, -sbox-hmagnet+p_male-0.01])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, sbox, -sbox-hmagnet+p_male-0.01])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, y - 3*sbox - dmagnet - p_male, -sbox-hmagnet+p_male-0.01])
                magnet_holder();
        }
    }
}

module lit (x, y) {
    difference() {
        union() {
            cube([x,y,sbox]);
            translate([sbox, sbox, sbox]) cube([x - 2*sbox ,y -  2*sbox , sbox]);
        }
        union () {
            translate([sbox, sbox, sbox])
                magnet_holder();
            translate([sbox, y - 3*sbox - dmagnet - p_male, sbox])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, sbox, sbox])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, y - 3*sbox - dmagnet - p_male, sbox])
                magnet_holder();
        }
    }
}


module pen_holder(x,y,z){
    xc = x -2*sbox; 
    yc = y -2*sbox;
    zc = 2*z -2*sbox;
    difference() {
        cube([x, y, z]);
        translate([yc*0.3 + sbox,yc*0.3 + sbox, yc*0.3 + sbox])
        minkowski() {
            cube([xc-yc*0.6, yc*0.4, zc-yc*0.6]);
            sphere(r=yc*0.3);
        }
    }
    
}
module connector_holder(y,z, n) {
    difference() {
        cube([rfield + 2*sbox,y,z]);
        union() {
            for (i = [0:n-1]){
                 translate([rfield/2 +sbox,i * rfield/3 + sbox,sbox]) scale([1,1,z/dfield]) rotate([0,0,90]) 
                    field_connector_w();
            }
            
            translate([(rfield + 2*sbox - 5)/2,sbox,sbox]) cube([5,y - 2* sbox,z]);
        }
    }
}

module dice_holder (y, z) {
    ddice = 20;
    xdelta = (2*ddice + sbox) * sin(60) * sin(60);
    echo(xdelta);
    difference() {
        cube([3*xdelta + ddice/2 - 2*sbox,y,z]);
        translate([ddice/2+sbox, ddice/2+sbox, 0])
        union() {
            for (i = [0:2]) {
                translate([i*xdelta, 0, 0]) cylinder(d=20, h=z+0.01);
                translate([(i+0.5)*xdelta, y-ddice-2*sbox, 0]) cylinder(d=20, h=z+0.01);
            }
        }
    }    
}
    
module box_figure (x, y) {
    //TODO
}

module box_area (x, y) {
    //TODO
}

module box_tools (x, y) {
    toolheight = 10;
    box(x, y, 25);
            
    // Pen stuff
    difference() {
        union() {
            translate([sbox,sbox,sbox])
                pen_holder(x -2*sbox, 15, toolheight);
            translate([sbox,15,sbox])
                pen_holder(x -2*sbox, 15, toolheight);
        }
        translate([sbox + 20, 15-0.5*sbox, 5]) cube([20, 2*sbox, y*0.7]);
    }
    
    // Connector stuff
    translate([sbox, 2*15, sbox])connector_holder(y-2*15-sbox,toolheight,$preview ? 2 : 6);
    
    //Dice stuff
    translate([rfield + 2*sbox, 2*15, sbox])dice_holder(y-2*15-sbox, toolheight);
}


xs = arena_size_x(13);
ys = arena_size_y(3);
echo(xs, ys);
//box_tools(xs, ys);
//magnet_holder_top();

//box(30, 15, 15);

