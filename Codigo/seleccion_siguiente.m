% selección de siguiente estado según probabilidad de transición
% Utiliza un modelo de transición T(s,s,s')=P(s'|s,a) para simular el comportamiento y generar
% las muestras
% 'sigu' es una variable de selección
function [utilidad, accion, siguiente] = seleccion_siguiente(epsilon, nact, numEstado, Q, T)

 
n = rand;
if n > epsilon
   % Exploración
   accion =  mod (round(rand()*10) ,nact) + 1;
   utilidad = Q(numEstado, accion);
else
   % Explotación
   [utilidad, accion] = max(Q(numEstado, :));
end

siguiente = find((cumsum(T(numEstado,accion,:)) - rand )>=0, 1) ;
