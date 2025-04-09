include <dnd_config.scad>
x_box = 150;
y_box = 110;

sbox = 1;
ddice = 26;

// Basic modules
module magnet_holder () {
    translate([dmagnet/2+p_male + sbox, dmagnet/2+p_male + sbox, sbox])
        cylinder(h=hmagnet + p_male + 0.1, d=dmagnet + p_male);
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

module vanilla_box (x, y, z) {
    difference() {
        //cube([x,y,z]);
        minkowski() {
            cube([x,y,z-1]);
            cylinder(d=sbox, h=1);
        }
        translate([sbox, sbox, sbox]) cube([x - 2*sbox ,y -  2*sbox ,z - sbox + 0.01]);
    }
}
    
module box (x, y, z, bottom = false) {
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
            //add guide if it's not the last box
            if(!bottom) {
                translate([sbox, sbox, -sbox-hmagnet+p_male-0.01])
                    magnet_holder();
                translate([sbox, y - 3*sbox - dmagnet - p_male, -sbox-hmagnet+p_male-0.01])
                    magnet_holder();
                translate([x - 3*sbox - dmagnet - p_male, sbox, -sbox-hmagnet+p_male-0.01])
                    magnet_holder();
                translate([x - 3*sbox - dmagnet - p_male, y - 3*sbox - dmagnet - p_male, -sbox-hmagnet+p_male-0.01])
                    magnet_holder();
                translate([-1, y/2-2.5, z-3+0.1]) cube([1.5,5,3]);
            }
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
            translate([sbox, sbox, sbox-(hmagnet + p_male)])
                magnet_holder();
            translate([sbox, y - 3*sbox - dmagnet - p_male, sbox-(hmagnet + p_male)])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, sbox, sbox-(hmagnet + p_male)])
                magnet_holder();
            translate([x - 3*sbox - dmagnet - p_male, y - 3*sbox - dmagnet - p_male, sbox-(hmagnet + p_male)])
                magnet_holder();
            translate([x/2, y/2, 2*sbox - 0.5]) signature();
        }
    }
}

// Advanced modules 
module pen_holder (x, y, z){
    xc = x - 2*sbox; 
    yc = y - 2*sbox;
    zc = 2*z - 2*sbox;
    
    rcurv = 3;
    
    difference() {
        cube([x, y, z]);
        translate([rcurv + sbox, rcurv + sbox, rcurv + sbox])
            minkowski() {
                cube([xc - 2*rcurv, yc-2*rcurv, zc-rcurv]);
                sphere(r=rcurv);
            }
    }
}

// Boxes
module box_tools  (x, y) {
    height = 22;
    hf = 0.5;
    n_pens = 4;
    w_pens = 15;
    box(x, y, height);
    //pens
    difference() {
        for (i = [0:n_pens - 1]){
            translate([0, i*(w_pens-sbox), 0])
            pen_holder(x, w_pens, height * hf);
        }
        translate([25, w_pens/2, height * hf * hf]) cube ([10, 40, 10]);
    }  
    
    //dice
    y_base = n_pens*(w_pens-sbox);
    y_div = 1;
    difference() {
        translate([0, y_base, 0]) cube([x, 2*ddice + 2* sbox - y_div, height * hf]);
        union() { 
            // make a row with 4 dices
            // fdfdfdfdf
            // 5f+4d=x
            filling4 = (x - 4*(ddice + 2*sbox)) / 5;
            for (i = [0:3]){
                translate([(i+1) * filling4 + i * (ddice + 2*sbox) + ddice/2 + sbox, 2+y_base + ddice/2 + sbox, 0])
                cylinder(d=ddice, h=height+0.01, center=false);
            }
            
            // make a row with 3 dices
            // FdfdfdF
            // 3d+2f+2F=x
            filling3 = (x - 3*(ddice + 2*sbox) - 2 * filling4) / 2;
            for (i = [0:2]){
                translate([filling3 + i * (filling4 + ddice + 2*sbox) + ddice/2 + sbox, 2+y_base + ddice/2 - sbox + ddice - y_div, height*hf])
                //cylinder(d=ddice, h=height+0.01, center=false);
                scale([1,1,height/ddice])
                sphere(d=ddice);
            }
        }
    }
}

module box_notes  (x, y) {
    height = 35;
    box(x, y, height);
}
module box_minies (x, y) {
    height = 15;
    box(x, y, height);
    
    // TODO:
    // - bases for minies (see include <Arena.scad>)
}

//lit(x_box, y_box);
//box_tools(x_box, y_box); 
box_notes(x_box, y_box);
//box_minies(x_box, y_box);

// Box: 11x15cm
// x lit
// x Tools:  Stifte, Dices
// x Notes:  Notes, Quizes
// - Minies: Minies
// - Time:  Hourglass
// - 
// - 
// - 
// - 
