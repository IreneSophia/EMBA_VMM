#-- scenario file --#
# (c) Irene Sophia Plank, questions? Contact: 10planki@gmail.com

active_buttons = 6; # how many of the keyboard buttons can be used in the scenario

# what exactly do you want to log?

stimulus_properties = type, string, run, number, trl, number, f1, number, f2, number, f3, number, f4, number, cnd, number, trlb, number, lnb, number, flp, number, flp_rel, number, dur, number;

default_background_color = 110, 110, 110; # grey
default_text_color = 0, 0, 0; # black
default_trial_type = first_response;   
response_matching = simple_matching;   
default_font_size = 28; 
default_font = "Arial";

# fmri stuff
scenario_type = fMRI; # fMRI_emulation
pulse_code = 255;
pulses_per_scan = 1;
scan_period = 2451;

##------------------------- SDL -------------------------##

begin; 

# Define trials for CALIBRATION

#this is the SDL definition for the EyeLink camera setup/calibration instructions
picture {
	text{
		caption = "Press any key to go into Camera Setup mode.  From there...\n
			Press RETURN (on either display computer or tracker host computer) 
			to toggle camera image\n
			Use left and right arrows to switch transferred image\n
			Press C to Calibrate\n
			Press V to Validate\n
			Press O for Output/Record (when ready to start experiment)\n";
		font_size = 14;
		text_align =align_left;
	};
	x = 0; y = 0;
} calibration_instructions;

#this is the SDL definition for the EyeLink dummy mode camera setup/calibration instructions
picture {
	text{
		caption = "Press any key to go into Camera Setup mode.  From there...\n
			Press Esc to advance (since Dummy Mode is currently active)";
		font_size = 14;
		text_align =align_left;
	};
	x = 0; y = 0;
} calibration_instructions_dummy;

#this is the SDL definition for the calibration/drift check
picture {
} et_calibration;

# Define variables for EXPERIMENT

$df  = 542;  # duration of fixation cross (intertrial interval) minus half refresh period (8 for 60Hz)
$dp  = 192;  # duration of the picture minus half refresh period (8 for 60Hz)
$db  = 2992; # duration of inter block interval minus half refresh period (8 for 60Hz)
$xl  = -210; # how much left
$xr  = +210; # how much right
$yu  = +240; # how much up
$yd  = -100; # how much down
$yfh = 52;   # actual new middle point 
$lw  = 2;    # line width for fixation crosses
$yfd = 31;   # new middle point - 21
$yfu = 72;   # new middle point + 20

# Stimulus array

array {
	bitmap { filename = "ff_10_g.bmp"; };
	bitmap { filename = "ff_10_r.bmp"; };
	bitmap { filename = "ff_1_g.bmp"; };
	bitmap { filename = "ff_1_r.bmp"; };
	bitmap { filename = "ff_2_g.bmp"; };
	bitmap { filename = "ff_2_r.bmp"; };
	bitmap { filename = "ff_3_g.bmp"; };
	bitmap { filename = "ff_3_r.bmp"; };
	bitmap { filename = "ff_4_g.bmp"; };
	bitmap { filename = "ff_4_r.bmp"; };
	bitmap { filename = "ff_5_g.bmp"; };
	bitmap { filename = "ff_5_r.bmp"; };
	bitmap { filename = "ff_6_g.bmp"; };
	bitmap { filename = "ff_6_r.bmp"; };
	bitmap { filename = "ff_7_g.bmp"; };
	bitmap { filename = "ff_7_r.bmp"; };
	bitmap { filename = "ff_8_g.bmp"; };
	bitmap { filename = "ff_8_r.bmp"; };
	bitmap { filename = "ff_9_g.bmp"; };
	bitmap { filename = "ff_9_r.bmp"; };
	bitmap { filename = "fh_10_g.bmp"; };
	bitmap { filename = "fh_10_r.bmp"; };
	bitmap { filename = "fh_1_g.bmp"; };
	bitmap { filename = "fh_1_r.bmp"; };
	bitmap { filename = "fh_2_g.bmp"; };
	bitmap { filename = "fh_2_r.bmp"; };
	bitmap { filename = "fh_3_g.bmp"; };
	bitmap { filename = "fh_3_r.bmp"; };
	bitmap { filename = "fh_4_g.bmp"; };
	bitmap { filename = "fh_4_r.bmp"; };
	bitmap { filename = "fh_5_g.bmp"; };
	bitmap { filename = "fh_5_r.bmp"; };
	bitmap { filename = "fh_6_g.bmp"; };
	bitmap { filename = "fh_6_r.bmp"; };
	bitmap { filename = "fh_7_g.bmp"; };
	bitmap { filename = "fh_7_r.bmp"; };
	bitmap { filename = "fh_8_g.bmp"; };
	bitmap { filename = "fh_8_r.bmp"; };
	bitmap { filename = "fh_9_g.bmp"; };
	bitmap { filename = "fh_9_r.bmp"; };
	bitmap { filename = "mf_10_g.bmp"; };
	bitmap { filename = "mf_10_r.bmp"; };
	bitmap { filename = "mf_1_g.bmp"; };
	bitmap { filename = "mf_1_r.bmp"; };
	bitmap { filename = "mf_2_g.bmp"; };
	bitmap { filename = "mf_2_r.bmp"; };
	bitmap { filename = "mf_3_g.bmp"; };
	bitmap { filename = "mf_3_r.bmp"; };
	bitmap { filename = "mf_4_g.bmp"; };
	bitmap { filename = "mf_4_r.bmp"; };
	bitmap { filename = "mf_5_g.bmp"; };
	bitmap { filename = "mf_5_r.bmp"; };
	bitmap { filename = "mf_6_g.bmp"; };
	bitmap { filename = "mf_6_r.bmp"; };
	bitmap { filename = "mf_7_g.bmp"; };
	bitmap { filename = "mf_7_r.bmp"; };
	bitmap { filename = "mf_8_g.bmp"; };
	bitmap { filename = "mf_8_r.bmp"; };
	bitmap { filename = "mf_9_g.bmp"; };
	bitmap { filename = "mf_9_r.bmp"; };
	bitmap { filename = "mh_10_g.bmp"; };
	bitmap { filename = "mh_10_r.bmp"; };
	bitmap { filename = "mh_1_g.bmp"; };
	bitmap { filename = "mh_1_r.bmp"; };
	bitmap { filename = "mh_2_g.bmp"; };
	bitmap { filename = "mh_2_r.bmp"; };
	bitmap { filename = "mh_3_g.bmp"; };
	bitmap { filename = "mh_3_r.bmp"; };
	bitmap { filename = "mh_4_g.bmp"; };
	bitmap { filename = "mh_4_r.bmp"; };
	bitmap { filename = "mh_5_g.bmp"; };
	bitmap { filename = "mh_5_r.bmp"; };
	bitmap { filename = "mh_6_g.bmp"; };
	bitmap { filename = "mh_6_r.bmp"; };
	bitmap { filename = "mh_7_g.bmp"; };
	bitmap { filename = "mh_7_r.bmp"; };
	bitmap { filename = "mh_8_g.bmp"; };
	bitmap { filename = "mh_8_r.bmp"; };
	bitmap { filename = "mh_9_g.bmp"; };
	bitmap { filename = "mh_9_r.bmp"; };
} bits;

# Lines for fixation cross
line_graphic {
   coordinates = 0, $yfu, 0, $yfd;   #0, 20, 0, -21;
	coordinates = -15, $yfh, 16, $yfh;   #-15, 0, 16, 0;
   line_width = $lw;
	line_color = 0, 0, 0;
}cross;

# Trials

trial { # picture cue
   trial_duration = $dp; # how long is stimulus shown
	trial_type = fixed; 
   stimulus_event {
      picture { bitmap { filename = " "; preload = false; } bit1; x = $xl; y = $yu; 
					 bitmap { filename = " "; preload = false; } bit2; x = $xr; y = $yu; 
					 bitmap { filename = " "; preload = false; } bit3; x = $xl; y = $yd; 
					 bitmap { filename = " "; preload = false; } bit4; x = $xr; y = $yd; 
					 line_graphic cross; x = 0; y = 0; 
		} pic_pic;
	code = " ";
	response_active = true;
   } pic_event; # name of event
} pic_trial; # name of trial

trial { # fixation cross
	trial_duration = $df ;
	trial_type = fixed; 
	stimulus_event {
		picture {
			line_graphic cross; x = 0; y = 0; 
		};
		response_active = true;
		code = " ";   
	}fix_event;
} fix_trial;

trial { # blank screen   
	trial_duration = 1 ;
	trial_type = fixed;
	stimulus_event {
		picture {
			text { 
				caption = 
				" ";}; 
			x = 0; y = 0; 
		};
	}wait_event;
} wait_trial;

trial { # start before mri     
   trial_type = specific_response;
	trial_duration = forever ;
	terminator_button = 5 ;    
   stimulus_event {
      picture {
			bitmap { filename = "warten.png"; preload = true;}; 
			x = 0; # position x-axis
			y = 0; # position y-axis
      };
		code = "start";
	} start_event;         
} start_trial;

trial { # drift check between  
   trial_type = specific_response;
	trial_duration = forever ;
	terminator_button = 5 ;    
   stimulus_event {
      picture {
			bitmap { filename = "pause.png"; preload = true;}; 
			x = 0; # position x-axis
			y = 0; # position y-axis
      };
		code = "break";
	} break_event;         
} break_trial;

trial { # drift check between  
   trial_type = specific_response;
	trial_duration = forever ;
	terminator_button = 5 ;   
   stimulus_event {
      picture {
			bitmap { filename = "driftcheck.png"; preload = true;}; 
			x = 0; # position x-axis
			y = 0; # position y-axis
      };
		code = "drift";
	} middle_event;         
} middle_trial;

##------------------------- PCL -------------------------##

begin_pcl;

string subject = logfile.subject(); 
if subject.count() < 1 then
	subject = "test";
end;

# set the design file
preset string order = "Welches Design? 1-40";

# Variables

int tpr = 595*2; # trials per run
string des_name;
int flip;
int pcount;
string r;

### STEP 1: a)INITIALIZE EYELINK CONNECTION; b)OPEN EDF FILE; c)SET DISPLAY PARAMETERS

# STEP 1a INITIALIZE EYELINK CONNECTION
#initialize PresLink.
eye_tracker tracker = new eye_tracker( "PresLink" );

#setting dummy_mode to 1 will enable Dummy mode, 
#allowing the script to run without an eye tracker
#to disable Dummy Mode, set dummy_mode to 0
int dummy_mode = 0;
if dummy_mode == 1 then
	tracker.set_parameter("tracker_address", "");
end;         

#if your Host PC is using a different IP address than its default 100.1.1.1
#then you can configure the IP address to which the script will attempt to connect
#by changing the tracker_address parameter.  Uncomment this command to use it.
#If your Host PC is using the default 100.1.1.1 address then you do not need to send this command.  
#tracker.set_parameter("tracker_address", "10.10.10.70");

#connect to Eyelink tracker.
tracker.start_tracking();

# STEP 1b OPEN EDF FILE
#Get the value entered for the "Enter Subject Name/ID" dialog when the script is run.
#Note - make sure the experiment is set to Prompt under Settings -> Logfiles -> Subject Name/ID
#If the script is run from the Editor then the value will always be the default "test"
#If the script is run from the Main tab then the value will be the value 
#entered in the dialog that will appear when the script is run
#Note, EDF Filename needs to be no more than 8 characters long 
#(letters, numbers and underscores only)
#If the script is run from the Editor tab then if there is already
#an exising file named "test.edf" it will be overwritten
#For any other specified EDF filename, the script will check to see 
#if the filename already exists and will abort the script if so
string edf_name = logfile.subject();
if edf_name.count() == 0 then
	edf_name = "test"
end;
if edf_name.count() > 8 then
	edf_name.resize( 8 );
end;

#Tell the Host PC to open the EDF file
tracker.set_parameter("open_edf_file",edf_name+".edf");

# STEP 1c SET DISPLAY PARAMETERS
#create variables to store the monitor's width and height in pixels
int display_height = display_device.height();
int display_width  = display_device.width();

#this sends a command to set the screen_pixel_coords parameter on the Host PC, 
#which formats the eye position data to match that of the screen resolution
tracker.send_command("screen_pixel_coords 0 0 " + string(display_width-1) + 
	" " + string(display_height-1));
	
#this sends a message to the EDF tells Data Viewer the resolution of the experiment 
#so that it can format its Trial View window appropriately
tracker.send_message("DISPLAY_COORDS " + "0 0 " + string(display_width-1) + 
	" " + string(display_height-1)); 
	
term.print("\nDisplay height: " + string(display_height));
term.print("\nDisplay width: " + string(display_width));

#####  STEP 2: a) GET TRACKER VERSION; b)SELECT AVAILABLE SAMPLE/EVENT DATA
### See EyeLink Programmers Guide > Useful EyeLink Commands > File Data Control & Link Data Control

### STEP 2a GET TRACKER VERSION
#Get EyeLink tracker type and software version
#tracker_ver will be 'EYELINK II x.xx', 'EYELINK CL x.xx' , etc. 
#where 'x.xx' is the software version
#The version number will be 2.x for the EyeLink II, 4.x for the EyeLink 1000,
#5.x for the EyeLink 1000 Plus, or 6.x for the EyeLink Portable Duo
string tracker_ver = tracker.get_parameter("tracker_version");
term.print("\nTracker version: " + tracker_ver);

#tracker_ver will be something like EYELINK CL 4.48, but we want to get the 4.48
array <string> string_array[5];
tracker_ver.split(" ",string_array);
double tr_v = 0.0;
if string_array.count() > 1 then
	tr_v = double(string_array[3]); #Host PC software version will be tr_v
end;

### Step 2b SELECT AVAILABLE SAMPLE/EVENT DATA
#Select which events are saved in the EDF file. Include everything just in case
tracker.send_command("file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT");	 
tracker.send_command("link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON,INPUT");

#First, check tracker version so as to determine whether to include 'HTARGET' 
#to save head target sticker data for supported eye trackers
#Then, send commands to set the file_sample_data and link_sample_data parameters, 
#which specify which aspects of sample data will be recorded to the EDF file 
#and which will be available over the Ethernet link between the Host PC and Display PC
if (tr_v >=4.0) then
	#include HTARGET (head target) data if tracker is EyeLink 1000 or later
	tracker.send_command("file_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET,INPUT");
	tracker.send_command("link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET,INPUT");
else
	tracker.send_command("file_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,INPUT");
	tracker.send_command("link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT"); 
end;

#####  STEP 3: a)SET CALIBRATION PARAMETERS; b)CALIBRATE EYE TRACKER

### STEP 3a SET CALIBRATION PARAMETERS
#this will allow you to change the calibration background color to something different 
#than that of the value of $bg_color in the Scenarion Header Parameter section
#et_calibration.set_background_color(0,0,0);

#this will allow you to use a custom image file for the target
#it needs to be a 24 bit BMP file
#otherwise the default crosshairs target will be displayed.
#Important note:  the BMP file should have a pixel size that is a multiple of 4
#For example, 64px x 64px.  Or 48px x 48px
#Sizes that are not multiples of 4 will result in the target appearing distorted
#tracker.set_parameter("target_file",stimulus_directory + "fixTarget.bmp");

#setting the enable_cal_sound to 0 will disable calibration sounds
#tracker.set_parameter("enable_cal_sound","0");

#This sets the number of calibration/validation targets and spread
#options include horizontal-only(H) or horizontal-vertical(HV), H3, HV3, HV5, HV9 or HV13
tracker.send_command("calibration_type = HV9");

#Optional: shrink the spread of the calibration/validation targets <x, y display proportion>
#if default outermost targets are not all visible in the bore.
#Default spread is 0.88, 0.83 (88% of the display horizontally and 83% vertically)
tracker.send_command("calibration_area_proportion = 0.75 0.80");
tracker.send_command("validation_area_proportion = 0.75 0.80");

#This presents the calibration instructions and then waits for any key to be pressed
if dummy_mode == 1 then
	calibration_instructions_dummy.present();
else
	calibration_instructions.present();
end;
system_keyboard.set_max_length(1);
system_keyboard.get_input();

#clear any previous calibration targets
et_calibration.clear(); 
et_calibration.present();

#The camera image zoom level can be modified to suit the screen resolution 
#To update the zoom level set the parameter cam_image_zoom_factor with desired zoom value. 
#The zoom value can be 1 to 5. 
#By default, this is set to a value that covers about 50% of the screen resolution.
#zoom the camera image 4 times.  Can uncomment to make adjustments
#tracker.set_parameter("cam_image_zoom_factor","4");

### STEP 3b: CALIBRATE EYE TRACKER
#start EyeLink Camera Setup, which allows for camera image transfer, calibration, and validation. 
tracker.calibrate( et_calibrate_default, 1.0, 0.0, 0.0 );

##### CLEANUP SUBROUTINE -- CALLED WHEHN THE SCRIPT ENDS #######################################

#this subroutine is called at the end of the script or if the Esc key is pressed during 
#the trial image presentation
#it closes the EDF file, and transfers it over to the logfile directory of the experiment on the Display PC
sub cleanup begin
	
	#it's important to put the Host PC in Offline mode before closing/transferring the file
	tracker.send_command("set_idle_mode"); 
	
	#clear Host PC screen at end of session
	tracker.send_command("clear_screen 0");
	
	#wait 500 msec after setting offline mode before closing/transferring the file
	wait_interval(500); 
	
	#close the EDF file and then allow 100 msec to ensure it's closed
	tracker.set_parameter("close_data_file","");

	#transfer the EDF file to the logfile directory of the experiment	on the Display PC
	if dummy_mode != 1 then
		tracker.set_parameter("get_edf_file",logfile_directory + edf_name + ".edf");
	end;
	tracker.stop_tracking();
	
	#save the logfile (useful in case the experiment is exited early with an Esc key press)
	logfile.save();
end;
############# END CLEANUP SUBROUTINE #############################################################

## --------------- Start of Experiment

# BEGIN FIRST RUN

start_trial.present();

input_file des = new input_file; # makes a new input file
des_name = "Designs\\des-" + order + "_2.txt";
des.open(des_name); # gives the name of the file and opens it
	
# wait 5 scans at beginning of each run
pcount = pulse_manager.main_pulse_count();
wait_trial.present();
loop until (pulse_manager.main_pulse_count() >= pcount + 5)
begin
end;

# put design into an empty array
array <int> array_des[ tpr ][ 10 ]; # makes an empty array...

loop # ... and fills it
	int i = 1; 
	until i > tpr
begin
	array_des[i][1]  = des.get_int(); # face 1
	array_des[i][2]  = des.get_int(); # face 2
	array_des[i][3]  = des.get_int(); # face 3
	array_des[i][4]  = des.get_int(); # face 4
	array_des[i][5]  = des.get_int(); # condition: hg = 1, hr = 2, fg = 3, fr = 4
	array_des[i][6]  = des.get_int(); # trial number within block
	array_des[i][7]  = des.get_int(); # length of block
	array_des[i][8]  = des.get_int(); # is there a flip?
	array_des[i][9]  = des.get_int(); # when was the flip?
	array_des[i][10] = des.get_int(); # which block?
	i = i + 1
end;

#start eye tracker recording and then wait 100 msec 
#to ensure the tracker has properly started recording before the trial's stimuli are presented
tracker.set_recording(true);
wait_interval(100); 

# loop through trials here
loop int t = 1 until t > tpr begin
	
	# add the correct faces
	pic_pic.set_part( 1, bits[ array_des[t][1] ] );
	pic_pic.set_part( 2, bits[ array_des[t][2] ] );
	pic_pic.set_part( 3, bits[ array_des[t][3] ] );
	pic_pic.set_part( 4, bits[ array_des[t][4] ] );
	
	# Write a TRIALID message to EDF file: this marks the start of a trial for DataViewer
    # See DataViewer manual section: Protocol for EyeLink Data to Viewer Integration 
	# > Defining the Start and End of a Trial
	tracker.send_message("TRIALID " + string(t));
	
	# present the face
	pic_event.set_event_code("pic," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
	pic_trial.present();
	
	# send a TRIAL_RESULT message to EDF file: this marks the end of a trial for DataViewer
    # See DataViewer manual section: Protocol for EyeLink Data to Viewer Integration 
	# > Defining the Start and End of a Trial
	tracker.send_message("TRIAL_RESULT 0");
	
	# check if there is a flip in the ISI
	flip = array_des[ t ][ 8 ];
	if (flip == 1) then
		# present the "old" fixation cross for the specified duration
		fix_trial.set_duration( array_des[ t ][ 9 ] - 8);
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
		fix_trial.present();
		# present the "new" fixation cross for the remainder of the ISI
		tracker.send_message("FLIP " + string(t));
		cross.rotate_90( 90 );
		fix_trial.set_duration( 542 - array_des[ t ][ 9 ]);
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",1," + string(array_des[t][9]));
		fix_trial.present();
	else 
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
		fix_trial.set_duration( 542 );
		fix_trial.present();
	end;
	
	t = t + 1;
	
	if (t == 596) then
		# wait 5 scans between blocks
		pcount = pulse_manager.main_pulse_count();
		wait_trial.present();
		loop until (pulse_manager.main_pulse_count() >= pcount + 5)
		begin
		end;
	end;
end;

#add a 100 msec pause at the end of the trial before stopping recording 
#to pick up the tail end of any eye events
wait_interval(100);
	
#stop eye tracker recording
tracker.set_recording(false);

break_trial.present();
middle_trial.present();

#Do a drift correct/drift check
#parameter1 contains the drift correct options while parameter2 and parameter3 specify 
#target X, Y center location.
#parameter1 in most cases should be set to 7.0.  parameter1 should be a value that is 
#based on a binary value (LSB) which is then converted to a double. 
#For example, 111 corresponds to 7.0, 101 corresponds to 5.0, and 011 corresponds to 3.0.  
#The least significant bit in the binrary version of the number (the right-most bit) indicates 
#it is indeed drift check/correct, the bit to the left of it indicates whether to draw the target, 
#and the bit next to it determines whether to allow the experimenter to escape into Camera Setup 
#to performa a calibration/validation if they wish (1 if allow, 0 if not).  
#setting the enable_dc_sound to 0 will disable drift correct/drift check sounds
tracker.set_parameter("enable_dc_sound","0");
tracker.calibrate( et_calibrate_drift_correct, 7.0, 0.0, 0.0 );

start_trial.present();

des = new input_file; # makes a new input file
des_name = "Designs\\des-" + order + "_4.txt";
des.open(des_name); # gives the name of the file and opens it
	
# wait 5 scans at beginning of each run
pcount = pulse_manager.main_pulse_count();
wait_trial.present();
loop until (pulse_manager.main_pulse_count() >= pcount + 5)
begin
end;

# put design into an empty array
array_des[ tpr ][ 10 ]; # makes an empty array...

loop # ... and fills it
	int i = 1; 
	until i > tpr
begin
	array_des[i][1]  = des.get_int(); # face 1
	array_des[i][2]  = des.get_int(); # face 2
	array_des[i][3]  = des.get_int(); # face 3
	array_des[i][4]  = des.get_int(); # face 4
	array_des[i][5]  = des.get_int(); # condition: hg = 1, hr = 2, fg = 3, fr = 4
	array_des[i][6]  = des.get_int(); # trial number within block
	array_des[i][7]  = des.get_int(); # length of block
	array_des[i][8]  = des.get_int(); # is there a flip?
	array_des[i][9]  = des.get_int(); # when was the flip?
	array_des[i][10] = des.get_int(); # which block?
	i = i + 1
end;

#start eye tracker recording and then wait 100 msec 
#to ensure the tracker has properly started recording before the trial's stimuli are presented
tracker.set_recording(true);
wait_interval(100); 

# loop through trials here
loop int t = 1 until t > tpr begin
	
	# add the correct faces
	pic_pic.set_part( 1, bits[ array_des[t][1] ] );
	pic_pic.set_part( 2, bits[ array_des[t][2] ] );
	pic_pic.set_part( 3, bits[ array_des[t][3] ] );
	pic_pic.set_part( 4, bits[ array_des[t][4] ] );
	
	# Write a TRIALID message to EDF file: this marks the start of a trial for DataViewer
    # See DataViewer manual section: Protocol for EyeLink Data to Viewer Integration 
	# > Defining the Start and End of a Trial
	tracker.send_message("TRIALID " + string(t));
	
	# present the face
	pic_event.set_event_code("pic," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
	pic_trial.present();
	
	# send a TRIAL_RESULT message to EDF file: this marks the end of a trial for DataViewer
    # See DataViewer manual section: Protocol for EyeLink Data to Viewer Integration 
	# > Defining the Start and End of a Trial
	tracker.send_message("TRIAL_RESULT 0");
	
	# check if there is a flip in the ISI
	flip = array_des[ t ][ 8 ];
	if (flip == 1) then
		# present the "old" fixation cross for the specified duration
		fix_trial.set_duration( array_des[ t ][ 9 ] - 8);
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
		fix_trial.present();
		# present the "new" fixation cross for the remainder of the ISI
		tracker.send_message("FLIP " + string(t));
		cross.rotate_90( 90 );
		fix_trial.set_duration( 542 - array_des[ t ][ 9 ]);
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",1," + string(array_des[t][9]));
		fix_trial.present();
	else 
		fix_event.set_event_code("fix," + string(array_des[t][10]) + "," + string(t) + "," + string(array_des[t][1]) + "," + string(array_des[t][2]) + "," + string(array_des[t][3]) + "," + string(array_des[t][4]) + "," + string(array_des[t][5]) + "," + string(array_des[t][6]) + "," + string(array_des[t][7]) + "," + string(array_des[t][8]) + ",0," + string(array_des[t][9]));
		fix_trial.set_duration( 542 );
		fix_trial.present();
	end;
	
	t = t + 1;
	
	if (t == 596) then
		# wait 5 scans between blocks
		pcount = pulse_manager.main_pulse_count();
		wait_trial.present();
		loop until (pulse_manager.main_pulse_count() >= pcount + 5)
		begin
		end;
	end;
end;

#add a 100 msec pause at the end of the trial before stopping recording 
#to pick up the tail end of any eye events
wait_interval(100);
	
#stop eye tracker recording
tracker.set_recording(false);

##### STEP 5: a)CALL THE CLEANUP FUNCTION TO CLOSE THE EDF AND 
##### TRANSFER IT TO THE DISPLAY PC's EXPERIMENT LogFiles folder
cleanup();

start_trial.present();
