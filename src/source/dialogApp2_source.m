% NOTE: This file is a plain-text extraction of the MATLAB code embedded
% inside dialogApp2.mlapp (App Designer apps store their source code in a
% zipped XML container that GitHub cannot render natively). This .m file
% is provided purely for readability/review on GitHub; it is NOT meant to
% be run directly, since classdef apps built with App Designer also rely
% on the GUI layout/component definitions stored in the .mlapp file.
% To actually run the app, open and run dialogApp2.mlapp in MATLAB.

classdef dialogApp2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        SetboundaryconditionsMenu      matlab.ui.container.Menu
        gTEditField                    matlab.ui.control.EditField
        gTEditFieldLabel               matlab.ui.control.Label
        gBEditField                    matlab.ui.control.EditField
        gBEditFieldLabel               matlab.ui.control.Label
        gREditField                    matlab.ui.control.EditField
        gREditFieldLabel               matlab.ui.control.Label
        gDEditField                    matlab.ui.control.EditField
        gDEditFieldLabel               matlab.ui.control.Label
        gLEditField                    matlab.ui.control.EditField
        gLEditFieldLabel               matlab.ui.control.Label
        TopCheckBox                    matlab.ui.control.CheckBox
        BottomCheckBox                 matlab.ui.control.CheckBox
        RightCheckBox                  matlab.ui.control.CheckBox
        LeftCheckBox                   matlab.ui.control.CheckBox
        okayButton                     matlab.ui.control.Button
        RobinconditionsfracpartialupartialnurugontheLabel  matlab.ui.control.Label
        rEditField                     matlab.ui.control.NumericEditField
        rEditFieldLabel                matlab.ui.control.Label
        BoundaryconditionsButtonGroup  matlab.ui.container.ButtonGroup
        DirichletButton                matlab.ui.control.RadioButton
        MixedRobinButton               matlab.ui.control.RadioButton
    end

    
    properties (Access = private)
        MainApp % Description
    end
    
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp, Robin, r, L, R, B, T, gL, gR, gT, gB, gD)
            app.MainApp=mainapp;
            app.DirichletButton.Value=~Robin;
            app.MixedRobinButton.Value=Robin;
            if ~Robin
                app.rEditField.Visible='off';
                app.rEditFieldLabel.Visible='off';
                app.RobinconditionsfracpartialupartialnurugontheLabel.Visible='off';
                app.TopCheckBox.Visible='off';
                app.BottomCheckBox.Visible='off';
                app.RightCheckBox.Visible='off';
                app.LeftCheckBox.Visible='off';
                app.gTEditField.Visible='off';
                app.gBEditField.Visible='off';
                app.gLEditField.Visible='off';
                app.gREditField.Visible='off';
                app.gBEditFieldLabel.Visible='off';
                app.gREditFieldLabel.Visible='off';
                app.gTEditFieldLabel.Visible='off';
                app.gLEditFieldLabel.Visible='off';
                app.gDEditFieldLabel.Visible='off';
                app.gDEditField.Visible='off';
                 if ~app.MainApp.version1    
                     app.gDEditFieldLabel.Visible='on';
                     app.gDEditField.Visible='on';
                 end

            else
                app.gTEditField.Visible='off';
                app.gBEditField.Visible='off';
                app.gLEditField.Visible='off';
                app.gREditField.Visible='off';
                app.gBEditFieldLabel.Visible='off';
                app.gREditFieldLabel.Visible='off';
                app.gTEditFieldLabel.Visible='off';
                app.gLEditFieldLabel.Visible='off';
                app.gDEditFieldLabel.Visible='off';
                app.gDEditField.Visible='off';
                 if  ~app.MainApp.version1    
                     app.gTEditField.Visible='on';
                     app.gBEditField.Visible='on';
                     app.gLEditField.Visible='on';
                     app.gREditField.Visible='on';
                     app.gBEditFieldLabel.Visible='on';
                     app.gREditFieldLabel.Visible='on';
                     app.gTEditFieldLabel.Visible='on';
                     app.gLEditFieldLabel.Visible='on';
                     app.gDEditFieldLabel.Visible='on';
                     app.gDEditField.Visible='on';
                     app.gDEditFieldLabel.Visible='on';
                     app.gDEditField.Visible='on';
                 end

            end
            app.rEditField.Value=r;
            app.BottomCheckBox.Value=B;
            app.TopCheckBox.Value=T;
            app.LeftCheckBox.Value=L;
            app.RightCheckBox.Value=R;
            app.gLEditField.Value=gL;
            app.gREditField.Value=gR;
            app.gTEditField.Value=gT;
            app.gBEditField.Value=gB;
            app.gDEditField.Value=gD;
        end

        % Button pushed function: okayButton
        function okayButtonPushed(app, event)
             if app.MainApp.version1
                 updateBC(app.MainApp, app.MixedRobinButton.Value,app.rEditField.Value, ...
                 app.LeftCheckBox.Value ...
                 ,app.RightCheckBox.Value,app.BottomCheckBox.Value, ...
                 app.TopCheckBox.Value);
             else
            % Delete the dialog box
                updateBC2(app.MainApp, app.MixedRobinButton.Value,app.rEditField.Value, ...
                 app.LeftCheckBox.Value ...
                 ,app.RightCheckBox.Value,app.BottomCheckBox.Value, ...
                 app.TopCheckBox.Value,app.gLEditField.Value,app.gREditField.Value, ...
                 app.gBEditField.Value,app.gTEditField.Value,app.gDEditField.Value)
             end
            app.MainApp.SetboundaryconditionsMenu.Enable='on';
            delete(app)

        end

        % Selection changed function: BoundaryconditionsButtonGroup
        function BoundaryconditionsButtonGroupSelectionChanged(app, event)
            selectedButton = app.BoundaryconditionsButtonGroup.SelectedObject;
            if app.DirichletButton.Value
                app.rEditField.Visible='off';
                app.rEditFieldLabel.Visible='off';
                app.RobinconditionsfracpartialupartialnurugontheLabel.Visible='off';
                app.TopCheckBox.Visible='off';
                app.BottomCheckBox.Visible='off';
                app.RightCheckBox.Visible='off';
                app.LeftCheckBox.Visible='off';
                app.gTEditField.Visible='off';
                app.gBEditField.Visible='off';
                app.gLEditField.Visible='off';
                app.gREditField.Visible='off';
                app.gBEditFieldLabel.Visible='off';
                app.gREditFieldLabel.Visible='off';
                app.gTEditFieldLabel.Visible='off';
                app.gLEditFieldLabel.Visible='off';                 
                app.gDEditFieldLabel.Visible='off';
                app.gDEditField.Visible='off'; 
                app.RightCheckBox.Value=0;
                app.LeftCheckBox.Value=0;
                app.BottomCheckBox.Value=0;
                app.TopCheckBox.Value=0;
                if ~ app.MainApp.version1
                    app.gDEditFieldLabel.Visible='on';
                    app.gDEditField.Visible='on'; 
                end
            else
                app.rEditField.Visible='on';
                app.rEditFieldLabel.Visible='on';
                app.RobinconditionsfracpartialupartialnurugontheLabel.Visible='on';
                app.TopCheckBox.Visible='on';
                app.BottomCheckBox.Visible='on';
                app.RightCheckBox.Visible='on';
                app.LeftCheckBox.Visible='on';
                app.gTEditField.Visible='off';
                app.gBEditField.Visible='off';
                app.gLEditField.Visible='off';
                app.gREditField.Visible='off';
                app.gBEditFieldLabel.Visible='off';
                app.gREditFieldLabel.Visible='off';
                app.gTEditFieldLabel.Visible='off';
                app.gLEditFieldLabel.Visible='off';                 
                app.gDEditFieldLabel.Visible='off';
                app.gDEditField.Visible='off'; 
                if ~app.MainApp.version1
                      app.gTEditField.Visible='on';
                      app.gBEditField.Visible='on';
                      app.gLEditField.Visible='on';
                      app.gREditField.Visible='on';
                      app.gBEditFieldLabel.Visible='on';
                      app.gREditFieldLabel.Visible='on';
                      app.gTEditFieldLabel.Visible='on';
                      app.gLEditFieldLabel.Visible='on';                 
                      app.gDEditFieldLabel.Visible='on';
                      app.gDEditField.Visible='on'; 
                end 
                
            end
        
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.MainApp.SetboundaryconditionsMenu.Enable='on';
            delete(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 562 475];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create SetboundaryconditionsMenu
            app.SetboundaryconditionsMenu = uimenu(app.UIFigure);
            app.SetboundaryconditionsMenu.Text = 'Set boundary conditions';

            % Create BoundaryconditionsButtonGroup
            app.BoundaryconditionsButtonGroup = uibuttongroup(app.UIFigure);
            app.BoundaryconditionsButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @BoundaryconditionsButtonGroupSelectionChanged, true);
            app.BoundaryconditionsButtonGroup.Title = 'Boundary conditions';
            app.BoundaryconditionsButtonGroup.BackgroundColor = [1 1 1];
            app.BoundaryconditionsButtonGroup.FontWeight = 'bold';
            app.BoundaryconditionsButtonGroup.Position = [9 378 136 76];

            % Create MixedRobinButton
            app.MixedRobinButton = uiradiobutton(app.BoundaryconditionsButtonGroup);
            app.MixedRobinButton.Text = 'Mixed Robin';
            app.MixedRobinButton.Position = [11 1 88 22];

            % Create DirichletButton
            app.DirichletButton = uiradiobutton(app.BoundaryconditionsButtonGroup);
            app.DirichletButton.Text = 'Dirichlet';
            app.DirichletButton.Position = [11 27 65 22];
            app.DirichletButton.Value = true;

            % Create rEditFieldLabel
            app.rEditFieldLabel = uilabel(app.UIFigure);
            app.rEditFieldLabel.HorizontalAlignment = 'center';
            app.rEditFieldLabel.Position = [333 401 25 22];
            app.rEditFieldLabel.Text = 'r';

            % Create rEditField
            app.rEditField = uieditfield(app.UIFigure, 'numeric');
            app.rEditField.Position = [373 401 100 22];
            app.rEditField.Value = 1;

            % Create RobinconditionsfracpartialupartialnurugontheLabel
            app.RobinconditionsfracpartialupartialnurugontheLabel = uilabel(app.UIFigure);
            app.RobinconditionsfracpartialupartialnurugontheLabel.Interpreter = 'latex';
            app.RobinconditionsfracpartialupartialnurugontheLabel.Position = [144 258 236 85];
            app.RobinconditionsfracpartialupartialnurugontheLabel.Text = 'Robin conditions ( $\frac{\partial u}{\partial \nu} + r u =g $ ) on the:';

            % Create okayButton
            app.okayButton = uibutton(app.UIFigure, 'push');
            app.okayButton.ButtonPushedFcn = createCallbackFcn(app, @okayButtonPushed, true);
            app.okayButton.Position = [234 38 100 22];
            app.okayButton.Text = 'okay';

            % Create LeftCheckBox
            app.LeftCheckBox = uicheckbox(app.UIFigure);
            app.LeftCheckBox.Text = 'Left';
            app.LeftCheckBox.Position = [413 289 42 22];

            % Create RightCheckBox
            app.RightCheckBox = uicheckbox(app.UIFigure);
            app.RightCheckBox.Text = 'Right';
            app.RightCheckBox.Position = [414 257 49 22];

            % Create BottomCheckBox
            app.BottomCheckBox = uicheckbox(app.UIFigure);
            app.BottomCheckBox.Text = 'Bottom';
            app.BottomCheckBox.Position = [414 225 60 22];

            % Create TopCheckBox
            app.TopCheckBox = uicheckbox(app.UIFigure);
            app.TopCheckBox.Text = 'Top';
            app.TopCheckBox.Position = [414 193 41 22];

            % Create gLEditFieldLabel
            app.gLEditFieldLabel = uilabel(app.UIFigure);
            app.gLEditFieldLabel.HorizontalAlignment = 'right';
            app.gLEditFieldLabel.Interpreter = 'latex';
            app.gLEditFieldLabel.Position = [38 246 25 22];
            app.gLEditFieldLabel.Text = 'gL';

            % Create gLEditField
            app.gLEditField = uieditfield(app.UIFigure, 'text');
            app.gLEditField.Position = [78 246 100 22];
            app.gLEditField.Value = '@(x,y) - 2*x*exp(2*x) - (exp(2*x)*(x^2 + y^2))/2  ';

            % Create gDEditFieldLabel
            app.gDEditFieldLabel = uilabel(app.UIFigure);
            app.gDEditFieldLabel.HorizontalAlignment = 'right';
            app.gDEditFieldLabel.Interpreter = 'latex';
            app.gDEditFieldLabel.Position = [39 89 25 22];
            app.gDEditFieldLabel.Text = 'gD';

            % Create gDEditField
            app.gDEditField = uieditfield(app.UIFigure, 'text');
            app.gDEditField.Position = [79 89 100 22];
            app.gDEditField.Value = '@(x,y) exp(2*x)*(x^2 + y^2)';

            % Create gREditFieldLabel
            app.gREditFieldLabel = uilabel(app.UIFigure);
            app.gREditFieldLabel.HorizontalAlignment = 'right';
            app.gREditFieldLabel.Interpreter = 'latex';
            app.gREditFieldLabel.Position = [39 214 25 22];
            app.gREditFieldLabel.Text = 'gR';

            % Create gREditField
            app.gREditField = uieditfield(app.UIFigure, 'text');
            app.gREditField.Position = [79 214 100 22];
            app.gREditField.Value = '@(x,y) 2*x*exp(2*x) + (7*exp(2*x)*(x^2 + y^2))/2';

            % Create gBEditFieldLabel
            app.gBEditFieldLabel = uilabel(app.UIFigure);
            app.gBEditFieldLabel.HorizontalAlignment = 'right';
            app.gBEditFieldLabel.Interpreter = 'latex';
            app.gBEditFieldLabel.Position = [38 176 25 22];
            app.gBEditFieldLabel.Text = 'gB';

            % Create gBEditField
            app.gBEditField = uieditfield(app.UIFigure, 'text');
            app.gBEditField.Position = [78 176 100 22];
            app.gBEditField.Value = '@(x,y) (3*exp(2*x)*(x^2 + y^2))/2 - 2*y*exp(2*x)';

            % Create gTEditFieldLabel
            app.gTEditFieldLabel = uilabel(app.UIFigure);
            app.gTEditFieldLabel.HorizontalAlignment = 'right';
            app.gTEditFieldLabel.Interpreter = 'latex';
            app.gTEditFieldLabel.Position = [39 134 25 22];
            app.gTEditFieldLabel.Text = 'gT';

            % Create gTEditField
            app.gTEditField = uieditfield(app.UIFigure, 'text');
            app.gTEditField.Position = [79 134 100 22];
            app.gTEditField.Value = '@(x,y)2*y*exp(2*x) + (3*exp(2*x)*(x^2 + y^2))/2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dialogApp2(varargin)

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