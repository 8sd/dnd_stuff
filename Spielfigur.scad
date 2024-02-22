// https://www.brixelweb.de/openscad/projekte/spielfigur.html
include <dnd_config.scad>;

/*
module figur() {
    difference() {
        cylinder(h = hfigure, d1 = rfigure, d2 = rfigure/2, center = true);
        cylinder(h = hfigure + 1 , d1 = rfigure - 5, d2 = (rfigure/2) - 5, center = true); 
    }

    translate([0, 0, hfigure / 2])
    sphere(d = rfigure);
}

module figur_ohne_kopf() {
    difference() {
        figur();
        translate([0, 0, hfigure / 2 + (rfigure / 2) + 5])
        cube(rfigure, center=true); // +5 aus Stylegründen
    }
    translate([0,0,-5]) connector_m();
}

module beschriftung(c) {
    translate([0, 0, hfigure / 2 + 5])
    linear_extrude(3)
    text(c, size = rfigure / 1.41, halign = "center", valign = "center");
}

module beschriftere_figur(c) {
    translate([0,0,hfigure/2])
    union() {
        figur_ohne_kopf();
        beschriftung(c);
    }
}

module figuren_set (ids) {
    for (i = [0:len(ids)-1]) {
        translate([(i % 5) * (rfigure + 5), i / 5 * (rfigure + 5), 0])
        beschriftere_figur(ids[i]);
    }   
}

beschriftere_figur("c");

*/

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
        body(x,y);
        translate([0,0, .75*hfigure]) head(c);
}

figur(1,1,"X");