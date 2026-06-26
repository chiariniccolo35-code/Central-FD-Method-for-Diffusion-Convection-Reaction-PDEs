% NOTE: This file is a plain-text extraction of the MATLAB code embedded
% inside dialogApp.mlapp (App Designer apps store their source code in a
% zipped XML container that GitHub cannot render natively). This .m file
% is provided purely for readability/review on GitHub; it is NOT meant to
% be run directly, since classdef apps built with App Designer also rely
% on the GUI layout/component definitions stored in the .mlapp file.
% To actually run the app, open and run dialogApp.mlapp in MATLAB.

classdef dialogApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        ProblemparametersPanel  matlab.ui.container.Panel
        Button                  matlab.ui.control.Button
        qEditField              matlab.ui.control.NumericEditField
        qLabel                  matlab.ui.control.Label
        B_yEditField            matlab.ui.control.NumericEditField
        B_yLabel                matlab.ui.control.Label
        B_xEditField            matlab.ui.control.NumericEditField
        B_xLabel                matlab.ui.control.Label
    end


         properties (Access = private) 
             MainApp % Main app
         end

    
        

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp, Bx, By, q)
          
             app.B_xEditField.Value= Bx;
             app.B_yEditField.Value = By;
             app.qEditField.Value=q;

            % Store main app in property
            app.MainApp = mainapp;
        

        
   

        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            updateparameters(app.MainApp, app.B_xEditField.Value, ...
                app.B_yEditField.Value,app.qEditField.Value,1);
            
            % Delete the dialog box
            delete(app)
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
                        app.MainApp.SetproblemparametersMenu.Enable='on';

            delete(app)
           
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 291 202];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create ProblemparametersPanel
            app.ProblemparametersPanel = uipanel(app.UIFigure);
            app.ProblemparametersPanel.Title = 'Problem parameters';
            app.ProblemparametersPanel.Position = [1 12 292 191];

            % Create B_xLabel
            app.B_xLabel = uilabel(app.ProblemparametersPanel);
            app.B_xLabel.HorizontalAlignment = 'right';
            app.B_xLabel.Interpreter = 'latex';
            app.B_xLabel.Position = [49 117 25 22];
            app.B_xLabel.Text = '$B_x$';

            % Create B_xEditField
            app.B_xEditField = uieditfield(app.ProblemparametersPanel, 'numeric');
            app.B_xEditField.Position = [89 117 100 22];

            % Create B_yLabel
            app.B_yLabel = uilabel(app.ProblemparametersPanel);
            app.B_yLabel.HorizontalAlignment = 'right';
            app.B_yLabel.Interpreter = 'latex';
            app.B_yLabel.Position = [49 64 25 22];
            app.B_yLabel.Text = '$B_y$';

            % Create B_yEditField
            app.B_yEditField = uieditfield(app.ProblemparametersPanel, 'numeric');
            app.B_yEditField.Position = [89 64 100 22];

            % Create qLabel
            app.qLabel = uilabel(app.ProblemparametersPanel);
            app.qLabel.HorizontalAlignment = 'right';
            app.qLabel.Interpreter = 'latex';
            app.qLabel.Position = [49 17 25 22];
            app.qLabel.Text = '$q$';

            % Create qEditField
            app.qEditField = uieditfield(app.ProblemparametersPanel, 'numeric');
            app.qEditField.Position = [89 17 100 22];

            % Create Button
            app.Button = uibutton(app.ProblemparametersPanel, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [205 64 73 23];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dialogApp(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end