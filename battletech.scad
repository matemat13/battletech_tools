//General parameters
pin_d = 2;
pin_h = 6;
edge = 2;

// Center torso (CT)
CT_armor = 24;
CT_struct= 21;
CT_dims = calculate_dims(CT_armor, CT_struct, ratio=1/1.2, spacing=5);
CT_width = CT_dims[4];
CT_depth = CT_dims[5];
Bodypart(CT_armor, CT_struct, CT_dims);

// Head (HD)
HD_armor = 9;
HD_struct= 3;
HD_dims = calculate_dims(HD_armor, HD_struct, ratio=1.5/1, spacing=5);
HD_width = HD_dims[4];
HD_depth = HD_dims[5];
translate([0, CT_depth/2 + HD_depth/2, 0])
    Bodypart(HD_armor, HD_struct, HD_dims);

// Right torso (RT)
RT_armor = 19;
RT_struct= 15;
RT_dims = calculate_dims(RT_armor, RT_struct, ratio=1/1.2, spacing=5);
RT_width = RT_dims[4];
RT_depth = RT_dims[5];
translate([CT_width/2 + RT_width/2, 0, 0])
    Bodypart(RT_armor, RT_struct, RT_dims);

// Right arm (RA)
RA_armor = 13;
RA_struct= 10;
RA_dims = calculate_dims(RA_armor, RA_struct, ratio=2.5/1, spacing=5);
RA_width = RA_dims[4];
RA_depth = RA_dims[5];
RA_height = RA_dims[6];
translate([CT_width/2 + RT_width + RA_width/2, -RT_depth/3, 0])
    Bodypart(RA_armor, RA_struct, RA_dims);
translate([CT_width/2 + RT_width + RA_width/2, -RT_depth/3-RA_depth/2, 0])
    Hand(RA_width, RA_height, true);

// Right leg (RL)
RL_armor = 18;
RL_struct= 15;
RL_dims = calculate_dims(RL_armor, RL_struct, ratio=2.5/1, spacing=4.5);
RL_width = RL_dims[4];
RL_depth = RL_dims[5];
RL_height = RL_dims[6];
translate([CT_width/2 + -RL_width/2, -CT_depth/2 - RL_depth/2, 0])
    Bodypart(RL_armor, RL_struct, RL_dims);

module Bodypart(armor, struct, dims)
{    
    armor_r = dims[0];
    armor_c = dims[1];
    struct_r = dims[2];
    struct_c = dims[3];
    width = dims[4];
    depth = dims[5];
    height = dims[6];
    spacing = dims[7];

    echo(armor_r);
    echo(armor_c);

    armor_idx = [1:armor];
    armor_pos = gen_pozice(armor, armor_c);
    armor_x_offset = -armor_c/2*spacing+spacing/2;
    armor_y_offset = -armor_r/2*spacing+spacing/2 + struct_r/2*spacing + 0.5;
    /*translate([armor_x_offset, armor_y_offset, 0])
        for (z_it = armor_idx)
            translate(armor_pos[z_it]) cylinder(d = pin_d, h = pin_h);*/

    struct_idx = [1:struct];
    struct_pos = gen_pozice(struct, struct_c);
    struct_x_offset = -struct_c/2*spacing+spacing/2;
    struct_y_offset = -struct_r/2*spacing+spacing/2 - armor_r/2*spacing - 0.5;
    /*translate([struct_x_offset, struct_y_offset, 0])
        for (z_it = struct_idx)
            translate(struct_pos[z_it]) cylinder(d = pin_d, h = pin_h);*/

    difference()
    {
        translate([0, 0, height/2])
            cube(size = [width, depth, height], center=true);
        translate([armor_x_offset-spacing/2, armor_y_offset-spacing/2, height-1])
            cube(size = [armor_c*spacing, armor_r*spacing, 2]);
        translate([struct_x_offset-spacing/2, struct_y_offset-spacing/2, height-1])
            cube(size = [struct_c*spacing, struct_r*spacing, 2]);
        
        translate([armor_x_offset, armor_y_offset, -height])
            for (z_it = armor_idx)
                translate(armor_pos[z_it]) cylinder(d = pin_d+0.5, h = 2*height);
        
        translate([struct_x_offset, struct_y_offset, -height])
            for (z_it = struct_idx)
                translate(struct_pos[z_it]) cylinder(d = pin_d+0.5, h = 2*height);
    }
    
    function gen_pozice(n, cols, pos=idx2pos(1), cur_i=1) =
    cur_i == n ?
    concat([pos], [idx2pos(cur_i, cols)]):
    concat([pos], gen_pozice(n, cols, idx2pos(cur_i, cols), cur_i+1));

    function idx2pos(index, cols) =
    [
        spacing*((index-1)%cols),
        spacing*(floor((index-1)/cols)),
        0
    ];
}

module Hand(arm_width, height, is_right)
{
    width = 0.6*arm_width;
    depth = 0.4*arm_width;
    
    f_width = width/5;
    f_spacing = width/3.75;
    f_length = depth;
    translate([0, -depth/2, height/2])
    {
        cube(size = [width, depth, height], center=true);
    
        fl_idx = [0, 1, 2, 3];
        fls = [0.9*f_length, 1.0*f_length, 0.85*f_length, 0.65*f_length];
        for (f_it = fl_idx)
        {
            translate([-(width-f_width)/2 + f_it*f_spacing, -depth+(f_length-fls[f_it])/2, 0])
            {
                cube(size = [f_width, fls[f_it], height], center=true);
                translate([0, -fls[f_it]/2, 0])
                    cylinder(d = f_width, h = height, center=true, $fn=20);
            }
        }
    }
}

function calculate_dims(armor, struct, ratio, spacing) = 
[
    to_rows(armor, ratio),
    to_cols(armor, ratio),
    to_rows(struct, ratio),
    to_cols(struct, ratio),
    max(to_cols(armor, ratio), to_cols(struct, ratio))*spacing + edge,
    to_rows(armor, ratio)*spacing + to_rows(struct, ratio)*spacing + edge+1,
    5,
    spacing
];
function to_rows(n, ratio) = 
    let(tmp = round(sqrt(n*ratio)))
    tmp*to_cols(n, ratio) - to_cols(n, ratio) >= n ? tmp-1 : tmp;
function to_cols(n, ratio) = round(ceil(sqrt(n*ratio))/ratio);