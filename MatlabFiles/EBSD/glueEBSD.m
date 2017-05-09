function outEBSD = glueEBSD(sect1, sect2, sect3, sect4, sect5)

offx(1) = -390.
offy(1) = 15.
offx(2) = offx(1) + 160.
offy(2) = offy(1) + 40.
offx(3) = offx(2) + 230.
offy(3) = offy(2) +42.

offx(4) = offx(3) + 0.
offy(4) = offy(3) -270.

offx(5) = offx(4) -110.
offy(5) = offy(4) -15.
%
% sect1(:, 5) = sect1(:, 5) + offx(1);
% sect1(:, 4) = sect1(:, 4) + offy(1);
%
% sect2(:, 5) = sect2(:, 5) + offx(2);
% sect2(:, 4) = sect2(:, 4) + offy(2);
%
% sect3(:, 5) = sect3(:, 5) + offx(3);
% sect3(:, 4) = sect3(:, 4) + offy(3);
%
% sect4(:, 5) = sect4(:, 5) + offx(4);
% sect4(:, 4) = sect4(:, 4) + offy(4);
%
% sect5(:, 5) = sect5(:, 5) + offx(5);
% sect5(:, 4) = sect5(:, 4) + offy(5);
%
%

sect1(:, 4) = sect1(:, 4) + offx(1);
sect1(:, 5) = sect1(:, 5) + offy(1);

sect2(:, 4) = sect2(:, 4) + offx(2);
sect2(:, 5) = sect2(:, 5) + offy(2);

sect3(:, 4) = sect3(:, 4) + offx(3);
sect3(:, 5) = sect3(:, 5) + offy(3);

sect4(:, 4) = sect4(:, 4) + offx(4);
sect4(:, 5) = sect4(:, 5) + offy(4);

sect5(:, 4) = sect5(:, 4) + offx(5);
sect5(:, 5) = sect5(:, 5) + offy(5);


outEBSD = [sect1; sect2;sect3;sect5];

outEBSD(:, 4) = -outEBSD(:, 4);
outEBSD(:, 5) = 0.98 * outEBSD(:, 5);
outEBSD(:, 4:5) = outEBSD(:, 4:5)/1000;
