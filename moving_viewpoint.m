function moving_viewpoint(imageProp)
    % Create a camera inside the 3D plot and enable camera movement

    % Starting position (unchanged)
    middle_back_wall_position_x = imageProp.p_3D(7, 1) + 0.5 * (imageProp.p_3D(8, 1) - imageProp.p_3D(7, 1));
    middle_back_wall_position_y = imageProp.p_3D(7, 2) + 0.5 * (imageProp.p_3D(1, 2) - imageProp.p_3D(7, 2));
    middle_back_wall_position_z = min([imageProp.p_3D(9, 3), imageProp.p_3D(10, 3), ...
        imageProp.p_3D(11, 3), imageProp.p_3D(12, 3), imageProp.p_3D(3, 3), ...
        imageProp.p_3D(4, 3), imageProp.p_3D(5, 3), imageProp.p_3D(6, 3)]);

    % 2. Camera movement and image creation
    camproj('perspective');
    axis tight;
    xticks('auto');
    yticks('auto');

    axis off; % Remove the axes

    width = imageProp.imgSize(2);
    height = imageProp.imgSize(1);

    % Set initial camera position
    initialCameraPosition = [imageProp.vanishingPoint(1), imageProp.vanishingPoint(2), middle_back_wall_position_z];
    set(gca, 'CameraPosition', initialCameraPosition);

    % Set initial camera target
    initialCameraTarget = [imageProp.vanishingPoint(1), imageProp.vanishingPoint(2), 0];
    camtarget(gca, initialCameraTarget);

    % Set camera rotation
    camup([0, -1, 0])
    camorbit(0, 0, 'camera', [0 0 1]);

    hold off;

    % set camera width
    camva(80); % Blickwinkel Mensch

    % Capture initial camera position and target for movement
    currentCameraPosition = initialCameraPosition;
    currentCameraTarget = initialCameraTarget;

    % Define boundaries for camera movement
    x_min = min(imageProp.p_3D(:, 1));
    x_max = max(imageProp.p_3D(:, 1));

    y_min = min(imageProp.p_3D(:, 2));
    y_max = max(imageProp.p_3D(:, 2));

    z_min = 0;
    z_max = max([imageProp.p_3D(9, 3), imageProp.p_3D(10, 3), ...
        imageProp.p_3D(11, 3), imageProp.p_3D(12, 3), imageProp.p_3D(3, 3), ...
        imageProp.p_3D(4, 3), imageProp.p_3D(5, 3), imageProp.p_3D(6, 3)]);

    % Allow extansion of z-boundaries
    z_boundary_extansion = 300;

    % Keyboard callback function for camera movement
    set(gcf, 'KeyPressFcn', @moveCamera);

    function moveCamera(~, event)
        % Normalized stepsize * speed factor
        x_stepSize = ((x_max - x_min) / 100) * 2;
        y_stepSize = ((x_max - x_min) / 100) * 1.5;
        z_stepSize = ((z_max - z_min) / 100) * 1;

        angle_step_size = 15;

        % Update camera position and target based on key presses
        switch event.Key
            % Movement
            case 'w' % Move forward
                % Check front boundary
                if currentCameraPosition(3) - z_stepSize >= z_min
                    currentCameraTarget(3) = currentCameraTarget(3) - z_stepSize;
                    currentCameraPosition(3) = currentCameraPosition(3) - z_stepSize;

                    % Diagonal forward movement
                    % Check Camera Orientation
                    if abs(currentCameraPosition(1) - currentCameraTarget(1)) > 3 * x_stepSize % allow certain diviation

                        % Check left diagonal movement
                        if currentCameraPosition(1) > currentCameraTarget(1)
                            % Check left boundary
                            if currentCameraPosition(1) - x_stepSize >= x_min
                                currentCameraTarget(1) = currentCameraTarget(1) - x_stepSize;
                                currentCameraPosition(1) = currentCameraPosition(1) - x_stepSize;
                            end
                        end

                        % Check right diagonal movement
                        if currentCameraPosition(1) < currentCameraTarget(1)
                            % Check right boundary
                            if currentCameraPosition(1) + x_stepSize <= x_max
                                currentCameraTarget(1) = currentCameraTarget(1) + x_stepSize;
                                currentCameraPosition(1) = currentCameraPosition(1) + x_stepSize;
                            end
                        end
                    end
                end

            case 's' % Move backward
                % Check back boundary
                if currentCameraPosition(3) + z_stepSize <= z_max + z_boundary_extansion % Allow extansion of z-boundaries
                    currentCameraTarget(3) = currentCameraTarget(3) + z_stepSize;
                    currentCameraPosition(3) = currentCameraPosition(3) + z_stepSize;

                    % Diagonal backward movement
                    % Check Camera Orientation
                    if abs(currentCameraPosition(1) - currentCameraTarget(1)) > 3 * x_stepSize % allow certain diviation

                        % Check right diagonal movement
                        if currentCameraPosition(1) > currentCameraTarget(1)
                            % Check right boundary
                            if currentCameraPosition(1) + x_stepSize <= x_max
                                currentCameraTarget(1) = currentCameraTarget(1) + x_stepSize;
                                currentCameraPosition(1) = currentCameraPosition(1) + x_stepSize;
                            end
                        end

                        % Check left diagonal movement
                        if currentCameraPosition(1) < currentCameraTarget(1)
                            % Check left boundary
                            if currentCameraPosition(1) - x_stepSize >= x_min
                                currentCameraTarget(1) = currentCameraTarget(1) - x_stepSize;
                                currentCameraPosition(1) = currentCameraPosition(1) - x_stepSize;
                            end
                        end
                    end
                end

            case 'a' % Move left
                % Check left boundary
                if currentCameraPosition(1) - x_stepSize >= x_min
                    currentCameraTarget(1) = currentCameraTarget(1) - x_stepSize;
                    currentCameraPosition(1) = currentCameraPosition(1) - x_stepSize;

                    % Diagonal left movement
                    % Check Camera Orientation
                    if abs(currentCameraPosition(1) - currentCameraTarget(1)) > 3 * x_stepSize % allow certain diviation

                        % Check back left diagonal movement
                        if currentCameraPosition(1) > currentCameraTarget(1)
                            % Check back boundary
                            if currentCameraPosition(3) + z_stepSize <= z_max + z_boundary_extansion % Allow extansion of z-boundaries
                                currentCameraTarget(3) = currentCameraTarget(3) + z_stepSize;
                                currentCameraPosition(3) = currentCameraPosition(3) + z_stepSize;
                            end
                        end

                        % Check front left diagonal movement
                        if currentCameraPosition(1) < currentCameraTarget(1)
                            % Check front boundary
                            if currentCameraPosition(3) - z_stepSize >= z_min
                                currentCameraTarget(3) = currentCameraTarget(3) - z_stepSize;
                                currentCameraPosition(3) = currentCameraPosition(3) - z_stepSize;
                            end
                        end
                    end
                end


            case 'd' % Move right
                % Check right boundary
                if currentCameraPosition(1) + x_stepSize <= x_max
                    currentCameraTarget(1) = currentCameraTarget(1) + x_stepSize;
                    currentCameraPosition(1) = currentCameraPosition(1) + x_stepSize;

                    % Diagonal right movement
                    % Check Camera Orientation
                    if abs(currentCameraPosition(1) - currentCameraTarget(1)) > 3 * x_stepSize % allow certain diviation

                        % Check front right diagonal movement
                        if currentCameraPosition(1) > currentCameraTarget(1)
                            % Check front boundary
                            if currentCameraPosition(3) - z_stepSize >= z_min
                                currentCameraTarget(3) = currentCameraTarget(3) - z_stepSize;
                                currentCameraPosition(3) = currentCameraPosition(3) - z_stepSize;
                            end
                        end


                        % Check back right diagonal movement
                        if currentCameraPosition(1) < currentCameraTarget(1)
                            % Check back boundary
                            if currentCameraPosition(3) + z_stepSize <= z_max + z_boundary_extansion % Allow extansion of z-boundaries
                                currentCameraTarget(3) = currentCameraTarget(3) + z_stepSize;
                                currentCameraPosition(3) = currentCameraPosition(3) + z_stepSize;
                            end
                        end
                    end
                end


            case 'q' % Move up
                if currentCameraPosition(2) - y_stepSize >= y_min
                    currentCameraTarget(2) = currentCameraTarget(2) - y_stepSize;
                    currentCameraPosition(2) = currentCameraPosition(2) - y_stepSize;
                end
            case 'e' % Move down
                if currentCameraPosition(2) + y_stepSize <= y_max
                    currentCameraTarget(2) = currentCameraTarget(2) + y_stepSize;
                    currentCameraPosition(2) = currentCameraPosition(2) + y_stepSize;
                end

            % Rotation
            case 'uparrow' % Turn up
                currentCameraTarget(2) = currentCameraTarget(2) - angle_step_size;

            case 'downarrow' % Turn down
                currentCameraTarget(2) = currentCameraTarget(2) + angle_step_size;

            case 'leftarrow' % Turn left
                currentCameraTarget(1) = currentCameraTarget(1) - angle_step_size;

            case 'rightarrow' % Turn right
                currentCameraTarget(1) = currentCameraTarget(1) + angle_step_size;

            otherwise
                return; % Do nothing for other keys
        end

        % Update camera position and target
        set(gca, 'CameraPosition', currentCameraPosition);
        camtarget(gca, currentCameraTarget);

        % Force MATLAB to redraw the plot
        drawnow;
    end
end
