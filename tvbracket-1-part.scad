// Global parameters
circular_facets     = 20;

// VESA mount parameters
vesa_width          = 100;
vesa_height         = 100;
vesa_thickness      = 5; // Needs to allow for countersunk screws

// Overhang parameters
overhang_depth      = 20;
overhang_height     = 80;
overhang_thickness  = 5;

// Screw parameters
screw_gauge         = 4 + 1; // Add a bit extra for ease of fit
screw_head_diameter = 8;
screw_head_depth    = 2;  // The countersunk depth
screw_length        = 20; // Only for graphical representation

// Calculated parameters
width               = vesa_width + 20;
height              = vesa_height + 20;
overhang_width      = width;
vesa_offset         = (width - vesa_width)/2;

module vesa_mount() {

    difference() {

        // Things that exist
        union() {
            cube( size = [ width, vesa_thickness, height] );
            translate( v = [0, 0, height] ) {
                rotate( a = [270, 0, 0] ) {
                    cube( size = [width, overhang_thickness, vesa_thickness + overhang_depth + overhang_thickness] );
                }
            }
            translate( v = [0, vesa_thickness + overhang_depth, height - overhang_height] ) {
                cube( size = [ overhang_width, overhang_thickness, overhang_height] );
            }
        }

        // Things to be cut out
        union() {

            // Holes for VESA screws
            for (i = [
                        [vesa_offset, vesa_thickness + 0.01, vesa_offset],
                        [vesa_offset + vesa_width, vesa_thickness + 0.01, vesa_offset],
                        [vesa_offset + vesa_width, vesa_thickness + 0.01, vesa_offset + vesa_height],
                        [vesa_offset, vesa_thickness + 0.01, vesa_offset + vesa_height]
                     ] ) {
                translate( v = i ) {
                    rotate( a = [90, 0, 0] ) {
                        # countersunk_screw();
                    }
                }
            }

            // Holes for VESA screwdriver access
            for (i = [
                        [vesa_offset + vesa_width, vesa_thickness + overhang_depth + overhang_thickness + 0.1, vesa_offset + vesa_height],
                        [vesa_offset, vesa_thickness + overhang_depth + overhang_thickness + 0.1, vesa_offset + vesa_height]
                     ] ) {
                translate( v = i ) {
                    rotate( a = [90, 0, 0] ) {
                        # cylinder( r = screw_head_diameter * 0.75, h = overhang_thickness + 0.2, $fn = circular_facets);
                    }
                }
            }

            // Holes for wood screws
            for (i = [
                        [vesa_offset, vesa_thickness + overhang_depth + overhang_thickness + 0.1, height - overhang_height/2],
                        [vesa_offset + vesa_width, vesa_thickness + overhang_depth + overhang_thickness + 0.1, height - overhang_height/2]
                     ] ) {
                translate( v = i ) {
                    rotate( a = [90, 0, 0] ) {
                        # cylinder( r = screw_gauge/2, h = overhang_thickness, $fn = circular_facets);
                    }
                }
            }

        }
    }

}

module countersunk_screw() {

    union() {
        cylinder( r1 = screw_head_diameter/2, r2 = screw_gauge/2, h = screw_head_depth, $fn = circular_facets);
        cylinder( r = screw_gauge/2, h = screw_length, $fn = circular_facets);
    }
    
}

rotate( a = [0,270,0] ) vesa_mount();

