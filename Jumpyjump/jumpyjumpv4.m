 %------------------------HANS MATLAB SIDE SCROLLING GAME------------------
 %ABOUT THIS GAME
 %if you have any questions, please email me @ stedmanh@seas.upenn.edu
 %This is a MATLAB project that I began initially for a grade in the ENGR
 %105 intro to MATLAB programming course at University of Pennsylvania.
 %In that project, my group member Joshua Chubb and I came up with ideas
 %for the project.
 %We decided to base a game off of the game in Google Chrome that the user
 %sees when a page isn't loading or has an error.
 %This game was too simple to be used as a fully-fledged final project, so
 %I decided to improve on the game. I turned in the game with some of its
 %basic functions but found that I enjoyed coding so much I wanted to
 %continue working on the game in my own time and add even more of my own
 %ideas. From those ideas resulted JumpyJump.v4
 %HOW TO PLAY
 %JumpyJump.v4, despite the added functionality, is still very simple
 %When at the intro/title screen, press the space bar to begin playing.
 %There is only one button to control while playing- spacebar to jump. Jump
 %to avoid cacti, but do not jump too high, or a fast-flying bird will
 %cream you. Luckily, to aid you on the ever-more difficult journey, there
 %are frequently spawned mystery boxes, some good and some bad. The good
 %mystery boxes are marked with a normal question mark, and, like in Mario
 %Kart, the ones to avoid are marked with a flipped question mark.
 %The score only increases while the player is on the ground, a gameplay
 %characteristic I added because I figured it would prevent players from
 %spamming jump, especially during infinite jump sequences. Play as you
 %want, though. Try to go as far as possible while the game speeds up, and
 %enjoy the game!
 %Lastly, you can press q at anytime, whether in intro or gameplay, to
 %quit. Pressing the x button on the figure window will cause an error,
 %because even if you have a 'DeleteFcn', there will still be some problem
 %with delete. Please email me if you happen to fix this because it was my
 %one last nagging annoyance about the game. Also email me if you have any
 %ideas to implement! Enjoy.
function jumpyjumpv4
close all
clear all
clc
%close everything before starting

%defining variables--------------------------------------------------------
%variables must be defined as [] to be called by all nested functions
delay_t = 0.01;
%pause between while loop calculations- frame delay
initdif = 0.9;
dif = initdif;
%defines "difficulty"- number between 0 and 1,
%1 is higher level difficulty, a setting of 0 will result in invincibility
play = [];
gamest = [];
replay = [];
%set to true later in createsetting
offground = [];
%gives length of elapsed time per loop- normalizes loop delay time
counter = [];
score=[];
highscore = [];
%high score during game session
scorestring = [];
highscorestring = [];
replaystring = [];
strings = [];
doublejump = [];
allowedjump = [];
powerup = [];
shield = [];
speed_up = 400;
%all varibles that alter gameplay that are defined in createsetting

%figure variables
fig = []; axs = []; axistitle = [];
intro = []; endmsg = [];

%obstacle variables
obs1 = []; obs2 = []; obs3 = []; obs4 = []; obs5 = [];
obs1array = []; obs2array = []; obs3array = []; obs4array = [];
%arrays of data for obstacles
initpos1x=10;initpos2x= 70; initpos3x = 140;
initpos4x = 60; initpos5x = 180; initpos4y = 5; initpos5y = 4;
%initial positions- some come later than others
pos1x = initpos1x; pos2x = initpos2x; pos3x = initpos3x;
pos4x = initpos4x; pos4y = initpos4y;
pos5x = initpos5x; pos5y = initpos5y;
%horizontal positions of obstacles
obs1_x_arr = []; obs1_y_arr = [];
obs2_x_arr = []; obs2_y_arr = [];
obs3_x_arr = []; obs3_y_arr = [];
obs4_x_arr = []; obs4_y_arr = [];
obs5_x_arr = []; obs5_y_arr = [];
%positions of obstacles
npcs_vel_init = -8;
npcs_vel= npcs_vel_init;
bird_vel = [];
birdspeed = 4;
%initial horizontal velocities of obstacles
obs1_w = []; obs1_h = [];
obs2_w = []; obs2_h = [];
obs3_w = []; obs3_h = [];
obs4_w = []; obs4_h = [];
obs5_w = []; obs5_h = [];
%heights and widths of obstacles

%hero variables
hero = [];
heroarray = []; heroarray2 = [];
hero_w = []; hero_h = [];
%hero width and height
hero_x_pos = [];
hero_y_pos = [];
hero_y_init = 0;
hero_v_init = 32;
hero_a = -128;
%constants that define the vertical motion of the projectile
hero_v = [];
hero_y = [];
%these change when jump is called
hero_change1 = [];
hero_change2 = [];

%mystery box variables
mbox = [];
mbox1array = []; mbox2array = [];
initboxposx = 20; initboxposy = 2;
box_posx = initboxposx; box_posy = initboxposy;
box_xarr = [box_posx box_posx+1]; box_yarr = [box_posy+1 box_posy];
%spawns at counter = 1000
mboxspawn = 1000; mboxrespawn = 500;
mboxcall = []; mboxinplay = [];
poweruptext = []; textinplay = [];
%mystery box stuff

%other objects variables
line1x = [0 8]; line1y = [-0.0625 -0.0625];
%line resembles the ground
cloud1 = []; cloud2 = []; cloud3 = [];
cloudarray = [];
cloud1posx = 6; cloud1posy = 6;
cloud2posx = 10; cloud2posy = 7;
cloud3posx = 15; cloud3posy = 5;
%initial positions of clouds
cloud1_xarr = []; cloud1_yarr = [];
cloud2_xarr = []; cloud2_yarr = [];
cloud3_xarr = []; cloud3_yarr = [];
%position arrays of clouds
cloudvel = -1;
%clouds move slower because they are in background
cloud1_w = []; cloud1_h = [];
cloud2_w = []; cloud2_h = [];
cloud3_w = []; cloud3_h = [];
%heights and widths of clouds

%colors
a = 0.5;
b = 0.7;
c = 0.9;
d = 0.3;
e = 0.4;
f = 0.5;
g = 0.6;

%array data for all objects------------------------------------------------

function arrayfcn

cloudarray = ones(7,18,3);
%cloud array data
cloudarray(1,:,1) = [1 1 1 1 1 1 1 1 c c c c 1 1 1 1 1 1];
cloudarray(2,:,1) = [1 1 1 1 1 1 c c c 1 1 c 1 1 1 1 1 1];
cloudarray(3,:,1) = [1 1 1 1 1 c c 1 c 1 1 c c c 1 1 1 1];
cloudarray(4,:,1) = [1 1 1 1 1 c 1 1 1 1 c c 1 c c c 1 1];
cloudarray(5,:,1) = [1 c c c c c 1 1 1 1 c 1 1 1 c 1 c 1];
cloudarray(6,:,1) = [c c 1 1 1 1 1 1 1 1 1 1 1 1 1 1 c c];
cloudarray(7,:,1) = [c 1 1 c c c c c c c c c c c c c c c];

cloudarray(:,:,2) = cloudarray(:,:,1);
cloudarray(:,:,3) = cloudarray(:,:,1);
%second and third (green and blue) arrays are same values as first

heroarray = ones(16,16,3);
%hero array data
heroarray(1,:,1) =  [1 1 1 1 1 1 1 1 1 1 d d d d d 1];
heroarray(2,:,1) =  [1 1 1 1 1 1 1 1 1 d d 1 d d d d];
heroarray(3,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d d d d];
heroarray(4,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d d d d];
heroarray(5,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d 1 1 1];
heroarray(6,:,1) =  [d 1 1 1 1 1 1 1 d d d d d d d 1];
heroarray(7,:,1) =  [d 1 1 1 1 1 1 d d d d d 1 1 1 1];
heroarray(8,:,1) =  [d d 1 1 1 1 d d d d d d 1 1 1 1];
heroarray(9,:,1) =  [d d d 1 1 d d d d d d d d d 1 1];
heroarray(10,:,1) = [1 d d d d d d d d d d d 1 d 1 1];
heroarray(11,:,1) = [1 1 d d d d d d d d d d 1 1 1 1];
heroarray(12,:,1) = [1 1 1 d d d d d d d d 1 1 1 1 1];
heroarray(13,:,1) = [1 1 1 1 d d 1 1 1 d d d 1 1 1 1];
heroarray(14,:,1) = [1 1 1 1 1 d 1 1 1 1 1 1 1 1 1 1];
heroarray(15,:,1) = [1 1 1 1 1 d 1 1 1 1 1 1 1 1 1 1];
heroarray(16,:,1) = [1 1 1 1 1 d d 1 1 1 1 1 1 1 1 1];

%setting color to gray
heroarray(:,:,2) = heroarray(:,:,1);
heroarray(:,:,3) = heroarray(:,:,1);

heroarray2 = ones(16,16,3);
%hero2 array data
heroarray2(1,:,1) =  [1 1 1 1 1 1 1 1 1 1 d d d d d 1];
heroarray2(2,:,1) =  [1 1 1 1 1 1 1 1 1 d d 1 d d d d];
heroarray2(3,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d d d d];
heroarray2(4,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d d d d];
heroarray2(5,:,1) =  [1 1 1 1 1 1 1 1 1 d d d d 1 1 1];
heroarray2(6,:,1) =  [d 1 1 1 1 1 1 1 d d d d d d d 1];
heroarray2(7,:,1) =  [d 1 1 1 1 1 1 d d d d d 1 1 1 1];
heroarray2(8,:,1) =  [d d 1 1 1 1 d d d d d d 1 1 1 1];
heroarray2(9,:,1) =  [d d d 1 1 d d d d d d d d d 1 1];
heroarray2(10,:,1) = [1 d d d d d d d d d d d 1 d 1 1];
heroarray2(11,:,1) = [1 1 d d d d d d d d d d 1 1 1 1];
heroarray2(12,:,1) = [1 1 1 d d d d d d d d 1 1 1 1 1];
heroarray2(13,:,1) = [1 1 1 1 d d 1 1 1 d d 1 1 1 1 1];
heroarray2(14,:,1) = [1 1 1 1 1 d d 1 1 1 d 1 1 1 1 1];
heroarray2(15,:,1) = [1 1 1 1 1 1 1 1 1 1 d 1 1 1 1 1];
heroarray2(16,:,1) = [1 1 1 1 1 1 1 1 1 1 d d 1 1 1 1];

%setting color to gray
heroarray2(:,:,2) = heroarray2(:,:,1);
heroarray2(:,:,3) = heroarray2(:,:,1);

obs1array = ones(16,16,3);
%obs1 array data
obs1array(1,:,1) =  [1 1 1 1 1 1 1 1 1 1 1 d d 1 1 1];
obs1array(2,:,1) =  [1 1 1 1 d 1 1 1 1 1 1 d d 1 1 1];
obs1array(3,:,1) =  [1 1 1 d d 1 1 1 d 1 1 d d 1 d 1];
obs1array(4,:,1) =  [1 1 1 d d 1 1 1 d d 1 d d 1 d d];
obs1array(5,:,1) =  [1 d 1 d d 1 1 1 d d 1 d d 1 d d];
obs1array(6,:,1) =  [d d 1 d d 1 d 1 d d 1 d d 1 d d];
obs1array(7,:,1) =  [d d 1 d d 1 d 1 d d 1 d d 1 d d];
obs1array(8,:,1) =  [d d 1 d d 1 d 1 1 d d d d 1 d d];
obs1array(9,:,1) =  [d d 1 d d 1 d 1 1 1 d d d d d d];
obs1array(10,:,1) = [d d 1 d d d d 1 1 1 1 d d d d 1];
obs1array(11,:,1) = [d d d d d d d 1 1 1 1 d d d 1 1];
obs1array(12,:,1) = [1 d d d d d 1 1 1 1 1 d d d 1 1];
obs1array(13,:,1) = [1 1 1 d d 1 1 1 1 1 1 d d d 1 1];
obs1array(14,:,1) = [1 1 1 d d 1 1 1 1 1 1 d d d 1 1];
obs1array(15,:,1) = [1 1 1 d d 1 1 1 1 1 1 d d d 1 1];
obs1array(16,:,1) = [1 1 d d d 1 1 1 1 d d d d d 1 1];

obs1array(:,:,2) = obs1array(:,:,1);
obs1array(:,:,3) = obs1array(:,:,1);

obs2array = ones(16,24,3);
%obs2 array data
obs2array(1,:,1) =  [1 1 1 d d 1 1 1 1 1 d d 1 1 1 1 1 1 1 1 d d 1 1];
obs2array(2,:,1) =  [1 1 1 d d 1 1 1 1 1 d d 1 d 1 1 1 d 1 d d d 1 1];
obs2array(3,:,1) =  [1 1 1 d d 1 1 1 1 1 d d 1 d 1 1 1 d 1 d d d 1 1];
obs2array(4,:,1) =  [1 d 1 d d 1 d 1 1 1 d d 1 d 1 1 1 d 1 d d d 1 d];
obs2array(5,:,1) =  [d d 1 d d 1 d 1 1 1 d d d d 1 1 1 d d d d d 1 d];
obs2array(6,:,1) =  [d d 1 d d d d 1 d 1 d d 1 1 1 d 1 1 1 d d d 1 d];
obs2array(7,:,1) =  [d d 1 d d 1 d 1 d 1 d d 1 d 1 d 1 1 1 d d d 1 d];
obs2array(8,:,1) =  [d d 1 d d 1 d 1 d 1 d d 1 d 1 d 1 d 1 d d d 1 d];
obs2array(9,:,1) =  [d d d d d d d 1 d 1 d d 1 d 1 d 1 d 1 d d d 1 d];
obs2array(10,:,1) = [1 d d d d 1 1 1 d 1 d d 1 d 1 d 1 d 1 d d d d d];
obs2array(11,:,1) = [1 1 1 d d 1 1 1 d d d d 1 d d d 1 d 1 d d d 1 1];
obs2array(12,:,1) = [1 1 1 d d 1 1 1 1 1 d d 1 1 1 d d d 1 d d d 1 1];
obs2array(13,:,1) = [1 1 1 d d 1 1 1 1 1 d d 1 1 1 d 1 1 1 d d d 1 1];
obs2array(14,:,1) = [1 1 1 d d 1 1 1 1 1 d d 1 1 1 d 1 1 1 d d d 1 1];
obs2array(15,:,1) = [1 1 1 d d 1 1 1 1 1 d d 1 1 1 d 1 1 1 d d d 1 1];
obs2array(16,:,1) = [1 1 d d d 1 1 1 1 d d d 1 1 d d 1 1 d d d d 1 1];

obs2array(:,:,2) = obs2array(:,:,1);
obs2array(:,:,3) = obs2array(:,:,1);

obs3array = ones(16,10,3);
%obs3 array data
obs3array(1,:,1) =  [1 1 1 1 d d 1 1 1 1];
obs3array(2,:,1) =  [1 1 1 d d d d 1 1 1];
obs3array(3,:,1) =  [1 1 1 d d d d 1 1 d];
obs3array(4,:,1) =  [d 1 1 d d d d 1 d d];
obs3array(5,:,1) =  [d d 1 d d d d 1 d d];
obs3array(6,:,1) =  [d d 1 d d d d 1 d d];
obs3array(7,:,1) =  [d d 1 d d d d 1 d d];
obs3array(8,:,1) =  [d d d d d d d d d 1];
obs3array(9,:,1) =  [1 d d d d d d 1 1 1];
obs3array(10,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(11,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(12,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(13,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(14,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(15,:,1) = [1 1 1 d d d d 1 1 1];
obs3array(16,:,1) = [1 1 d d d d d 1 1 1];

obs3array(:,:,2) = obs3array(:,:,1);
obs3array(:,:,3) = obs3array(:,:,1);

obs4array = ones(16,16,3);
%obs4 array data
obs4array(1,:,1) =  [1 1 1 1 1 a 1 1 1 1 1 1 1 1 1 1];
obs4array(2,:,1) =  [1 1 1 1 a a 1 1 1 1 1 1 1 1 1 1];
obs4array(3,:,1) =  [1 1 1 a a a 1 1 1 1 1 1 1 1 1 1];
obs4array(4,:,1) =  [1 1 1 a a a 1 1 1 1 1 1 1 1 1 1];
obs4array(5,:,1) =  [1 1 a a a a 1 1 1 1 1 1 1 1 1 1];
obs4array(6,:,1) =  [1 1 1 a a a a 1 1 1 1 1 1 b 1 1];
obs4array(7,:,1) =  [1 1 1 a a a a 1 1 1 1 1 b b 1 1];
obs4array(8,:,1) =  [1 1 1 1 a a a 1 1 1 b b b b b 1];
obs4array(9,:,1) =  [1 1 1 b b a a a b b b b b b b b];
obs4array(10,:,1) = [1 1 b b b b a b b b b b b 1 1 b];
obs4array(11,:,1) = [1 1 b 1 a b b b b b b b 1 1 1 1];
obs4array(12,:,1) = [1 b b a a b b b a a a a a a a a];
obs4array(13,:,1) = [b b b b b b a a a a a a a a a 1];
obs4array(14,:,1) = [1 1 1 b b b b a a a a a a a 1 1];
obs4array(15,:,1) = [1 1 1 1 b b b b b 1 a a a 1 1 1];
obs4array(16,:,1) = [1 1 1 1 1 b b b 1 1 1 1 1 1 1 1];

obs4array(:,:,2) = obs4array(:,:,1);
obs4array(:,:,3) = obs4array(:,:,1);

mbox1array = ones(16,16,3);
%mystery box 1 array
mbox1array(1,:,1) =  [e e e e e e e e e e e e e e 1 1];
mbox1array(2,:,1) =  [e e 1 1 1 1 1 1 1 1 1 1 1 e e 1];
mbox1array(3,:,1) =  [e e e 1 1 1 1 1 1 1 1 1 1 1 e e];
mbox1array(4,:,1) =  [e 1 e e e e e e e e e e e e e e];
mbox1array(5,:,1) =  [e 1 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox1array(6,:,1) =  [e 1 1 e 1 1 1 1 f f f f 1 1 1 e];
mbox1array(7,:,1) =  [e 1 1 e 1 1 1 1 f 1 1 f 1 1 1 e];
mbox1array(8,:,1) =  [e 1 1 e 1 1 1 1 1 1 1 f 1 1 1 e];
mbox1array(9,:,1) =  [e 1 1 e 1 1 1 1 1 f f f 1 1 1 e];
mbox1array(10,:,1) = [e 1 1 e 1 1 1 1 1 f 1 1 1 1 1 e];
mbox1array(11,:,1) = [e 1 1 e 1 1 1 1 1 f 1 1 1 1 1 e];
mbox1array(12,:,1) = [e 1 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox1array(13,:,1) = [e 1 1 e 1 1 1 1 1 f 1 1 1 1 1 e];
mbox1array(14,:,1) = [e e 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox1array(15,:,1) = [1 e e e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox1array(16,:,1) = [1 1 e e e e e e e e e e e e e e];

mbox1array(:,:,2) = mbox1array(:,:,1);
mbox1array(:,:,3) = mbox1array(:,:,1);

mbox2array = ones(16,16,3);
%mystery box 2 array
mbox2array(1,:,1) =  [e e e e e e e e e e e e e e 1 1];
mbox2array(2,:,1) =  [e e 1 1 1 1 1 1 1 1 1 1 1 e e 1];
mbox2array(3,:,1) =  [e e e 1 1 1 1 1 1 1 1 1 1 1 e e];
mbox2array(4,:,1) =  [e 1 e e e e e e e e e e e e e e];
mbox2array(5,:,1) =  [e 1 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox2array(6,:,1) =  [e 1 1 e 1 1 1 1 1 g 1 1 1 1 1 e];
mbox2array(7,:,1) =  [e 1 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox2array(8,:,1) =  [e 1 1 e 1 1 1 1 1 g 1 1 1 1 1 e];
mbox2array(9,:,1) =  [e 1 1 e 1 1 1 1 1 g 1 1 1 1 1 e];
mbox2array(10,:,1) = [e 1 1 e 1 1 1 g g g 1 1 1 1 1 e];
mbox2array(11,:,1) = [e 1 1 e 1 1 1 g 1 1 1 1 1 1 1 e];
mbox2array(12,:,1) = [e 1 1 e 1 1 1 g 1 1 g 1 1 1 1 e];
mbox2array(13,:,1) = [e 1 1 e 1 1 1 g g g g 1 1 1 1 e];
mbox2array(14,:,1) = [e e 1 e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox2array(15,:,1) = [1 e e e 1 1 1 1 1 1 1 1 1 1 1 e];
mbox2array(16,:,1) = [1 1 e e e e e e e e e e e e e e];

mbox2array(:,:,2) = mbox2array(:,:,1);
mbox2array(:,:,3) = mbox2array(:,:,1);
end

%creating the setting and axis---------------------------------------------

function createsetting
    
    %initialize empty set variables
    play = true;
    gamest = 1;
    offground = false;
    mboxinplay = false;
    powerup = false;
    replay = 0;
    score = 0;
    highscore = 0;
    %initializing empty set variables from earlier
    %score = score while player is on ground (so that they are incentivized
    %to press the jump key less
    
    fig=figure('KeyPressFcn',@keydownlistener);
    set(fig,'MenuBar','None','color','w','Resize', 'off');
    %set no menubar and white background color, no resize of fig
    
    %setting axes:
    axs=axes();
    axis(axs,'manual');
    axis(axs,[0 8 -0.1 8]);
    %axis are set and will not change
    axis(axs,'off')
    set(axs,'YDir','normal')
    axistitle = title('');
    hold on
    %so that all of the images appear on one axes


cloud1 = image(cloud1_xarr,cloud1_yarr,cloudarray);
uistack(cloud1,'bottom')
%place beneath text

cloud2_xarr = [cloud2posx cloud2posx+cloud2_w];
cloud2_yarr = [cloud2posy+cloud2_h cloud2posy];
cloud2 = image(cloud2_xarr,cloud2_yarr,cloudarray);
uistack(cloud2,'bottom')
%2nd cloud

cloud3_xarr = [cloud3posx cloud3posx+cloud3_w];
cloud3_yarr = [cloud3posy+cloud3_h cloud3posy];
cloud3 = image(cloud3_xarr,cloud3_yarr,cloudarray);
uistack(cloud3,'bottom')
%3rd cloud

end

%move non-interactive objects (such as clouds) function--------------------

function moveobjects
    
    cloud1posx = cloud1posx + (cloudvel*delay_t);
    cloud2posx = cloud2posx + (cloudvel*delay_t);
    cloud3posx = cloud3posx + (cloudvel*delay_t);
    if cloud1posx + cloud1_w < -1
        cloud1posx  = 11 - cloud1_w;
        cloud1posy = 5 + 2*rand;
        %randomize cloud1 height
    elseif cloud2posx + cloud2_w < -1
        cloud2posx  = 11 - cloud2_w;
        cloud2posy = 6+rand;
        %randomize cloud2 y position
    elseif cloud3posx + cloud3_w < -1
        cloud3posx = 11 - cloud3_w;
        cloud3posy = 4 + 3*rand;
        %randomize cloud3 y position
    end
    
    %array data for cloud movement
    cloud1_xarr = [cloud1posx cloud1posx+cloud1_w];
    cloud1_yarr = [cloud1posy+cloud1_h cloud1posy];
    cloud2_xarr = [cloud2posx cloud2posx+cloud2_w];
    cloud2_yarr = [cloud2posy+cloud2_h cloud2posy];
    cloud3_xarr = [cloud3posx cloud3posx+cloud3_w];
    cloud3_yarr = [cloud3posy+cloud3_h cloud3posy];
    
    set(cloud1,'XData',cloud1_xarr,'YData',cloud1_yarr);
    set(cloud2,'XData',cloud2_xarr,'YData',cloud2_yarr);
    set(cloud3,'XData',cloud3_xarr,'YData',cloud3_yarr);
    %movement of clouds
end

%gamestatefcn executes commands regarding the gamestate--------------------

function gamestatefcn
    if gamest == 1
        cloudvel = -1;
        gamest = 2;
        %sets up intro, then runs intro
    elseif gamest == 3
        delete(intro)
        if replay > 1
            delete(endmsg)
        end
        %delete the endmsg if it has been displayed
        gamest = 4;
        %sets up gameplay, then runs game
    end
end

%game_titlesc is a game intro function-------------------------------------

function game_titlesc
        intro(1) = text(4,6.5,'JumpyJump.v4');
        intro(2) = text(4,5.5,'a MATLAB side scroller by Hans Stedman');
        intro(3) = text(4,2,'Based on the google error page game');
        intro(4) = text(4,1.5,'Jump using space to avoid cacti and birds');
        intro(5) = text(4,1,'Collect mystery boxes!');
        intro(6) = text(4,0.5,'Press space to begin, or q to exit');
        %6 messages that play on the intro

        %simple for loop executes specifications for every intro message
        for kk = 1:length(intro)
            set(intro(kk), 'HorizontalAlignment','Center','Color',[0 0 0.7]);

        end
        %set messages centered
        set(intro(1),'Fontsize',30);
        set(intro(2),'FontSize',14);
        %set fontsizes of msg 1 and 2
        
        %intial conditions for hero, objects, etc in the intro
        %these must be defined here because they get reset/randomized
        
        counter = 0;
        replay = replay + 1;
        score = 0;
        
        hero_y = 0;
        hero_v = 0;
        doublejump = 0;
        allowedjump = 2;
        dif = initdif;
        npcs_vel= npcs_vel_init;
        bird_vel = npcs_vel - birdspeed;
        speed_up = 400;
        
        hero_w = 1; hero_h = 1;
        obs1_w = 1; obs1_h = 1;
        obs2_w = 1.5; obs2_h = 1;
        obs3_w = 0.5; obs3_h = 1;
        obs4_w = 1; obs4_h = 1;
        obs5_w = 1.2; obs5_h = 1.2;
        
        cloud1_w = 1; cloud1_h = 0.5;
        cloud2_w = 1.5; cloud2_h = 0.75;
        cloud3_w = 1.2; cloud3_h = 0.6;
        
        hero_change1 = 10;
        hero_change2 = 20;
        
        mboxspawn = 1000;
        mboxcall = 0;
        powerup = false;
        shield = 0;
        
        %if this is not the first time the intro is shown, the game is over
        %so display the Game Over text with objects removed
        if replay > 1
        endmsg(1) = text(4,4,'GAME OVER');
        endmsg(2) = text(4,3,'Try Again?');
        set(endmsg,'HorizontalAlignment','Center','Color',[1 0 0],...
            'FontSize',36);
        set(endmsg(2),'FontSize',20);
        delete(obs1,obs2,obs3,obs4,obs5,hero)
        pos1x = initpos1x; pos2x = initpos2x; pos3x = initpos3x;
        pos4x = initpos4x; pos5x = initpos5x;
        pos4y = initpos4y; pos5y = initpos5y;
        box_posx = initboxposx; box_posy = initboxposy;
        %delete mysterybox if it is in play
            if mboxinplay == true
                delete(mbox)
                mboxinplay = false;
            end
            %delete text if it is in play
            if textinplay == true
                delete(poweruptext)
            end
            set(axs,'YDir','normal')
            textinplay = false;
        end
end

%update_hero_loc allows the hero to be moved-------------------------------

function update_hero_loc
    %constant acceleration equations from physics
        hero_v = hero_v+(hero_a*delay_t);
        hero_y = hero_y+(hero_v*delay_t);
        if hero_y < 0
            hero_v = 0;
            hero_y = hero_y_init;
            doublejump = 0;
            offground = false;
            %offground is false if hero is below ground, terminating jump
        elseif hero_y + hero_h > 8
            hero_v = 0;
            %hero can not jump out of the top
        end
end

%game_walls sets obstacles-------------------------------------------------

function game_npcs
%non-player character position and creation
pos1x = pos1x + (npcs_vel*delay_t);
pos2x = pos2x + (npcs_vel*delay_t);
pos3x = pos3x + (npcs_vel*delay_t);
pos4x = pos4x + (bird_vel*delay_t);
pos5x = pos5x + (bird_vel*delay_t);
%These if statements respawn obstacles after they go offscreen, adding an
%element of randomness in size and position upon each spawn  
if pos1x + obs1_w < -1
    pos1x = 18 + 4*rand - obs1_w;
    obs1_w = 0.75 + 0.5*rand;
    obs1_h = 0.75+ 0.5*rand;
elseif pos2x + obs2_w < -1
    pos2x =  20 + 8*rand - obs2_w;
    obs2_w = 1.25 + 0.5*rand;
    obs2_h = 1 + 0.5*rand;
elseif pos3x + obs3_w < -1
    pos3x = 30 + 12*rand - obs3_w;
    obs3_w = 0.3 + 0.4*rand;
    obs3_h = 0.75 + 0.5*rand;
elseif pos4x + obs4_w < -1
    pos4x = 24 + 12*rand - obs4_w;
    pos4y = 4 + 2*rand;
    obs4_w = 0.8 + 0.4*rand;
    obs4_h = obs4_w;
elseif pos5x + obs5_w < -1
    pos5x = 35 + 10*rand - obs5_w;
    pos5y = 3 + 2*rand;
    obs5_w = 0.9 + 0.6*rand;
    obs5_h = obs5_w;
end

%if the mystery box is in play, move the box
if mboxinplay == true
    box_posx = box_posx + (npcs_vel*delay_t);
    box_xarr = [box_posx box_posx+1];
    box_yarr = [box_posy+1 box_posy];
    set(mbox,'XData',box_xarr,'YData',box_yarr)
%if the hero jumps into the box, do the following
    if box_posx < hero_w && box_posx > -1 &&...
        hero_y < box_posy + 1 && hero_y + hero_h > box_posy
        delete(mbox)
        mboxinplay = false;
        box_posx = 18 + 4*rand; box_posy = 1.5 + 0.5*rand;
        box_xarr = [box_posx box_posx+1]; box_yarr = [box_posy+1 box_posy];
        powerup = true;
        textinplay = true;
        %otherwise, if the box goes off screen, do the following
    elseif box_posx < -1
        delete(mbox);
        mboxinplay = false;
        box_posx = 18 + 4*rand; box_posy = 1.5 + 0.5*rand;
        box_xarr = [box_posx box_posx+1]; box_yarr = [box_posy+1 box_posy];
    end
end

%so that obstacles won't be placed on top of one another
if pos1x + obs1_w > pos2x && pos1x < pos2x + obs2_w
	pos1x = pos1x + 4;
elseif pos1x + obs1_w > pos3x && pos1x < pos3x + obs3_w
    pos1x = pos1x + 4;
elseif pos2x + obs2_w > pos3x && pos2x < pos3x + obs3_w
    pos2x = pos2x + 4;
elseif pos4x + obs4_w > pos5x && pos4x < pos5x + obs5_w...
        && pos4y + obs4_h > pos5y && pos4y < pos5y + obs5_h
    pos4x = pos4x + 8;
end

%redifining the positions for all of the obstacles 
obs1_x_arr = [pos1x pos1x+obs1_w];
obs1_y_arr = [obs1_h 0];
obs2_x_arr = [pos2x pos2x+obs2_w];
obs2_y_arr = [obs2_h 0];
obs3_x_arr = [pos3x pos3x+obs3_w];
obs3_y_arr = [obs3_h 0];
obs4_x_arr = [pos4x pos4x+obs4_w];
obs4_y_arr = [pos4y+obs4_h pos4y];
obs5_x_arr = [pos5x pos5x+obs5_w];
obs5_y_arr = [pos5y+obs5_h pos5y];
%setting the obstacles in each frame
set(obs1,'XData',obs1_x_arr,'YData',obs1_y_arr);
set(obs2,'XData',obs2_x_arr,'YData',obs2_y_arr);
set(obs3,'XData',obs3_x_arr,'YData',obs3_y_arr);
set(obs4,'XData',obs4_x_arr,'YData',obs4_y_arr);
set(obs5,'XData',obs4_x_arr,'YData',obs4_y_arr);
end

%kill_hero kills player----------------------------------------------------

function kill_hero
    %the shield always diminishes if the player is on an obstacle
    shield = shield - 1;
    %if shield is gone and player is on an obstacle
    if shield < 0
    hero_v = 0;
    gamest = 1;
    %send back to intro screen
    end
end

%game_constantrun = various processes that have to happen every frame------

function game_constantrun
    %counter is always going up
    counter = counter + 1;
    %this section of code increases the speed of non-player characters
        if counter == speed_up && npcs_vel > -21
            %npcs_vel is capped at -21, it gets too difficult after
            npcs_vel = npcs_vel - 1;
            bird_vel = npcs_vel - birdspeed;
            cloudvel = cloudvel - 0.5;
            speed_up = round(1.1*speed_up + 400);
        end
        %so that velocity of obstacles speeds up
        
        if replay == 1
            highscore = score;
        elseif replay > 1 && score > highscore
            highscore = score;
        end
        %setting highgscore = score if score is greater than highscore
                
        scorestring = sprintf('Score %.6d', score);
        highscorestring = sprintf('  Highscore %.6d',highscore);
        replaystring = sprintf('  Plays %.2d',replay);
        strings = [scorestring highscorestring replaystring];
        set(axistitle, 'String', strings);
        set(axistitle,'Fontsize',12,'Color',[0.5 0.5 1]);
        %set score, highscore, replays as axes title
        
        if counter == hero_change1
            hero_change1 = hero_change1 + 20;
            if offground == false
            delete(hero)
            hero = image(hero_x_pos,hero_y_pos,heroarray2);
            end
        elseif counter == hero_change2
            hero_change2 = hero_change2 + 20;
            if offground == false
            delete(hero)
            hero = image(hero_x_pos,hero_y_pos,heroarray);
            end
        end
        %these if statements are responsible for hero animation
        
        if counter == mboxspawn
            %the mboxspawn happens every mboxrespawn period
            if textinplay == true
                delete(poweruptext)
                textinplay = false;
            end
            %if text is in play, delete it
            mboxspawn = mboxspawn + mboxrespawn;
            mboxcall =  rand;
            %the random number decides if there will be a box
            %and if so, whether the box will be good or bad.
            % 20 percent chance the box will not spawn
            if mboxcall > 0.2 && mboxcall < 0.5
                %30 percent chance the box will be bad
                %showing upside down ? on box to signify bad box
                %redundancy to prevent ghosts of mbox
                %this box is mbox2array
                box_posx = box_posx + (npcs_vel*delay_t);
                box_xarr = [box_posx box_posx+1];
                box_yarr = [box_posy+1 box_posy];
                mbox = image(box_xarr,box_yarr,mbox2array);
                mboxinplay = true;
            elseif mboxcall > 0.5
                %redundancy to prevent ghosts of mbox
                %50 percent chance box will be good
                %showing ? on box to signify good box
                %this box is mbox1array
                box_posx = box_posx + (npcs_vel*delay_t);
                box_xarr = [box_posx box_posx+1];
                box_yarr = [box_posy+1 box_posy];
                mbox = image(box_xarr,box_yarr,mbox1array);
                mboxinplay = true;
            end
        end
        
        %list of powerups
        %bad powerups:
        %1- hero is larger than normal size
        %2- score is subtracted
        %3- figure is flipped vertically
        %good powerups:
        %1- double points
        %2- invincibility
        %3- infinite jump
        %4- obstacle speed slows
        %5- 1 extra life (carries over)
        
        if powerup == true
            if mboxcall > 0.2 && mboxcall <= 0.3
                hero_w = 1.3*hero_w; hero_h = 1.3*hero_h;
                poweruptext = text(2.5,7.5,'Larger Size');
                %bad powerup 1
            elseif mboxcall > 0.3 && mboxcall <= 0.4
                score = score - mboxrespawn;
                poweruptext = text(2.5,7.5,'-400 points');
                %bad powerup 2
            elseif mboxcall > 0.4 && mboxcall <= 0.5
                set(axs,'YDir','reverse')
                poweruptext = text(2.5,7.5,'Upside Down');
                %bad powerup 3
            elseif mboxcall > 0.5 && mboxcall <= 0.6
                score = score + mboxrespawn;
                poweruptext = text(2.5,7.5,'+400 points');
                %good powerup 1
            elseif mboxcall > 0.6 && mboxcall <= 0.7
                dif = 0;
                poweruptext = text(2.5,7.5,'Invincibility');
                %good powerup 2
            elseif mboxcall > 0.7 && mboxcall <= 0.8
                allowedjump = Inf;
                poweruptext = text(2.5,7.5,'Infinite Jump');
                %good powerup 3
            elseif mboxcall > 0.8 && mboxcall <= 0.9
                pos4x = 100; pos5x = 100;
                poweruptext = text(2.5,7.5,'No Birds');
                %good powerup 4
            elseif mboxcall > 0.9
                shield = shield + 25;
                poweruptext = text(2.5,6.5,'+25 Shield');
                %good powerup 5
                %shield is different than others in that its variable does
                %not reset until title screen, when player dies. therefore,
                %player can build up shield upon repeated acquisition of
                %this powerup and have a better chance for long survival
            end
            set(poweruptext,'Color',[1 0 0],'fontsize',20);
            %any powerup sets the text specifications
            powerup = false;
            %this if statement only occurs once when the powerup is called
        end
        
        hero_x_pos = [0 hero_w];
        hero_y_pos = [hero_y+hero_h hero_y];
        set(hero,'XData',hero_x_pos,'YData',hero_y_pos)
        %another redundancy to ensure the hero appears larger
        
        %when new mystery box spawns, most powerups reset
        if mboxinplay == true
            hero_w = 1; hero_h = 1;
            set(axs,'YDir','normal')
            dif = initdif;
            allowedjump = 2;
            pos4y = initpos4y; pos5y = initpos5y;
        end
end

%game_over defines conditions through which player can die-----------------

function game_over
    
        if pos1x < dif*hero_w && pos1x > -dif*obs1_w && hero_y < obs1_h
            kill_hero
        elseif pos2x < dif*hero_w && pos2x > -dif*obs2_w && hero_y < obs1_h
            kill_hero
        elseif pos3x < dif*hero_w && pos3x > -dif*obs3_w && hero_y < obs3_h
            kill_hero
        elseif pos4x < dif*hero_w && pos4x > -dif*obs4_w...
                && hero_y < pos4y + obs4_h && hero_y + hero_h > pos4y
            kill_hero
        elseif pos5y < dif && pos5y > -dif*obs5_w...
                && hero_y < pos5y + obs5_h && hero_y + hero_h > pos5y
            kill_hero
        end
        %conditions that kill the hero character
    end

%game_characters sets hero and obstacle creation---------------------------

function game_characters

hero_x_pos = [0 hero_w];
hero_y_pos = [hero_y+hero_h hero_y];
hero = image(hero_x_pos,hero_y_pos,heroarray);
%image of hero (first of 2 hero images, appears in game state 3

obs1_x_arr = [pos1x pos1x+obs1_w];
obs1_y_arr = [obs1_h 0];
obs1 = image(obs1_x_arr, obs1_y_arr,obs1array);
%image of obstacle 1

obs2_x_arr = [pos2x pos2x+obs2_w];
obs2_y_arr = [obs2_h 0];
obs2 = image(obs2_x_arr, obs2_y_arr,obs2array);
%image of obstacle 2

obs3_x_arr = [pos3x pos3x+obs3_w];
obs3_y_arr = [obs3_h 0];
obs3 = image(obs3_x_arr, obs3_y_arr,obs3array);
%image of obstacle 3

obs4_x_arr = [pos4x pos4x+obs4_w];
obs4_y_arr = [pos4y+obs4_h pos4y];
obs4 = image(obs4_x_arr, obs4_y_arr, obs4array);
%image of obstacle 4

obs5_x_arr = [pos5x pos5x+obs5_w];
obs5_y_arr = [pos5y+obs5_h pos5y];
obs5 = image(obs5_x_arr, obs5_y_arr,obs4array);
%image of obstacle 5

line(line1x,line1y,'Color',[b b b]);
%ground object

    end

%keylisteners--------------------------------------------------------------

function keydownlistener(~,eventdata)
    switch eventdata.Key
        case 'space'
            %if space is pressed
            if gamest > 2 && play == true && doublejump < allowedjump;
                %if the gameplay part of game is running and
                %if the player has not pressed space more than the allowed
                %number of times
                hero_v = hero_v_init;
                doublejump = doublejump + 1;
                offground = true;

            elseif gamest == 2 && play == true;
                %turn off the title screen if the game isn't running
                gamest = 3;
            end
        case 'q'
            play = false;
            %play quits the game
    end
end

%-MAIN SCRIPT--------------------------------------------------------------

arrayfcn
createsetting
%createsetting initializes game
while play
    ti_loop1 = tic();
    %elapsed time counter for each loop allows to normalize frame rate
    if gamest == 1
    game_titlesc
    %generate text and images once
    gamestatefcn
    %change gamest value to 2, then intro runs indefinitely
    elseif gamest == 3
    game_characters
    %generate characters once
    gamestatefcn
    %namely, change gamest value to 4, among other things
    elseif gamest == 4
    game_npcs
        if offground == true
        update_hero_loc
        %if the player isn't on the ground, also update location
        elseif offground == false
        score = score + 1;
        %only count score if the player is on the ground
        end
    game_constantrun
    %miscellaneous processes always run when the game is running
    game_over
    end
    moveobjects
    %always move objects, even during the title screen
    el_loop1 = toc(ti_loop1);
    pause(delay_t-el_loop1);
    %the pause amount is always the same
end
close(fig)
%end the function
end