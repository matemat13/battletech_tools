//General parameters
pin_d = 2;
pin_h = 6;
edge = 2;
figurine_spacing = 85;

name = "Catapult";

// Center torso (CT)
CT_armor = 24;
CT_struct= 21;
CT_rear = 11;
// Head (HD)
HD_armor = 9;
HD_struct= 3;
// Right torso (RT)
RT_armor = 19;
RT_struct= 15;
RT_rear = 8;
// Right torso (LT)
LT_armor = 19;
LT_struct= 15;
LT_rear = 8;
// Right arm (RA)
RA_armor = 13;
RA_struct= 10;
// Right arm (LA)
LA_armor = 13;
LA_struct= 10;
// Right leg (RL)
RL_armor = 18;
RL_struct= 15;
// Right leg (LL)
LL_armor = 18;
LL_struct= 15;

// Front armor figurine
armor = [HD_armor, CT_armor, RT_armor, LT_armor, RA_armor, LA_armor, RL_armor, LL_armor];
armor_cols = [3, 3, 2, 2, 1, 1, 2, 2];
FrontFigurine(armor, armor_cols);
// Rear armor figurine
rear = [CT_rear, RT_rear, LT_rear];
rear_cols = [3, 2, 2];
translate([-figurine_spacing, 0, 0]) RearFigurine(rear, rear_cols);

// Structure figurine
struct = [HD_struct, CT_struct, RT_struct, LT_struct, RA_struct, LA_struct, RL_struct, LL_struct];
struct_cols = [2, 3, 2, 2, 1, 1, 2, 2];
translate([figurine_spacing, 0, 0]) FrontFigurine(struct, struct_cols);

// Common base and text
union()
{
    translate([0, -15, 0]) minkowski()
    {
        cube([200, 130, 1.5], center=true);
        cylinder(r=25, $fn=50);
    }
    
    linear_extrude(height=3, center = false)
    {
        // Name, etc.
        translate([-figurine_spacing, -70, 0]) text(name, halign="center", size=14, font="style:Bold");
        translate([0, 55, 0]) text("Front armor", halign="center");
        translate([-figurine_spacing, 55, 0]) text("Rear armor", halign="center");
        translate([figurine_spacing, 55, 0]) text("Structure", halign="center");
    }
}

module FrontFigurine(values, columns)
{
    HD = values[0];
    CT = values[1];
    RT = values[2];
    LT = values[3];
    RA = values[4];
    LA = values[5];
    RL = values[6];
    LL = values[7];
    
    HD_cols = columns[0];
    CT_cols = columns[1];
    RT_cols = columns[2];
    LT_cols = columns[3];
    RA_cols = columns[4];
    LA_cols = columns[5];
    RL_cols = columns[6];
    LL_cols = columns[7];
    
    // center torso (CT)
    CT_dims = calculate_dims(CT, cols=CT_cols, spacing=8);
    CT_width = CT_dims[2];
    CT_depth = CT_dims[3];
    Bodypart(CT, CT_dims);
    
    // head (HD)
    HD_dims = calculate_dims(HD, cols=HD_cols, spacing=5);
    HD_width = HD_dims[2];
    HD_depth = HD_dims[3];
    translate([0, CT_depth/2 + HD_depth/2, 0])
        Bodypart(HD, HD_dims);
    
    // right torso (RT)
    RT_dims = calculate_dims(RT, cols=RT_cols, spacing=5);
    RT_width = RT_dims[2];
    RT_depth = RT_dims[3];
    translate([CT_width/2 + RT_width/2, 0, 0])
        Bodypart(RT, RT_dims);
        
    // left torso (LT)
    LT_dims = calculate_dims(LT, cols=LT_cols, spacing=5);
    LT_width = LT_dims[2];
    LT_depth = LT_dims[3];
    translate([-CT_width/2 - LT_width/2, 0, 0])
        Bodypart(LT, LT_dims);
    
    // right arm (RA)
    RA_dims = calculate_dims(RA, cols=RA_cols, spacing=5);
    RA_width = RA_dims[2];
    RA_depth = RA_dims[3];
    RA_height = RA_dims[4];
    translate([CT_width/2 + RT_width + RA_width/2, -RT_depth/4, 0])
        Bodypart(RA, RA_dims);
    translate([CT_width/2 + RT_width + RA_width/2, -RT_depth/4-RA_depth/2, 0])
        Hand(RA_width, RA_height, true);
        
    // left arm (LA)
    LA_dims = calculate_dims(LA, cols=LA_cols, spacing=5);
    LA_width = LA_dims[2];
    LA_depth = LA_dims[3];
    LA_height = LA_dims[4];
    translate([-CT_width/2 - LT_width - LA_width/2, -LT_depth/4, 0])
        Bodypart(LA, LA_dims);
    translate([-CT_width/2 - LT_width - LA_width/2, -LT_depth/4-LA_depth/2, 0])
        Hand(LA_width, LA_height, false);
    
    // right leg (RL)
    RL_dims = calculate_dims(RL, cols=RL_cols, spacing=6);
    RL_width = RL_dims[2];
    RL_depth = RL_dims[3];
    RL_height = RL_dims[4];
    translate([CT_width/3, -CT_depth/2 - RL_depth/2, 0])
        Bodypart(RL, RL_dims);
    translate([CT_width/3, -CT_depth/2 - RL_depth, 0])
        Leg(RL_width, RL_height, true);
    
    // left leg (LL)
    LL_dims = calculate_dims(LL, cols=LL_cols, spacing=6);
    LL_width = LL_dims[2];
    LL_depth = LL_dims[3];
    LL_height = LL_dims[4];
    translate([-CT_width/3, -CT_depth/2 - LL_depth/2, 0])
        Bodypart(LL, LL_dims);
    translate([-CT_width/3, -CT_depth/2 - LL_depth, 0])
        Leg(LL_width, LL_height, false);
}

module RearFigurine(values, columns)
{
    CT = values[0];
    RT = values[1];
    LT = values[2];
    
    CT_cols = columns[0];
    RT_cols = columns[1];
    LT_cols = columns[2];
    
    // center torso (CT)
    CT_dims = calculate_dims(CT, cols=CT_cols, spacing=8);
    CT_width = CT_dims[2];
    CT_depth = CT_dims[3];
    Bodypart(CT, CT_dims);
    
    // right torso (RT)
    RT_dims = calculate_dims(RT, cols=RT_cols, spacing=5);
    RT_width = RT_dims[2];
    RT_depth = RT_dims[3];
    translate([CT_width/2 + RT_width/2, 0, 0])
        Bodypart(RT, RT_dims);
        
    // left torso (LT)
    LT_dims = calculate_dims(LT, cols=LT_cols, spacing=5);
    LT_width = LT_dims[2];
    LT_depth = LT_dims[3];
    translate([-CT_width/2 - LT_width/2, 0, 0])
        Bodypart(LT, LT_dims);
}


module Bodypart(armor, dims)
{    
    armor_r = dims[0];
    armor_c = dims[1];
    width = dims[2];
    depth = dims[3];
    height = dims[4];
    spacing = dims[5];

    /*echo(armor_r);
    echo(armor_c);
    echo(armor);
    echo(armor_r*armor_c);*/

    armor_idx = [1:armor];
    armor_pos = gen_pozice(armor, armor_c);
    armor_x_offset = -armor_c/2*spacing+spacing/2;
    armor_y_offset = -armor_r/2*spacing+spacing/2 + 0.5;
    /*translate([armor_x_offset, armor_y_offset, 0])
        for (z_it = armor_idx)
            translate(armor_pos[z_it]) cylinder(d = pin_d, h = pin_h);*/

    difference()
    {
        translate([0, 0, height/2])
            cube(size = [width, depth, height], center=true);
        translate([armor_x_offset-spacing/2, armor_y_offset-spacing/2, height-1])
            cube(size = [armor_c*spacing, armor_r*spacing, 2]);
        
        translate([armor_x_offset, armor_y_offset, -height])
            for (z_it = armor_idx)
                translate(armor_pos[z_it]) %cylinder(d = pin_d+0.5, h = 2*height);
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
    module DrawHand(arm_width, height)
    {
        width = arm_width;
        depth = 0.6*arm_width;
        
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
    if (is_right)
        DrawHand(arm_width, height);
    else
        mirror([1, 0, 0]) DrawHand(arm_width, height);
}

module Leg(leg_width, height, is_right)
{
    module DrawLeg(leg_width, height)
    {
        width_top = leg_width;
        width_bot = 1.5*leg_width;
        depth = 0.7*leg_width; 
            
        translate([-width_top/2, 0, height/2])
        {
            linear_extrude(height=height, center = true)
            {
                polygon(points=[[0,0],[width_top,0],
                                [width_bot,-depth/2],
                                [width_bot,-depth],
                                [0.3*width_top,-depth],
                                [0,-1*depth/3]]);
            }
        }
    }
    if (is_right)
        DrawLeg(leg_width, height);
    else
        mirror([1, 0, 0]) DrawLeg(leg_width, height);
}

function calculate_dims(armor, cols, spacing) = 
[
    to_rows(armor, cols),
    cols,
    cols*spacing + edge,
    to_rows(armor, cols)*spacing + edge+1,
    5,
    spacing
];
function to_rows(n, cols) = 
    ceil(n/cols);