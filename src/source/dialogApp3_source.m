% NOTE: This file is a plain-text extraction of the MATLAB code embedded
% inside dialogApp3.mlapp (App Designer apps store their source code in a
% zipped XML container that GitHub cannot render natively). This .m file
% is provided purely for readability/review on GitHub; it is NOT meant to
% be run directly, since classdef apps built with App Designer also rely
% on the GUI layout/component definitions stored in the .mlapp file.
% To actually run the app, open and run dialogApp3.mlapp in MATLAB.

classdef dialogApp3 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        RectangulardomainboundarysPanel  matlab.ui.container.Panel
        okayButton       matlab.ui.control.Button
        dEditField       matlab.ui.control.NumericEditField
        dEditFieldLabel  matlab.ui.control.Label
        cEditField       matlab.ui.control.NumericEditField
        cEditFieldLabel  matlab.ui.control.Label
        bEditField       matlab.ui.control.NumericEditField
        bEditFieldLabel  matlab.ui.control.Label
        aEditField       matlab.ui.control.NumericEditField
        aEditFieldLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
       Mainapp;
        
    end
    
    


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp, a, b, c, d)
            app.Mainapp=mainapp;
            app.aEditField.Value=a;
            app.bEditField.Value=b;
            app.cEditField.Value=c;
            app.dEditField.Value=d;
        end

        % Button pushed function: okayButton
        function okayButtonPushed(app, event)
            updateABCD(app.Mainapp, app.aEditField.Value, ...
                app.bEditField.Value,app.cEditField.Value,app.dEditField.Value);
            app.Mainapp.SetdomainMenu.Enable='on';

            % Delete the dialog box
            delete(app)


        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.Mainapp.SetdomainMenu.Enable='on';

            delete(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 259 262];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create RectangulardomainboundarysPanel
            app.RectangulardomainboundarysPanel = uipanel(app.UIFigure);
            app.RectangulardomainboundarysPanel.Title = 'Rectangular domain boundarys';
            app.RectangulardomainboundarysPanel.Position = [1 21 260 242];

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.RectangulardomainboundarysPanel);
            app.aEditFieldLabel.HorizontalAlignment = 'center';
            app.aEditFieldLabel.Position = [60 167 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aEditField
            app.aEditField = uieditfield(app.RectangulardomainboundarysPanel, 'numeric');
            app.aEditField.Position = [100 167 100 22];

            % Create bEditFieldLabel
            app.bEditFieldLabel = uilabel(app.RectangulardomainboundarysPanel);
            app.bEditFieldLabel.HorizontalAlignment = 'center';
            app.bEditFieldLabel.Position = [60 129 25 22];
            app.bEditFieldLabel.Text = 'b';

            % Create bEditField
            app.bEditField = uieditfield(app.RectangulardomainboundarysPanel, 'numeric');
            app.bEditField.Position = [100 129 100 22];

            % Create cEditFieldLabel
            app.cEditFieldLabel = uilabel(app.RectangulardomainboundarysPanel);
            app.cEditFieldLabel.HorizontalAlignment = 'center';
            app.cEditFieldLabel.Position = [60 91 25 22];
            app.cEditFieldLabel.Text = 'c';

            % Create cEditField
            app.cEditField = uieditfield(app.RectangulardomainboundarysPanel, 'numeric');
            app.cEditField.Position = [100 91 100 22];

            % Create dEditFieldLabel
            app.dEditFieldLabel = uilabel(app.RectangulardomainboundarysPanel);
            app.dEditFieldLabel.HorizontalAlignment = 'center';
            app.dEditFieldLabel.Position = [60 53 25 22];
            app.dEditFieldLabel.Text = 'd';

            % Create dEditField
            app.dEditField = uieditfield(app.RectangulardomainboundarysPanel, 'numeric');
            app.dEditField.Position = [100 53 100 22];

            % Create okayButton
            app.okayButton = uibutton(app.RectangulardomainboundarysPanel, 'push');
            app.okayButton.ButtonPushedFcn = createCallbackFcn(app, @okayButtonPushed, true);
            app.okayButton.Position = [80 5 100 22];
            app.okayButton.Text = 'okay';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dialogApp3(varargin)

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