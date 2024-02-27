// https://www.brixelweb.de/openscad/projekte/spielfigur.html
include <dnd_config.scad>;



module body (x,y) {
    scale([x,y,1]) {
        difference() {
            cylinder(h = 2/3 * hfigure, d1 = rfigure, d2 = rfigure/2, center = false);
            translate([0,0,-0.1])
                cylinder(h = 2/3 * hfigure + 1 , d1 = rfigure - 2, d2 = (rfigure/2) - 5, center = false); 
        }
        
        translate([0,0,0]) {
            // attachment
            
        }
    }
}

module head (c) {
    difference() {
        sphere(hfigure / 3);
        translate([0,0,2/3*hfigure]) cube(hfigure, center=true);
    }
    translate([0,0,1/6*hfigure]) linear_extrude(1) text(c, size=hfigure*.45, halign="center", valign="center");
}

module figur (x,y,c) {
        scale([x,y,1])
            body(x,y);
        translate([0,0, .75*hfigure]) head(c);
}

figur(1,2, "X");