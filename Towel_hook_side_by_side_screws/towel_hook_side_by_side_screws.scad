// =====================================================================
//  Towel hook for side-by-side wall holes (parametric, Customizer compatible)
//
//  Variant for two existing wall holes at the same height: the two screws
//  sit side by side (left and right), with a single centered hook.
//  If the holes are further apart than the hook is wide, the plate becomes
//  a rail: the hook slides in from one end to the center and is pinned
//  there. If the hook is wide enough to cover the plate, its channel has a
//  closed end instead and it hides the screws completely.
//
//  Mounting system: horizontal sliding dovetail.
//  1) PLATE: a wide, low plate screwed to the wall with 2 screws placed
//     side by side. Seen from the side it is
//     a trapezoid: its top and bottom edges are bevelled, so it is taller
//     at the front than at the back (wall side).
//  2) HOOK: seen from the side, a straight section, a bend and an arm
//     rising outwards. Its back has a channel with the plate's shape that
//     wraps the plate's top, bottom and front. It slides onto the plate
//     from one side until it hits the closed end on the other side (or,
//     on a long rail, until it reaches the center, where it is pinned).
//     Once fitted it cannot move away from the wall, up or down: the
//     plate is captured from above and below. Two printed pins, one from
//     underneath and one from the top, stop it from sliding sideways.
//     On the open side the plate ends flush with the hook, so no gap shows.
//  3) PINS: press-fit in the plate, loose in the hook. They have no head:
//     their outer end is cut to the hook's own surface (flat underneath,
//     sloped on top), so they sit flush and are practically invisible. A
//     flat side (D profile) keys them in a D-shaped hole in the hook, so
//     the sloped end always lines up with the surface. To take the hook
//     off, screw a small screw into a pin and pull it out.
//
//  Printing (no supports):
//    - Plate: back face (wall side) on the bed. Only the top and bottom
//             bevels are angled (45°, printable without supports).
//    - Hook:  lying on its closed side. The hook is a flat profile, so the
//             whole profile sits on the bed, the channel is an open pocket
//             facing up and the layers follow the arm (strongest option).
//    - Pins:  lying down on their flat side (D profile), so the layers run
//             along them and they are strong in shear.
//  part = "both" already lays them out this way.
// =====================================================================

/* [Part to generate] */
// Which part to export
part = "both"; // [both:All parts (print layout), plate:Plate only, hook:Hook only, pin:Pins only, assembled:Assembled view]

/* [Hook] */
// Total hook width (mm)
hook_width = 46; // [20:1:120]
// Hook thickness in front of the plate and along the arm, seen from the side (mm)
hook_thickness = 9; // [6:0.5:25]
// Length of the straight section against the wall (mm)
back_length = 55; // [35:1:160]
// Length of the rising section, excluding the bend (mm)
arm_length = 60; // [10:1:150]
// Tilt of the rising section from vertical (0 = straight up, 90 = horizontal)
arm_angle = 40; // [0:1:90]
// Inner bend radius (mm)
bend_radius = 8; // [0:1:60]

/* [Wall plate] */
// Side margin between the hook edge and the plate, per side, when the hook covers the plate (mm)
side_margin = 3; // [2:0.5:10]
// Plate material beyond each screw head (mm)
plate_end_margin = 4; // [2:0.5:20]
// Hook material above and below the plate (mm)
end_margin = 6; // [3:0.5:15]
// Plate thickness (mm)
plate_thickness = 6; // [4:0.5:12]
// Bevel angle of the plate's top and bottom edges, from horizontal (45 = printable without supports)
bevel_angle = 45; // [30:5:45]
// Clearance between plate and hook (mm)
fit_tolerance = 0.3; // [0:0.05:0.8]

/* [Screws] */
// Wall screw diameter / shank hole (mm)
screw_diameter = 4.5; // [2.5:0.1:6]
// Horizontal center-to-center distance between the wall holes (mm)
screw_spacing = 23; // [15:0.5:300]
// Head type
screw_head_type = "countersunk"; // [countersunk:Countersunk (90° cone), pan:Pan / flat (cylindrical counterbore)]
// Head diameter (0 = automatic, 2 × screw diameter) (mm)
screw_head_diameter = 0; // [0:0.1:12]
// Head height (pan/flat head only) (mm)
screw_head_height = 3; // [1.5:0.1:5]
// Extra head recess below the surface (mm)
head_recess = 0.5; // [0:0.1:2]

/* [Side lock] */
// What stops the hook sliding out sideways (from underneath)
lock_type = "pin"; // [pin:Printed pin, screw:Small self-tapping screw, none:None]
// Add a second printed pin from the top, flush with the hook's sloped surface
top_pin = true;
// Pin / screw diameter (mm)
lock_diameter = 3; // [2:0.5:4]
// How deep the pin / screw goes into the plate (mm)
lock_depth = 10; // [5:1:20]
// Pin fit in the plate: 0 = tight press fit; increase if it is too hard to push in (mm)
pin_fit = 0; // [-0.2:0.05:0.4]
// Pin clearance in the hook (mm)
pin_clearance = 0.4; // [0.1:0.05:0.8]

/* [Quality] */
// Curve resolution
$fn = 48; // [16:8:128]

/* [Hidden] */
eps = 0.01;
tan_b = tan(bevel_angle);
head_d0 = screw_head_diameter > 0 ? screw_head_diameter : 2 * screw_diameter;
plate_width = max(hook_width - 2 * side_margin, screw_spacing + head_d0 + 2 * plate_end_margin);
covered = plate_width <= hook_width - 2 * side_margin + eps;  // hook hides the whole plate
// Plate extent along X. When covered, the plate reaches the hook's open
// side (-X) so it ends flush with it, and stops short of the closed end.
plate_x0 = covered ? -hook_width / 2 : -plate_width / 2;
plate_x1 = covered ? hook_width / 2 - side_margin : plate_width / 2;
plate_len = plate_x1 - plate_x0;
plate_z = end_margin;                            // plate bottom (front edge)
plate_height = back_length - 2 * end_margin;     // plate height at the front
bevel_drop = plate_thickness * tan_b;            // height of each bevel
hook_back = plate_thickness + fit_tolerance;     // Y of the hook's inner front wall
head_d = screw_head_diameter > 0 ? screw_head_diameter : 2 * screw_diameter;
cs_depth = (head_d - screw_diameter) / 2;        // 90° countersink
head_depth = (screw_head_type == "countersunk" ? cs_depth : screw_head_height) + head_recess;
lock_x = 0;                                      // X of the side lock (between the screws)
lock_y = plate_thickness / 2;                    // Y of the side lock
lock_z_plate = plate_z + bevel_drop * (1 - lock_y / plate_thickness); // plate bottom at the lock
lock_z_top = lock_z_plate + lock_depth;          // top of the lower hole in the plate
top_z_plate = plate_z + plate_height - bevel_drop * (1 - lock_y / plate_thickness); // plate top at the lock
top_z_bottom = top_z_plate - lock_depth;         // bottom of the upper hole in the plate
pin_flat = 0.5;                                  // flat side of the pins (D profile)
has_lock = lock_type != "none";
has_top_pin = top_pin;

// ---------------------------------------------------------------------
//  Checks
// ---------------------------------------------------------------------
assert(head_d > screw_diameter, "The head must be larger than the screw shank");
assert(plate_height - 2 * bevel_drop >= screw_diameter + 4 && plate_height >= head_d + 2,
       "The plate is too short for the screws: increase back_length or reduce end_margin / plate_thickness");
assert(plate_thickness - head_depth >= 1.5,
       "The screw head does not fit: increase plate_thickness or reduce the head size/recess");
assert(!(has_lock || has_top_pin) || screw_spacing / 2 - head_d / 2 >= lock_diameter / 2 + 1,
       "No room for the pins between the screws: reduce lock_diameter");
assert(!(has_lock || has_top_pin) || lock_diameter <= plate_thickness - 2.5,
       "lock_diameter is too large for the plate thickness");
assert((has_lock ? lock_z_top : lock_z_plate) + 2 <= (has_top_pin ? top_z_bottom : top_z_plate),
       "The pin holes meet inside the plate: reduce lock_depth or increase back_length");
assert(!covered || screw_spacing / 2 + head_d / 2 + 1 <= plate_x1,
       "The screws do not fit in the plate: increase hook_width or reduce side_margin");

// ---------------------------------------------------------------------
//  Axes: X = width, Y = depth (0 = wall, +Y outwards), Z = height
//  2D profiles are drawn in (Y, Z) and extruded along X.
// ---------------------------------------------------------------------
module extrude_x(w) {
    // 2D x -> Y, 2D y -> Z, extrusion -> X
    rotate([90, 0, 90]) linear_extrude(w, center = true) children();
}

module extrude_x_range(x0, x1) {
    translate([(x0 + x1) / 2, 0, 0]) extrude_x(x1 - x0) children();
}

// Plate side profile: trapezoid, taller at the front than at the wall
module plate_profile_2d() {
    translate([0, plate_z])
        polygon([[0, bevel_drop], [plate_thickness, 0],
                 [plate_thickness, plate_height], [0, plate_height - bevel_drop]]);
}

// ---------------------------------------------------------------------
//  Part 1: wall plate
// ---------------------------------------------------------------------
module screw_hole() {
    // Shank
    translate([0, -1, 0]) rotate([-90, 0, 0])
        cylinder(d = screw_diameter, h = plate_thickness + 2);
    // Head
    if (screw_head_type == "countersunk") {
        translate([0, plate_thickness - head_recess - cs_depth, 0]) rotate([-90, 0, 0])
            cylinder(d1 = screw_diameter, d2 = head_d, h = cs_depth + eps);
        translate([0, plate_thickness - head_recess, 0]) rotate([-90, 0, 0])
            cylinder(d = head_d, h = head_recess + 1);
    } else {
        translate([0, plate_thickness - head_depth, 0]) rotate([-90, 0, 0])
            cylinder(d = head_d + 0.5, h = head_depth + 1);
    }
}

module plate() {
    difference() {
        extrude_x_range(plate_x0, plate_x1) plate_profile_2d();
        for (s = [-1, 1])
            translate([s * screw_spacing / 2, 0, plate_z + plate_height / 2])
                screw_hole();
        // Lower hole: press fit for the pin, pilot for a screw
        if (has_lock)
            translate([lock_x, lock_y, -1])
                cylinder(d = lock_type == "pin" ? lock_diameter + pin_fit : lock_diameter * 0.8,
                         h = lock_z_top + 1);
        // Upper hole for the top pin, press fit
        if (has_top_pin)
            translate([lock_x, lock_y, top_z_bottom])
                cylinder(d = lock_diameter + pin_fit, h = back_length);
    }
}

// ---------------------------------------------------------------------
//  Part 2: hook
// ---------------------------------------------------------------------

// Rounded bar between two points (2D)
module capsule(a, b, d) {
    hull() { translate(a) circle(d = d); translate(b) circle(d = d); }
}

module hook_profile_2d() {
    t  = hook_thickness;
    y0 = hook_back;
    rc = bend_radius + t / 2;                     // bend radius at the centerline
    c  = [y0 + t / 2 + rc, back_length];          // bend center
    n  = max(1, ceil(arm_angle / 5));
    pts = [for (i = [0 : n]) let (th = 180 - arm_angle * i / n)
              c + rc * [cos(th), sin(th)]];
    dir = [sin(arm_angle), cos(arm_angle)];

    // Straight section: from the wall to the front, wrapping the plate
    square([y0 + t, back_length]);
    // Bend
    for (i = [0 : n - 1]) capsule(pts[i], pts[i + 1], t);
    // Rising section
    capsule(pts[n], pts[n] + arm_length * dir, t);
    // Smooth transition from the top of the straight section into the bend
    hull() {
        translate([0, back_length - end_margin]) square([y0 + eps, end_margin]);
        translate(pts[ceil(n / 2)]) circle(d = t);
    }
}

// Outer envelope of the hook (its side profile extruded to the full width)
module hook_envelope() {
    extrude_x(hook_width) hook_profile_2d();
}

// D-shaped prism along Z at the pin position: round, with a flat on -X
module d_prism(d, z0, z1) {
    translate([lock_x, lock_y, z0])
        intersection() {
            cylinder(d = d, h = z1 - z0);
            translate([-d / 2 + pin_flat, -d, -1]) cube([2 * d, 2 * d, z1 - z0 + 2]);
        }
}

module hook() {
    difference() {
        hook_envelope();
        // Channel: open at the back and at the -X side; closed at +X when
        // the hook covers the plate, otherwise open at both sides (rail)
        extrude_x_range(-hook_width / 2 - 1,
                        covered ? plate_x1 + fit_tolerance : hook_width / 2 + 1)
            offset(delta = fit_tolerance) plate_profile_2d();
        // Lower hole: D-shaped for the pin, round for a screw
        if (lock_type == "pin")
            d_prism(lock_diameter + pin_clearance, -1, plate_z + bevel_drop + 1);
        else if (lock_type == "screw")
            translate([lock_x, lock_y, -1])
                cylinder(d = lock_diameter + pin_clearance, h = plate_z + bevel_drop + 1);
        // Upper hole for the top pin, D-shaped, through the sloped top
        if (has_top_pin)
            d_prism(lock_diameter + pin_clearance, top_z_plate - bevel_drop - 1, back_length * 2);
    }
}

// ---------------------------------------------------------------------
//  Part 3: pins (modelled in place, vertical). The outer end is cut by the
//  hook's envelope, so it matches the hook's surface; the inner end has a
//  lead-in chamfer.
// ---------------------------------------------------------------------
pin_c = min(0.6, lock_diameter / 4);              // lead-in chamfer

// Lower pin: from the hook's bottom face up into the plate
module pin_bottom() {
    z1 = lock_z_top - 0.5;
    intersection() {
        union() {
            d_prism(lock_diameter, -1, z1 - pin_c);
            translate([lock_x, lock_y, z1 - pin_c - eps])
                cylinder(d1 = lock_diameter, d2 = lock_diameter - 2 * pin_c, h = pin_c + eps);
        }
        d_prism(lock_diameter, -1, z1 + 1);
        hook_envelope();
    }
}

// Upper pin: from inside the plate up to the hook's sloped top surface
module pin_top() {
    z0 = top_z_bottom + 0.5;
    intersection() {
        union() {
            translate([lock_x, lock_y, z0])
                cylinder(d1 = lock_diameter - 2 * pin_c, d2 = lock_diameter, h = pin_c + eps);
            d_prism(lock_diameter, z0 + pin_c, back_length * 2);
        }
        d_prism(lock_diameter, z0 - 1, back_length * 2);
        hook_envelope();
    }
}

module pins() {
    if (lock_type == "pin") pin_bottom();
    if (has_top_pin) pin_top();
}

echo(str("Plate length: ", plate_len, " mm",
          covered ? " (hidden behind the hook)" : " (rail: the hook slides in from one end)"));

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
gap = 10;

// Plate: back face down
module plate_print() translate([0, plate_z + plate_height, 0]) rotate([90, 0, 0]) plate();
// Hook: on its closed side (+X face down)
module hook_print()  translate([0, 0, hook_width / 2]) rotate([0, 90, 0]) hook();
// Pins: lying on their flat side (-X face down), side by side
module lying(z_mid) translate([0, 0, lock_diameter / 2 - pin_flat])
                        rotate([0, -90, 0]) translate([-lock_x, -lock_y, -z_mid]) children();
module pin_print() {
    if (lock_type == "pin") lying(lock_z_top / 2) pin_bottom();
    if (has_top_pin) translate([0, lock_diameter + 4, 0]) lying((top_z_bottom + back_length) / 2) pin_top();
}

if (part == "plate") {
    plate_print();
} else if (part == "hook") {
    hook_print();
} else if (part == "pin") {
    pin_print();
} else if (part == "assembled") {
    color("white") plate();
    color("SteelBlue", 0.85) hook();
    color("orange") pins();
} else {
    // Hook and pins next to each other, the plate below them
    translate([gap, 0, 0]) hook_print();
    translate([-gap, 0, 0]) rotate([0, 0, 90]) pin_print();
    translate([0, -plate_z - plate_height - gap, 0]) plate_print();
}
