function [var]=takeinput(s,lr,ur)
%% Advanced Propulsion 2015 | V 2.0
%NAME: RamJet Calculator TakeInput
%GOAL: This is the function used by this script to check if the values are between the prescribed bounds
%Created by: A.Ranjan | Date: 20.III.2015
%Imperial College London | Aeronautical Engineering | Dr David Birch | AE3-416

%% input
%s-name of variable
%lr-lower range
%ur-upper range

%% output
%var-variable

%% loop
for ctr=1:1:5%use a counter and a loop to try receiving input again if there is an invalid input
    if ctr==5%after 4 invalid inputs
        error('Input out of bounds. Please try running the code again with different inputs.');%display error message
    end
    var=input(['Please enter ',s,': \n']);%receive input
    if (var>=lr)&&(var<=ur)%if the input is in the required range
        break%then exit this loop
    else%otherwise
        disp([s,' must be between ', num2str(lr),' and ', num2str(ur),'.']);%inform the user of the range to try again
    end
end