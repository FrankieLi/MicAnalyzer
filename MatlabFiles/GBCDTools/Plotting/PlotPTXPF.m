%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Pole figure plotting of .ptx format files using MTEX
%       Date: 12/1/09 - Author: J. Lind
%
%  Usage: pf = PlotPTXPF( fName, CrystalSymmetry, SampleSymmetry, plot_options )
%
%  Example1: PlotPTXPF('32grainRotationAxes.ptx','mmm','-1', ...
%                          {'3d','gray'} )
%
%  Example2: PlotPTXPF('500grainRotationAxes.ptx','cubic','triclinic', ...
%                          {'earea', 'scatter', 'logarithmic', 'gray'} );
%
%  Returns the pole figure object that was loaded in
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%% Supported Symmetries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
%  crystal system  Schoen-  Inter-    Laue     Rotational 
%  flies    national  class    axis
%  triclinic       C1       1         -1       1    
%  triclinic       Ci       -1        -1       1    
%  monoclinic      C2       2         2/m      2    
%  monoclinic      Cs       m         2/m      2    
%  monoclinic      C2h      2/m       2/m      2    
%  orthorhombic    D2       222       mmm      222  
%  orthorhombic    C2v      mm2       mmm      222  
%  orthorhombic    D2h      mmm       mmm      222  
%  tetragonal      C4       4         4/m      4    
%  tetragonal      S4       -4        4/m      4    
%  tetragonal      C4h      4/m       4/m      4    
%  tetragonal      D4       422       4/mmm    422  
%  tetragonal      C4v      4mm       4/mmm    422  
%  tetragonal      D2d      -42m      4/mmm    422  
%  tetragonal      D4h      4/mmm     4/mmm    422  
%  trigonal        C3       3         -3       3    
%  trigonal        C3i      -3        -3       3    
%  trigonal        D3       32        -3m      32   
%  trigonal        C3v      3m        -3m      32   
%  trigonal        D3d      -3m       -3m      32   
%  hexagonal       C6       6         6/m      6    
%  hexagonal       C3h      -6        6/m      6    
%  hexagonal       C6h      6/m       6/m      6    
%  hexagonal       D6       622       6/mmm    622  
%  hexagonal       C6v      6mm       6/mmm    622  
%  hexagonal       D3h      -6m2      6/mmm    622  
%  hexagonal       D6h      6/mmm     6/mmm    622  
%  cubic           T        23        m-3      23   
%  cubic           Th       m-3       m-3      23   
%  cubic           O        432       m-3m     432  
%  cubic           Td       -43m      m-3m     432  
%  cubic           Oh       m-3m      m-3m     432
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%% Supported Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Color range:
%   tight
%   equal
%   [min max ]
%
% Spherical projections:
%   earea
%   edist
%   eangle
%   plain
%   3d
%
% Filling:
%   scatter
%   smooth
%   contour
%   contourf
%
% Additional options:
%   antipodal
%   complete
%   logarithmic
%   resolution
%   FontSize
%   grid
%   gray
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pf] = PlotPTXPF( fName, CS, SS, options )

    pf = loadPoleFigure(fName,CS,SS);
    opt = '';
    if( length( options ) > 1 )
        for i=1:(length( options ) - 1)
            opt = [opt, '''', options{i}, ''', '];
        end
        opt = [opt, '''', options{ length( options ) }, ''''];
    else
        opt = ['''', options{1}, ''''];
    end
    fprintf(1, ['\n Calling : plot( pf, ', opt, ' ); \n \n'] );
    eval( ['plot( pf, ', opt, ' );'] );
    
end
