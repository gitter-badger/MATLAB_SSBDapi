% Author: Kenneth H.L. Ho
% Copyright 2019 RIKEN BDR
% License: GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt 
%% Create a Class function to interface with SSBD

classdef ssbdapi
    properties (Constant) 
        ImageApi = 'http://ssbd.qbic.riken.jp/image/webgateway/render_image';
        urlbase = 'http://ssbd.qbic.riken.jp/SSBD/api/v3';
        fmt = '?format=json';
    end
    methods
        %% Create a simple interface to interact with SSBD-OMERO API
        function obj = image(obj, id, z, t)
            %api ='http://ssbd.qbic.riken.jp/image/webgateway/render_image';
            fprintf("id: %d, z: %d, t: %d \n", id, z, t);
            url = sprintf("%s/%d/%d/%d", obj.ImageApi, id, z, t);
            disp(url);
            obj = webread(url);
            %imshow(rgb);
            %rgb = url;
        end
        % current API only allows searching for single field. 
        % a more elaborate way is to search for mutiple fields.
        function obj = data(obj, varargin) % field, search
            minInputs = 3; % at least 2 arguments
            maxInputs = 7; % limited to one search field, i.e. 2 arguments for field and search, plus offset and limit
            % maxInputs = Inf; % if you want to search multiple fields
            narginchk(minInputs,maxInputs);
            offset = 0;
            limit = 20;
            field = [];
            apifunc = 'data';
            allowed_fields = {'bdmlID', 'localID','organism', ...
                'contributors', 'basedon', 'title', 'description', ...
                'datatype', 'gene', 'method_summary'};
            special_fields = {'offset', 'limit'};
            for k = 1:2:(nargin-1)
                if ismember(varargin{k}, allowed_fields)
                    field = varargin{k};
                    search = varargin{k+1};
                elseif ismember(varargin{k}, special_fields)
                    % disp(class(varargin{k+1}));
                    if strcmp(varargin{k},'offset')
                       if isa(varargin{k+1}, 'double')
                            offset = varargin{k+1};
                       else
                            disp("error: offset is not a double");
                            return;
                       end
                   elseif strcmp(varargin{k},'limit')
                       if isa(varargin{k+1}, 'double')
                            limit = varargin{k+1};
                       else
                           disp("error: limit is not a double");
                           return;
                       end
                   else
                       disp("error: something really wrong") % this is not needed really.
                       return;
                   end
                else
                    disp(["error: not recognised term" varargin{k}])
                    return;
                end
            end
            disp(["offset:" offset "limit:" limit]);
            if ismember(field, allowed_fields) 
                url = sprintf("%s/%s/%s&%s__icontains=%s&offset=%d&limit=%d\n", obj.urlbase, apifunc, obj.fmt, field, search, offset, limit);
                disp(url);
                obj = webread(url);
            else
                disp("error: no such field");
                return;
            end
            % bdmldata= obj.ssbd_get(field, search)
        end
            
 %       function obj = bd5coords(obj, bdmlid, timept, offset, limit)
        function obj = bd5coords(obj, varargin)
            minInputs = 5; % at least 2 arguments
            maxInputs = 9; % limited to one search field, i.e. 2 arguments for field and search, plus offset and limit
            % maxInputs = Inf; % if you want to search multiple fields
            narginchk(minInputs,maxInputs);
            offset = 0;
            limit = 20;
            apifunc = 'bd5coords';
            allowed_fields = {'bdmlID', 'ts'};
            special_fields = {'offset', 'limit'};
            for k = 1:2:(nargin-1)
               if ismember(varargin{k}, allowed_fields)
                    if strcmp(varargin{k},'bdmlID')
                       if isa(varargin{k+1}, 'char')
                            bdmlid = varargin{k+1};
                       else
                            disp("error: bdmlID is not a string");
                            return;
                       end
                    elseif strcmp(varargin{k},'ts')
                       if isa(varargin{k+1}, 'double')
                            ts = varargin{k+1};
                       else
                           disp("error: ts is not a number");
                           return;
                       end
                    else
                       disp("error: something really wrong") % this is not needed really.
                       return;
                    end
               elseif ismember(varargin{k}, special_fields)
                    % disp(class(varargin{k+1}));
                    if strcmp(varargin{k},'offset')
                       if isa(varargin{k+1}, 'double')
                            offset = varargin{k+1};
                       else
                            disp("error: offset is not a number");
                            return;
                       end
                    elseif strcmp(varargin{k},'limit')
                       if isa(varargin{k+1}, 'double')
                            limit = varargin{k+1};
                       else
                           disp("error: limit is not a number");
                           return;
                       end
                    else
                       disp("error: something really wrong") % this is not needed really.
                       return;
                    end
                else
                    disp(["error: not recognised term" varargin{k}])
                    return;
               end
            end
            if ( exist('ts', 'var') ==1 && exist('bdmlid', 'var') == 1)
                fprintf("bdmlID=%s, ts=%d, offset=%d, limit=%d\n", bdmlid, ts, offset, limit);
                url = sprintf("%s/%s/%s&bdmlID=%s&ts=%d&offset=%d&limit=%d\n", obj.urlbase, apifunc, obj.fmt, bdmlid, ts, offset, limit);
                disp(url);
                obj = webread(url);
            else
                disp("error: either bdmlID or ts was not defined")
            end
        end
        function obj = bd5scaleunit(obj,bdmlid)
            %urlbase = 'http://ssbd.qbic.riken.jp/SSBD/api/v3';
            apifunc = 'bd5scaleunit';
            fprintf("bdmlID=%s\n", bdmlid);
            offset = 0;
            limit = 1;
            url = sprintf("%s/%s/%s&bdmlID=%s&offset=%d&limit=%d\n", obj.urlbase, apifunc, obj.fmt, bdmlid, offset, limit);
            disp(url);
            obj = webread(url);
        end 
    end
end