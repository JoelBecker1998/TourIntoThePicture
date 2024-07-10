classdef ImageProperties < handle
    properties
        rectangleHandle = [];
        rectangleCorners = [];
        rectangleCorners2 = [];
        intersectionPoint2 = [];
        vanishingPoint = [];
        vanishingPointMarkers = [];
        vanishingLineHandles = [];
        foregroundHandle = {};
        lineHandle = {};
        p_FG2D = {};
        p_FG3D = {};
        p_2D = [];
        p_3D = [];
        imgSize = [];
        imgAxes = [];
        origImg = [];
        noForegroundImg = [];
        hAxes = [];
        hAxes2 = [];
        hAxes3 = [];
        rotatedHandle = [];
        rotatelineHandle = [];
        intersectPoint = [];
        objectDet = 0;
        debug = 0;
        Depth = 400;
        fov = [];
        instructionTextHandle = '';
        textHandle = '';
        currentFunction = '';
        hAxesIntro = [];
        threeDview_tab_text = '';
        tourIntoImageText = '';
        hAxesIntro1 = [];
        hAxesIntro2 = [];
        surfaces = {};
    end
    
    methods
        function setProperty(obj, propertyName, value)
            if isprop(obj, propertyName)
                % Handle cleanup for properties that need it
                if isa(obj.(propertyName), 'matlab.graphics.Graphics') || isa(obj.(propertyName), 'matlab.graphics.primitives.Line')
                    delete(obj.(propertyName));
                    
                elseif iscell(obj.(propertyName))
                    for i = length(obj.(propertyName)):-1:1
                        if ishandle(obj.(propertyName){i})
                            delete(obj.(propertyName){i});
                        end
                        obj.(propertyName)(i) = [];
                    end
                end
                
                % Set the new value
                obj.(propertyName) = value;
            else
                error('%s is not a valid property', propertyName);
            end
        end
        
        function value = getProperty(obj, propertyName)
            if isprop(obj, propertyName)
                value = obj.(propertyName);
            else
                error('%s is not a valid property', propertyName);
            end
        end

        function bool = allNecessaryInfoAvailable(obj)
            if ~isempty(obj.vanishingPointMarkers) && ~isempty(obj.rectangleHandle)
                bool = 1;
            else
                bool = 0;
            end
        end

        function append(obj, propertyName, value)
            % Method to add a graphical handle to the list
            obj.(propertyName){end+1} = value;
        end

        function resetStuff(~)

        end
    end
end

