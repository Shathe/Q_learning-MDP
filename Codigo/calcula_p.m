function [p,U]=calcula_p(Q)
% Calcula la política óptima para todos los estados a partir de la
% matriz Q(s,a). O sea:
%   a_opt(si)=argmax_a[Q(si,a)]
%   p=[a_opt(s1);a_opt(s2), ..., a_opt(sn)]
%   U(si)=max_a[Q(si,a)]

%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%%%%%%%
[valor, columnas] = max(Q, [] , 2);
U=valor;
p=columnas;
end

