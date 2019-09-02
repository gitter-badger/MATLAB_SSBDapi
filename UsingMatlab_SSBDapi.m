% Author: Kenneth H.L. Ho
% Copyright 2019 RIKEN BDR
% License: GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt 
%% 
%% Access image directly from SSBD database into MATLAB

% uses ssbdapi class defined in ssbdapi.m 
% using variable q to access ssbdapi class.
q = ssbdapi;

% Access SSBD and retrieve image id = 1, Z = 30, t = 0
k_img = q.image(1, 30, 0); 
imshow(k_img)
%%
% Accessing quantitative data from the SSBD database
% ssbd.bd5coords(bdml_id, time, offset, limit)
%
% here we access the data with bdmlID =4ed09fa3-7650-45a9-ac55-426980aa7d0a,ts=0, 

coords = q.bd5coords('bdmlID', '4ed09fa3-7650-45a9-ac55-426980aa7d0a', 'ts', 0, 'offset', 0, 'limit', 20)
% It returns two structures, meta and objects 
disp(coords.meta)
%%
% display the 2nd element of objects
coords.objects(2)
%%
% display objects - a structure.
disp(coords.objects)
%%
% display x coordinates within the objects
coords.objects.x
%%
% display x coordinates within the objects

coords.objects.y
%%
% display the x coordinates of the 2nd element of objects
coords.objects(2).x
%%
% finding the size of objects
size(coords.objects)
%%
% find the scaling factor of the dataset given the bdmlID = "4ed09fa3-7650-45a9-ac55-426980aa7d0a"
scale = q.bd5scaleunit("4ed09fa3-7650-45a9-ac55-426980aa7d0a")
%%
% scale returns 2 structure, meta and objects
% showing meta structure of scale. 
% this does not normally contain useful information.
scale.meta
%%
% scale objects return the scaling factors of the dataset
scale.objects
%%
% scaling factor for of x 
scale.objects.xScale
%% Analysis - plotting proliferation curve of _C. elegans_ by counting the number of nucleus
% 
bdmlid = '800faa21-c28c-4b72-bd12-d41f2eed02e8';
ts = 0; % time seris n
offset = 0;
limit = 1;
no_of_nucleus = [];
tsi = []; % time series index
resultdata = q.bd5coords('bdmlID', bdmlid, 'ts', ts, 'offset', offset, 'limit', limit)
disp(["ts=" ts]);
%%
% display the total number of objects
disp(resultdata.meta.total_count);
%%
% if the number of nucleus is more than zero, request the next time series index ts
% and retrieve the number of nucleus (nn) at each ts 
% put all the rsults in the array no_of_nucleus and 

nn = resultdata.meta.total_count;
while nn > 0
    no_of_nucleus = [no_of_nucleus nn];
    tsi = [tsi ts]; % advances ts by 1.
    ts=ts+1;
    try
        resultdata = q.bd5coords('bdmlID', bdmlid, 'ts', ts, 'offset', offset, 'limit', limit);
        disp(["ts=" ts "nn=" nn]);
        nn = resultdata.meta.total_count;
    catch
        disp("finished")
        nn = -1;
    end
end
%%
% disp(timept)
%%
% Plot out the proliferation curve - namely the number of nucleaus over time.
figure;
hold on
plot(tsi, no_of_nucleus);
hold off;
xlabel('Time series')
ylabel('Num of nucleus')
%%
% retrieve meta data from bdmlID = '800faa21-c28c-4b72-bd12-d41f2eed02e8'
resultdata = q.data('bdmlID', bdmlid)
%%
% show the result 1 of objects
resultdata.objects(1)
%%
% Re-plot the curve with title, organism and contributors
figure;
hold on
plot(tsi, no_of_nucleus);
hold off;
xlabel('Time series');
ylabel('Num of nucleus');
title([resultdata.objects(1).description ' ' resultdata.objects(1).organism]); % putting a title based on description and organism
text(10, 380, resultdata.objects(1).contributors); % list out the contributors
text(10, 360, resultdata.objects(1).method_summary); % list out the reference
%%
% Using ssbdapi.data to search for meta data - searching key basedon with value sim as in simulation 
resultdata = q.data('basedon','sim')
%%
% Displaying 20th element in objects
resultdata.objects(20)
%%
% searching for 'D. rerio' in the field 'organism'
resultdata = q.data('organism', 'D. rerio')
%%
% Displaying all the result
for i=1:size(resultdata.objects)
    disp(resultdata.objects(i))
end
%%
% searching for 'nucl' in the field 'title' - note: the default offset is 0 and limit is 20
resultdata = q.data('title', 'nuc');
% Displaying all the result
for i=1:size(resultdata.objects)
    disp(resultdata.objects(i))
end
%%
disp(resultdata.meta);
%%
% searching for 'nucl' in the field 'title' offset is 5 and limit is 25, i.e. fetch only 25 data items
resultdata = q.data('title', 'nuc','offset', 5, 'limit', 25)
%%
% Displaying all the result
for i=1:size(resultdata.objects)
    disp(resultdata.objects(i))
end
%%
% searching for 'elegans' as in C. elegans in the field 'organism'
resultdata = q.data('organism', 'elegans')
%%
% Displaying the result
for i=1:size(resultdata.objects)
    disp(resultdata.objects(i))
end

%%
% accessing the co-ordinates with bdmlID =4ed09fa3-7650-45a9-ac55-426980aa7d0a,ts=10,

no_of_nucleus = [];
timept = [];
resultdata = q.bd5coords('bdmlID','800faa21-c28c-4b72-bd12-d41f2eed02e8', 'ts', 10)
%%
% show the total number of data in bdmlID=4ed09fa3-7650-45a9-ac55-426980aa7d0a,ts=10

resultdata.meta.total_count
% show the result of x coordinates
resultdata.objects.x

%%
% accessing the co-ordinates with bdmlID =4ed09fa3-7650-45a9-ac55-426980aa7d0a,ts=0,
% offset is 2 and limit is 2, i.e. 2 data items.

resultdata = q.bd5coords('bdmlID','800faa21-c28c-4b72-bd12-d41f2eed02e8', 'ts', 10, 'offset', 2, 'limit', 2)
% show the total number of data in bdmlID=4ed09fa3-7650-45a9-ac55-426980aa7d0a,ts=0
resultdata.meta.total_count
% show the result of x coordinates

resultdata.objects.x