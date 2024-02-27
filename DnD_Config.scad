$fn = $preview ? 16 : 128;

rfield = 25;
sfield = rfield * 0.05;
dfield = rfield * 0.1;

dconnector = rfield * 0.6;
rconnector = dconnector / 2;
sconnector = rconnector * 0.1;
hconnector = rconnector * 0.2;

rfigure = rfield * 0.8;
hfigure = 20;

dmagnet = 5;
hmagnet = 1;

f_male = 1;
p_male = 0.2;

function mify(x) =  x * f_male - p_male;


module connector_m () {
    difference() {
        cylinder(d = rconnector + mify(sconnector), h = mify(dconnector), $fn = 6);
        translate([0,0,-0.1])
            cylinder(d = rconnector - mify(sconnector), h = mify(dconnector) + 0.2, $fn = 6);
    }
}

module connector_w () {
    difference() {
        cylinder(d = rconnector + sconnector, h = dconnector, $fn = 6);
        translate([0,0,-0.1])
            cylinder(d = rconnector - sconnector, h = dconnector + 0.2, $fn = 6);
    }
}
