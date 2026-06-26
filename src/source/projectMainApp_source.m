% NOTE: This file is a plain-text extraction of the MATLAB code embedded
% inside projectMainApp.mlapp (App Designer apps store their source code in a
% zipped XML container that GitHub cannot render natively). This .m file
% is provided purely for readability/review on GitHub; it is NOT meant to
% be run directly, since classdef apps built with App Designer also rely
% on the GUI layout/component definitions stored in the .mlapp file.
% To actually run the app, open and run projectMainApp.mlapp in MATLAB.

classdef projectMainApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        SetappmodeMenu               matlab.ui.container.Menu
        version1Menu                 matlab.ui.container.Menu
        version2Menu                 matlab.ui.container.Menu
        SetproblemparametersMenu     matlab.ui.container.Menu
        SetboundaryconditionsMenu    matlab.ui.container.Menu
        SetdomainMenu                matlab.ui.container.Menu
        Panel                        matlab.ui.container.Panel
        PlotButton                   matlab.ui.control.Button
        MEditField                   matlab.ui.control.NumericEditField
        MEditFieldLabel              matlab.ui.control.Label
        NEditField                   matlab.ui.control.NumericEditField
        NEditFieldLabel              matlab.ui.control.Label
        fEditField                   matlab.ui.control.EditField
        fEditFieldLabel              matlab.ui.control.Label
        UIAxes2                      matlab.ui.control.UIAxes
        ButtonGroup                  matlab.ui.container.ButtonGroup
        plotButton                   matlab.ui.control.Button
        NumericalsolutionButton      matlab.ui.control.RadioButton
        MatrixconditionnumberButton  matlab.ui.control.RadioButton
        ConvergenceplotButton        matlab.ui.control.RadioButton
        TabGroup                     matlab.ui.container.TabGroup
        PlotTab                      matlab.ui.container.Tab
        UIAxes                       matlab.ui.control.UIAxes
        DataTab                      matlab.ui.container.Tab
        UITable                      matlab.ui.control.Table
        Panel2                       matlab.ui.container.Panel
        uEditField                   matlab.ui.control.EditField
        uEditFieldLabel              matlab.ui.control.Label
    end

    
    properties (Access = private)
        DialogApp % Description
        DialogApp2
        DialogApp3
        B_x=[0,0];
        B_y=[0,0];
        q=[0,0];
        robin=[0,0];
        r=[0,0];
        BC;
        u=str2sym('@(x,y) sin(2*pi*x)*sin(2*pi*y)');
        f=['@(x,y) y*exp(2*x) - 7*x*exp(2*x) - ' ...
            '4*exp(2*x) - 3*exp(2*x)*(x^2 + y^2) + pi*exp(2*x)*(x^2 + y^2)'];
        gL='@(x,y) - 2*x*exp(2*x) - (exp(2*x)*(x^2 + y^2))/2  ';
        gR='@(x,y) 2*x*exp(2*x) + (7*exp(2*x)*(x^2 + y^2))/2';
        gB='@(x,y) (3*exp(2*x)*(x^2 + y^2))/2 - 2*y*exp(2*x)';
        gT='@(x,y) 2*y*exp(2*x) + (3*exp(2*x)*(x^2 + y^2))/2';
        gD='@(x,y) exp(2*x)*(x^2 + y^2)';
        a=[0,0];
        b=[1,1];
        c=[0,0];
        d=[1,1];
        data=[];       
    end
    
    properties (Access = public)
        
        version1=1;

    end


    %%%% inserire accellarator
    %%%% controlla il time
    %%%% sistemare legende
      methods (Access = public)
    
        function updateparameters(app,Bx, By,Q,~)
            % Store inputs as properties
            if app.version1
             app.B_x = [Bx,app.B_x(2)];
             app.B_y = [By,app.B_y(2)];
             app.q=[Q,app.q(2)];
            else
              app.B_x = [app.B_x(2),Bx];
              app.B_y = [app.B_y(2),By];
              app.q=[app.q(2),Q];
            end
            % Update plot 
            %if app.ConvergenceplotCheckBox.Value
                % if plot
                %     FD(app,app.u,0,1,0,1,B,1,app.BC,1,1);
                % else
                %     FD(app,app.u,0,1,0,1,B,1,app.BC,1,0);
                % end
            
            
            
            % Re-enable the Plot Options button
            app.SetproblemparametersMenu.Enable = "on";

        end
        function updateBC(app,robin,r,L,R,B,T)
            app.robin(1)=robin;
            app.BC(1).L=L;
            app.BC(1).R=R;
            app.BC(1).B=B;
            app.BC(1).T=T;
            app.r(1)=r;
            app.SetboundaryconditionsMenu.Enable='on';
        end
        function updateBC2(app,robin,r,L,R,B,T,gL,gR,gB,gT,gD)
            app.robin(2)=robin;
            app.BC(2).L=L;
            app.BC(2).R=R;
            app.BC(2).B=B;
            app.BC(2).T=T;
            app.r(2)=r;
            app.gL=gL;
            app.gR=gR;
            app.gB=gB;
            app.gT=gT;
            app.gD=gD;
            app.SetboundaryconditionsMenu.Enable='on';



        end
        function updateABCD(app,A,B,C,D)
            if app.version1
             app.a(1)=A;
             app.b(1)=B;
             app.c(1)=C;
             app.d(1)=D;
            else
              app.a(2)=A;
              app.b(2)=B;
              app.c(2)=C;
              app.d(2)=D;
            end
             app.SetdomainMenu.Enable='on';

        end

      end
    
    methods (Access = private)
        
        function FD_conv(app,u,a,b,c,d,B,gamma,corner,r,plot)
            Data=[];
            for k=2:5
                N=2^k; M=N+1;
                hx=(b-a)/(N+1);
                hy = (d-c)/(M+1);
                [A,F,U,u_true,time,Dx,Dy]=ellipt2D_FD_project(app,u,gamma,r,corner,a,b,c,d,N,M,0,B);
                Er_srf=abs(u_true-U);
                E_norm=max(max(Er_srf));
                A_cond=condest(A);
                Data=[Data;N,M,hx,hy,E_norm,A_cond];
            end
            if plot
                loglog(app.UIAxes,Data(:,3),Data(:,5),'-.b',Data(:,3),Data(:,3).^2,'--r');
                grid on; legend(app.UIAxes,'Error','h^2');xlabel('h')
            end
        end

        function [A,F,U,u_true,Xi,Yj]=ellipt2D_FD_project(app,u,q,r,Bc,a,b,c,d,N,M,count,B)
            
            syms x y

            ux=diff(u,x,1);
            uy=diff(u,y,1);
            f=-(diff(u,x,2)+diff(u,y,2))+q*u+B'*[ux; uy];
            % compute u_x u_y
            f=matlabFunction(f,"Vars",{x,y});
            g_L=-ux;
            g_B=-uy;
            g_R=ux;
            g_T=uy;
            g_L=g_L+r*u;
            g_B=g_B+r*u;
            g_R=g_R+r*u;
            g_T=g_T+r*u;

            u=matlabFunction(u,"Vars",{x,y});
            g_L=matlabFunction(g_L,"Vars",{x,y});
            g_B=matlabFunction(g_B,"Vars",{x,y});
            g_T=matlabFunction(g_T,"Vars",{x,y});
            g_R=matlabFunction(g_R,"Vars",{x,y});

            % %Neumann or Robin BC structure
            corner.LB=0;  corner.LT=0;  corner.RB=0; corner.RT=0;
            if Bc.L && Bc.B
                corner.LB=1;
            end
            if Bc.R && Bc.T
                corner.RT=1;
            end

            if Bc.R && Bc.B
                corner.RB=1;
            end

            if Bc.L && Bc.T
                corner.LT=1;
            end




            hx=(b-a)/(N+1);
            hy = (d-c)/(M+1);
            xi=a:hx:b;
            yj=c:hy:d;
            for j=1:numel(yj)
                for i=1:numel(xi)
                    Xi(i,j)=xi(i);
                    Yj(i,j)=yj(j);
                    Indx(i,j)=i;
                    Indy(i,j)=j;
                end
            end
            u_true=u(Xi,Yj);

            %In c_nodes we set as 1 the indexes where we wat to apply Dirichlet Boundary conditions.
            c_nodes=zeros(N+2,M+2);
            c_nodes(1:N+2,1)=1;% Bottom edge
            c_nodes(1:N+2,M+2)=1;% Top edge
            c_nodes(1,1:M+2)=1;% left
            c_nodes(N+2,1:M+2)=1;% right edge
            % no corner

            gBvec=zeros(N+2,M+2);  gTvec=zeros(N+2,M+2); gLvec=zeros(N+2,M+2); gRvec=zeros(N+2,M+2);

            val_LB=0; val_LT=0;  val_RB=0;  val_RT=0;
            if Bc.L
                L_nodes=zeros(N+2,M+2);
                L_nodes(1,2:M+1)=1;         % left
                gLvec=g_L(Xi,Yj).*L_nodes;
                c_nodes(1,2:M+1)=0;         % left
            end

            if Bc.R
                R_nodes=zeros(N+2,M+2);
                R_nodes(N+2,2:M+1)=1;         % left
                gRvec=g_R(Xi,Yj).*R_nodes;
                c_nodes(N+2,2:M+1)=0;         % left
            end

            if Bc.B
                B_nodes=zeros(N+2,M+2);
                B_nodes(2:N+1,1)=1;          % bottom
                gBvec=g_B(Xi,Yj).*B_nodes;
                c_nodes(2:N+1,1)=0;
            end

            if Bc.T
                T_nodes=zeros(N+2,M+2);
                T_nodes(2:N+1,M+2)=1;          % bottom
                gTvec=g_T(Xi,Yj).*T_nodes;
                c_nodes(2:N+1,M+2)=0;
            end
            % the same for the other BC
            %--------------------------------------
            if  corner.LB
                c_nodes(1,1)=0;
                val_LB=(2/hx)*g_L(Xi(1,1),Yj(1,1))+(2/hy)*g_B(Xi(1,1),Yj(1,1))+B(1)*g_L(xi(1,1),Yj(1,1))...
                    +B(2)*g_B(Xi(1,1),Yj(1,1));
            end

            if  corner.LT
                c_nodes(1,M+2)=0;
                val_LT=(2/hx)*g_L(Xi(1,M+2),Yj(1,M+2))+(2/hy)*g_T(Xi(1,M+2),Yj(1,M+2))+...
                    B(1)*g_L(Xi(1,M+2),Yj(1,M+2))-B(2)*g_T(Xi(1,M+2),Yj(1,M+2));
            end

            if  corner.RT
                c_nodes(N+2,M+2)=0;
                val_RT=(2/hx)*g_R(Xi(N+2,M+2),Yj(N+2,M+2))+(2/hy)*g_T(Xi(N+2,M+2),Yj(N+2,M+2))-...
                    B(1)*g_R(Xi(N+2,M+2),Yj(N+2,M+2))-B(2)*g_T(Xi(N+2,M+2),Yj(N+2,M+2));
            end

            if corner.RB
                c_nodes(N+2,1)=0;
                val_RB=(2/hx)*g_R(Xi(N+2,1),Yj(N+2,1))+(2/hy)*g_B(Xi(N+2,1),Yj(N+2,1))-...
                    B(1)*g_R(Xi(N+2,1),Yj(N+2,1))+B(2)*g_B(Xi(N+2,1),Yj(N+2,1));
            end

            Rg=u_true.*c_nodes;
            U=Rg; % for error computation
            F=f(Xi,Yj)+(2/hx)*(gLvec+gRvec)+(2/hy)*(gBvec+gTvec)+B(1)*(gLvec-gRvec)+B(2)*(-gTvec+gBvec);

            F(1,1)=F(1,1)+val_LB;       %left bottom corner
            F(1,M+2)=F(1,M+2)+val_LT;
            F(N+2,1)=F(N+2,1)+val_RB;
            F(N+2,M+2)=F(N+2,M+2)+val_RT;
            F=reshape(F,(N+2)*(M+2),1);
            Rg=reshape(Rg,(N+2)*(M+2),1);

            [A,Dx,Dy]=Lapl2D_Project(app,N+2,M+2,hx,hy,Bc,q,r,B);
            Z=F-A*Rg;
            f_nodes=1-c_nodes;
            Ix_f=Indx.*f_nodes;Ix_f(Ix_f==0)=NaN;
            Iy_f=Indy.*f_nodes;Iy_f(Iy_f==0)=NaN;
            fnode=@(ix,jy)((N+2)*(jy-1)+ix);
            free_indx=fnode(Ix_f(:),Iy_f(:));
            free_indx=free_indx(~isnan(free_indx));
                
            v=A(free_indx,free_indx)\Z(free_indx);
            

            % position of free nodes
            Ix_f=Ix_f(~isnan(Ix_f));
            Iy_f=Iy_f(~isnan(Iy_f));
            for m=1:numel(v)
                U(Ix_f(m),Iy_f(m))=v(m);
            end

        end
        function [A,F,U,Xi,Yj]=ellipt2D_FD_project2(app,f,q,r,Bc,a,b,c,d,N,M,B,gL,gR,gB,gT,gD)
            syms x y
            gL=str2sym(gL);
            gR=str2sym(gR);
            gB=str2sym(gB);
            gT=str2sym(gT);
            f=str2sym(f);
            gD=str2sym(gD);
            f=matlabFunction(f,"Vars",{x,y});
            gL=matlabFunction(gL,"Vars",{x,y})
            gR=matlabFunction(gR,"Vars",{x,y})
            gB=matlabFunction(gB,"Vars",{x,y})
            gT=matlabFunction(gT,"Vars",{x,y})
            gD=matlabFunction(gD,"Vars",{x,y})
            % g_L=-ux;
            % g_B=-uy;
            % g_R=ux;
            % g_T=uy;
            % g_L=g_L+r*u;
            % g_B=g_B+r*u;
            % g_R=g_R+r*u;
            % g_T=g_T+r*u;

            % %Neumann or Robin BC structure
            corner.LB=0;  corner.LT=0;  corner.RB=0; corner.RT=0;
            if Bc.L && Bc.B
                corner.LB=1;
            end
            if Bc.R && Bc.T
                corner.RT=1;
            end

            if Bc.R && Bc.B
                corner.RB=1;
            end

            if Bc.L && Bc.T
                corner.LT=1;
            end




            hx=(b-a)/(N+1);
            hy = (d-c)/(M+1);
            xi=a:hx:b;
            yj=c:hy:d;
            for j=1:numel(yj)
                for i=1:numel(xi)
                    Xi(i,j)=xi(i);
                    Yj(i,j)=yj(j);
                    Indx(i,j)=i;
                    Indy(i,j)=j;
                end
            end
            gD_vec=gD(Xi,Yj);

            %In c_nodes we set as 1 the indexes where we wat to apply Dirichlet Boundary conditions.
            c_nodes=zeros(N+2,M+2);
            c_nodes(1:N+2,1)=1;% Bottom edge
            c_nodes(1:N+2,M+2)=1;% Top edge
            c_nodes(1,1:M+2)=1;% left
            c_nodes(N+2,1:M+2)=1;% right edge
            % no corner

            gBvec=zeros(N+2,M+2);  gTvec=zeros(N+2,M+2); gLvec=zeros(N+2,M+2); gRvec=zeros(N+2,M+2);

            val_LB=0; val_LT=0;  val_RB=0;  val_RT=0;
            if Bc.L
                L_nodes=zeros(N+2,M+2);
                L_nodes(1,2:M+1)=1;         % left
                gLvec=gL(Xi,Yj).*L_nodes;
                c_nodes(1,2:M+1)=0;         % left
            end

            if Bc.R
                R_nodes=zeros(N+2,M+2);
                R_nodes(N+2,2:M+1)=1;         % left
                gRvec=gR(Xi,Yj).*R_nodes;
                c_nodes(N+2,2:M+1)=0;         % left
            end

            if Bc.B
                B_nodes=zeros(N+2,M+2);
                B_nodes(2:N+1,1)=1;          % bottom
                gBvec=gB(Xi,Yj).*B_nodes;
                c_nodes(2:N+1,1)=0;
            end

            if Bc.T
                T_nodes=zeros(N+2,M+2);
                T_nodes(2:N+1,M+2)=1;          % bottom
                gTvec=gT(Xi,Yj).*T_nodes;
                c_nodes(2:N+1,M+2)=0;
            end
            % the same for the other BC
            %--------------------------------------
            if  corner.LB
                c_nodes(1,1)=0;
                val_LB=(2/hx)*gL(Xi(1,1),Yj(1,1))+(2/hy)*gB(Xi(1,1),Yj(1,1))+B(1)*gL(xi(1,1),Yj(1,1))...
                    +B(2)*gB(Xi(1,1),Yj(1,1));
            end

            if  corner.LT
                c_nodes(1,M+2)=0;
                val_LT=(2/hx)*gL(Xi(1,M+2),Yj(1,M+2))+(2/hy)*gT(Xi(1,M+2),Yj(1,M+2))+...
                    B(1)*gL(Xi(1,M+2),Yj(1,M+2))-B(2)*gT(Xi(1,M+2),Yj(1,M+2));
            end

            if  corner.RT
                c_nodes(N+2,M+2)=0;
                val_RT=(2/hx)*gR(Xi(N+2,M+2),Yj(N+2,M+2))+(2/hy)*gT(Xi(N+2,M+2),Yj(N+2,M+2))-...
                    B(1)*gR(Xi(N+2,M+2),Yj(N+2,M+2))-B(2)*gT(Xi(N+2,M+2),Yj(N+2,M+2));
            end

            if corner.RB
                c_nodes(N+2,1)=0;
                val_RB=(2/hx)*gR(Xi(N+2,1),Yj(N+2,1))+(2/hy)*gB(Xi(N+2,1),Yj(N+2,1))-...
                    B(1)*gR(Xi(N+2,1),Yj(N+2,1))+B(2)*gB(Xi(N+2,1),Yj(N+2,1));
            end

            Rg=gD_vec.*c_nodes;
            U=Rg; % for error computation
            F=f(Xi,Yj)+(2/hx)*(gLvec+gRvec)+(2/hy)*(gBvec+gTvec)+B(1)*(gLvec-gRvec)+B(2)*(-gTvec+gBvec);

            F(1,1)=F(1,1)+val_LB;       %left bottom corner
            F(1,M+2)=F(1,M+2)+val_LT;
            F(N+2,1)=F(N+2,1)+val_RB;
            F(N+2,M+2)=F(N+2,M+2)+val_RT;
            F=reshape(F,(N+2)*(M+2),1);
            Rg=reshape(Rg,(N+2)*(M+2),1);

            [A,Dx,Dy]=Lapl2D_Project(app,N+2,M+2,hx,hy,Bc,q,r,B);
            Z=F-A*Rg;
            f_nodes=1-c_nodes;
            Ix_f=Indx.*f_nodes;Ix_f(Ix_f==0)=NaN;
            Iy_f=Indy.*f_nodes;Iy_f(Iy_f==0)=NaN;
            fnode=@(ix,jy)((N+2)*(jy-1)+ix);
            free_indx=fnode(Ix_f(:),Iy_f(:));
            free_indx=free_indx(~isnan(free_indx));
                
            v=A(free_indx,free_indx)\Z(free_indx);
            

            % position of free nodes
            Ix_f=Ix_f(~isnan(Ix_f));
            Iy_f=Iy_f(~isnan(Iy_f));
            for m=1:numel(v)
                U(Ix_f(m),Iy_f(m))=v(m);
            end

        end



        function [A,Dx,Dy]=Lapl2D_Project(app,N,M,hx,hy,Bc,gamma,r,B)
            Ix=speye(N);
            Iy=speye(M);
            e=ones(M,1);
            Dyy=sparse(1:M,1:M,(-2)*e,M,M)+...
                sparse(1:M-1,2:M,e(1:M-1),M,M)+...
                sparse(2:M,1:M-1,e(1:M-1),M,M);
            Dy=sparse(1:M-1,2:M,e(1:M-1),M,M)+...
                sparse(2:M,1:M-1,-e(1:M-1),M,M);
            e=ones(N,1);
            Dxx=sparse(1:N,1:N,(-2)*e,N,N)+...
                sparse(1:N-1,2:N,e(1:N-1),N,N)+...
                sparse(2:N,1:N-1,e(1:N-1),N,N);
            Dx=sparse(1:N-1,2:N,e(1:N-1),N,N)+...
                sparse(2:N,1:N-1,-e(1:N-1),N,N);



            if Bc.L
                Dxx(1,2)=2;
                Dxx(1,1)=Dxx(1,1)-2*hx*r;
                Dx(1,1)=Dx(1,1)+2*hx*r;
                Dx(1,2)=0;
            end
            if Bc.B
                Dyy(1,2)=2;
                Dyy(1,1)=Dyy(1,1)-2*hy*r;
                Dy(1,1)=Dy(1,1)+2*hy*r;
                Dy(1,2)=0;
            end
            if Bc.R
                Dxx(N,N-1)=2;
                Dxx(N,N)=Dxx(N,N)-2*hx*r;
                Dx(N,N)=Dx(N,N)-2*hx*r;
                Dx(N,N-1)=0;
            end
            if Bc.T
                Dyy(M,M-1)=2;
                Dyy(M,M)=Dyy(M,M)-2*hy*r;
                Dy(M,M)=Dy(M,M)-2*hy*r;
                Dy(M,M-1)=0;
            end
            K2=kron(Dyy,Ix)/(hy^2);
            K1=kron(Iy,Dxx)/(hx^2);
            K3=B(2)/(2*hy) *kron(Dy,Ix);
            K4=B(1)/(2*hx) *kron(Iy,Dx);
            A=-(K1+K2)+gamma*speye(N*M)+K3+K4;
        end
        
        function FD(app,u,a,b,c,d,B,gamma,Bc,r,plot)
            app.data=[];

            if plot
                if app.ConvergenceplotButton.Value
                    app.UITable.Visible='on';

                    for k=2:5
                        N=2^k; M=N+1;
                        hx=(b-a)/(N+1);
                        hy = (d-c)/(M+1);
                        [A,F,U,u_true,Xi,Yj]=ellipt2D_FD_project(app,u,gamma,r,Bc,a,b,c,d,N,M,0,B);
                        Er_srf=abs(u_true-U);
                        E_norm=max(max(Er_srf));
                        A_cond=condest(A);
                        app.data=[app.data;N,M,hx,hy,E_norm,A_cond];
                    end
                    cla(app.UIAxes,'reset');
                    loglog(app.UIAxes,app.data(:,3),app.data(:,5),'-.b', ...
                        app.data(:,3),app.data(:,3).^2,'--r');
                    legend(app.UIAxes,'Error','h^2');xlabel(app.UIAxes,'h');
                    grid(app.UIAxes,'on');
                    title(app.UIAxes,'$h^2$ vs Error','Interpreter','latex')
                else
                    if app.MatrixconditionnumberButton.Value
                        app.UITable.Visible='on';

                        for k=2:5
                            N=2^k; M=N+1;
                            hx=(b-a)/(N+1);
                            hy = (d-c)/(M+1);
                            [A,F,U,u_true,Xi,Yj]=ellipt2D_FD_project(app,u,gamma,r,Bc,a,b,c,d,N,M,0,B);
                            Er_srf=abs(u_true-U);
                            E_norm=max(max(Er_srf));
                            A_cond=condest(A);
                            app.data=[app.data;N,M,hx,hy,E_norm,A_cond];
                        end
                        cla(app.UIAxes,'reset');
                        loglog(app.UIAxes,app.data(:,3),app.data(:,6),'-.b',app.data(:,3), ...
                            app.data(:,3).^(-2),'--r');
                        grid(app.UIAxes,'on');

                        legend(app.UIAxes,'condition numer','$h^{-2}$','interpreter','latex');
                        xlabel(app.UIAxes,'h'); title(app.UIAxes,'matrix condition numer');

                    else
                        if app.NumericalsolutionButton.Value
                            app.UITable.Visible='off';
                            N=2^4; M=N+1;
                            hx=(b-a)/(N+1);
                            hy = (d-c)/(M+1);
                            [A,F,U,u_true,Xi,Yj]=ellipt2D_FD_project(app,u,gamma,r, ...
                                Bc,a,b,c,d,N,M,0,B);
                            cla(app.UIAxes,'reset');
                            surf(app.UIAxes,Xi,Yj,U);%view(app.UIAxes,2);
                            title(app.UIAxes,'numerical solution');
                            xlabel(app.UIAxes,'X');
                            ylabel(app.UIAxes,'Y');
                        end
                    end
                end
            end

        end
        
        function FD2(app,f,a,b,c,d,B,gamma,Bc,r,gL,gR,gB,gT,gD)
            
               
                       
                            app.UITable.Visible='off';
                            N=app.NEditField.Value; M=app.MEditField.Value;
                            hx=(b-a)/(N+1);
                            hy = (d-c)/(M+1);
                            [A,F,U,Xi,Yj]=ellipt2D_FD_project2(app,f,gamma,r, ...
                                Bc,a,b,c,d,N,M,B,gL,gR,gB,gT,gD);
                            cla(app.UIAxes2,'reset');
                            title(app.UIAxes2,'numerical solution');
                            xlabel(app.UIAxes2,'X');
                            ylabel(app.UIAxes2,'Y');
                            surf(app.UIAxes2,Xi,Yj,U);
           

 end
                
            

        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
                   updateparameters(app, app.B_x, app.B_y,app.q,0)
                   updateBC(app,0,0,0,0,0,0);
                   updateBC2(app,0,app.r(2),0,0,0,0,app.gL,app.gR,app.gB,app.gT,app.gD)
                   updateABCD(app,0,1,0,1);
                   app.Panel.Visible='off';
        end

        % Menu selected function: SetproblemparametersMenu
        function SetproblemparametersMenuSelected(app, event)
            if app.version1
             BX=app.B_x(1);
             BY=app.B_y(1);
             Q=app.q(1);
            else 
             BX=app.B_x(2);
             BY=app.B_y(2);
             Q=app.q(2); 
            end
            % Open the options dialog and pass inputs
            app.DialogApp = dialogApp(app,BX,BY,Q);
            app.SetproblemparametersMenu.Enable = "off";
        end

        % Menu selected function: SetboundaryconditionsMenu
        function SetboundaryconditionsMenuSelected(app, event)
            if app.version1
             R=app.r(1);
             Robin=app.robin(1);
             Bc=app.BC(1);

            else
                R=app.r(2);
                Robin=app.robin(2);
                Bc=app.BC(2);

            end
            GL=app.gL;
            GR=app.gR;
            GB=app.gB;
            GT=app.gT;
            GD=app.gD;
            app.DialogApp2=dialogApp2(app,Robin,R,Bc.L,Bc.R,Bc.B,Bc.T,GL, ...
                GR,GT,GB,GD);
            app.SetboundaryconditionsMenu.Enable = "off";

        end

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
             syms x y;
             U=app.u;
             
             B=[app.B_x(1);app.B_y(1)];
            
             FD(app,U,app.a(1),app.b(1),app.c(1),app.d(1),B,app.q(1),app.BC(1),app.r(1),1);
              
             app.UITable.Data=app.data;
        end

        % Value changed function: uEditField
        function uEditFieldValueChanged(app, event)
            value = app.uEditField.Value;
            app.u=str2sym(value);
        end

        % Menu selected function: SetdomainMenu
        function SetdomainMenuSelected(app, event)
            if app.version1
             A=app.a(1);
             B=app.b(1);
             C=app.c(1);
             D=app.d(1);
             app.DialogApp3=dialogApp3(app,A,B,C,D);
             app.SetdomainMenu.Enable='off';
            else
              A=app.a(2);
              B=app.b(2);
              C=app.c(2);
              D=app.d(2);
             app.DialogApp3=dialogApp3(app,A,B,C,D);
             app.SetdomainMenu.Enable='off';  
            end
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
        end

        % Menu selected function: version1Menu
        function version1MenuSelected(app, event)
            app.SetappmodeMenu.Visible='on';
            app.SetproblemparametersMenu.Visible='on';
            app.SetboundaryconditionsMenu.Visible='on';
            app.SetdomainMenu.Visible='on';
            app.ButtonGroup.Visible='on';
            app.TabGroup.Visible='on';
            app.Panel2.Visible='on';
            app.Panel.Visible='off';
            app.version1=1;
        end

        % Menu selected function: version2Menu
        function version2MenuSelected(app, event)
            app.SetappmodeMenu.Visible='on';
            app.SetproblemparametersMenu.Visible='on';
            app.SetboundaryconditionsMenu.Visible='on';
            app.SetdomainMenu.Visible='on';
            app.ButtonGroup.Visible='off';
            app.TabGroup.Visible='off';
            app.Panel2.Visible='off';
            app.Panel.Visible='on';
            app.version1=0;
           
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
                 B=[app.B_x(2);app.B_y(2)];
                 FD2(app,app.f,app.a(2),app.b(2),app.c(2),app.d(2),B,app.q(2),app.BC(2),app.r(2), ...
                     app.gL,app.gR,app.gB,app.gT,app.gD)
             
        end

        % Value changed function: fEditField
        function fEditFieldValueChanged(app, event)
            value = app.fEditField.Value;
            app.f=value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 727 466];
            app.UIFigure.Name = 'MATLAB App';

            % Create SetappmodeMenu
            app.SetappmodeMenu = uimenu(app.UIFigure);
            app.SetappmodeMenu.Text = 'Set app mode';

            % Create version1Menu
            app.version1Menu = uimenu(app.SetappmodeMenu);
            app.version1Menu.MenuSelectedFcn = createCallbackFcn(app, @version1MenuSelected, true);
            app.version1Menu.Text = 'version1 ';

            % Create version2Menu
            app.version2Menu = uimenu(app.SetappmodeMenu);
            app.version2Menu.MenuSelectedFcn = createCallbackFcn(app, @version2MenuSelected, true);
            app.version2Menu.Text = 'version 2';

            % Create SetproblemparametersMenu
            app.SetproblemparametersMenu = uimenu(app.UIFigure);
            app.SetproblemparametersMenu.MenuSelectedFcn = createCallbackFcn(app, @SetproblemparametersMenuSelected, true);
            app.SetproblemparametersMenu.Text = 'Set problem parameters';

            % Create SetboundaryconditionsMenu
            app.SetboundaryconditionsMenu = uimenu(app.UIFigure);
            app.SetboundaryconditionsMenu.MenuSelectedFcn = createCallbackFcn(app, @SetboundaryconditionsMenuSelected, true);
            app.SetboundaryconditionsMenu.Text = 'Set boundary conditions';

            % Create SetdomainMenu
            app.SetdomainMenu = uimenu(app.UIFigure);
            app.SetdomainMenu.MenuSelectedFcn = createCallbackFcn(app, @SetdomainMenuSelected, true);
            app.SetdomainMenu.Text = 'Set domain';

            % Create Panel2
            app.Panel2 = uipanel(app.UIFigure);
            app.Panel2.AutoResizeChildren = 'off';
            app.Panel2.Title = 'exact solution';
            app.Panel2.Position = [1 284 269 97];

            % Create uEditFieldLabel
            app.uEditFieldLabel = uilabel(app.Panel2);
            app.uEditFieldLabel.HorizontalAlignment = 'center';
            app.uEditFieldLabel.Position = [59 23 25 22];
            app.uEditFieldLabel.Text = 'u';

            % Create uEditField
            app.uEditField = uieditfield(app.Panel2, 'text');
            app.uEditField.ValueChangedFcn = createCallbackFcn(app, @uEditFieldValueChanged, true);
            app.uEditField.Position = [99 23 100 22];
            app.uEditField.Value = '@(x,y) sin(2*pi*x)*sin(2*pi*y)';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [290 34 408 387];

            % Create PlotTab
            app.PlotTab = uitab(app.TabGroup);
            app.PlotTab.Title = 'Plot';

            % Create UIAxes
            app.UIAxes = uiaxes(app.PlotTab);
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [8 38 389 309];

            % Create DataTab
            app.DataTab = uitab(app.TabGroup);
            app.DataTab.Title = 'Data';

            % Create UITable
            app.UITable = uitable(app.DataTab);
            app.UITable.ColumnName = {'N'; 'M'; 'hx'; 'hy'; 'infty-error'; 'condest'};
            app.UITable.ColumnWidth = {55, 55, 55, 55, 80, 80};
            app.UITable.RowName = {};
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [18 163 372 133];

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.Position = [30 72 211 142];

            % Create ConvergenceplotButton
            app.ConvergenceplotButton = uiradiobutton(app.ButtonGroup);
            app.ConvergenceplotButton.Text = 'Convergence plot';
            app.ConvergenceplotButton.Position = [11 96 115 22];
            app.ConvergenceplotButton.Value = true;

            % Create MatrixconditionnumberButton
            app.MatrixconditionnumberButton = uiradiobutton(app.ButtonGroup);
            app.MatrixconditionnumberButton.Text = 'Matrix condition number';
            app.MatrixconditionnumberButton.Position = [11 74 149 22];

            % Create NumericalsolutionButton
            app.NumericalsolutionButton = uiradiobutton(app.ButtonGroup);
            app.NumericalsolutionButton.Text = 'Numerical solution';
            app.NumericalsolutionButton.Position = [11 52 120 22];

            % Create plotButton
            app.plotButton = uibutton(app.ButtonGroup, 'push');
            app.plotButton.ButtonPushedFcn = createCallbackFcn(app, @plotButtonPushed, true);
            app.plotButton.Position = [56 14 100 22];
            app.plotButton.Text = 'plot';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Position = [2 -31 727 495];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.Panel);
            title(app.UIAxes2, 'Numerical solution')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [318 64 368 383];

            % Create fEditFieldLabel
            app.fEditFieldLabel = uilabel(app.Panel);
            app.fEditFieldLabel.HorizontalAlignment = 'right';
            app.fEditFieldLabel.Position = [70 321 25 22];
            app.fEditFieldLabel.Text = 'f';

            % Create fEditField
            app.fEditField = uieditfield(app.Panel, 'text');
            app.fEditField.ValueChangedFcn = createCallbackFcn(app, @fEditFieldValueChanged, true);
            app.fEditField.Position = [110 321 100 22];
            app.fEditField.Value = '@(x,y) y*exp(2*x) - 7*x*exp(2*x) - 4*exp(2*x) - 3*exp(2*x)*(x^2 + y^2) + pi*exp(2*x)*(x^2 + y^2)';

            % Create NEditFieldLabel
            app.NEditFieldLabel = uilabel(app.Panel);
            app.NEditFieldLabel.HorizontalAlignment = 'right';
            app.NEditFieldLabel.Interpreter = 'latex';
            app.NEditFieldLabel.Position = [73 266 25 22];
            app.NEditFieldLabel.Text = 'N';

            % Create NEditField
            app.NEditField = uieditfield(app.Panel, 'numeric');
            app.NEditField.Position = [113 266 100 22];

            % Create MEditFieldLabel
            app.MEditFieldLabel = uilabel(app.Panel);
            app.MEditFieldLabel.HorizontalAlignment = 'right';
            app.MEditFieldLabel.Interpreter = 'latex';
            app.MEditFieldLabel.Position = [77 214 25 22];
            app.MEditFieldLabel.Text = 'M';

            % Create MEditField
            app.MEditField = uieditfield(app.Panel, 'numeric');
            app.MEditField.Position = [117 214 100 22];

            % Create PlotButton
            app.PlotButton = uibutton(app.Panel, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [99 101 100 22];
            app.PlotButton.Text = 'Plot';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = projectMainApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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