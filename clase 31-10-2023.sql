--clase 31-oct-2023

--mostrar para los clientes treabajadores, las tarjetas activas.
--los datos de interes son:nombre completo , fecha de nacimiento, cupo autorizado y saldo adeudado


--"incorrecta" en el from, efectua producto cartesiano
select nombreCL, apellido1CL, apellido2CL, fechaNacimCL, (cupoTJ - cupoDispTJ) as saldo_adeudado
from cliente, tarjeta
where generoCL='M' and tipoCL in ('TD','TI');


--"correcta" pero ineficiente:uso del where
select nombreCL, apellido1CL, apellido2CL, fechaNacimCL, (cupoTJ - cupoDispTJ) as saldo_adeudado
from cliente, tarjeta
where generoCL='M' and tipoCL in ('TD','TI') and CLIENTE.rutCL=TARJETA.rutCL;


--correcto uso de join
select nombreCL, apellido1CL, apellido2CL, fechaNacimCL, (cupoTJ - cupoDispTJ) as saldo_adeudado
from cliente  join tarjeta  on cliente.rutCL=tarjeta.rutCL
where generoCL='M' and tipoCL in ('TD','TI') ;



select nombreCL, apellido1CL, apellido2CL, fechaNacimCL, (cupoTJ - cupoDispTJ) as saldo_adeudado
from cliente cl  join tarjeta  tj on cl.rutCL=tj.rutCL
where generoCL='M' and tipoCL in ('TD','TI') ;



---mostrar  el rut y nombre completo de los clientes que tienen la cuenta cerrada o bloqueada

select cliente.rutCL, apellido1CL, apellido2CL
from cliente join tarjeta on cliente.rutCL=tarjeta.rutCL
where estadoTJ ='C' or estadoTJ='B' and generoCL='M';




--para las tarjetas activas sin cupo disponible, mostrar el numero cupo, autorisado, rut y tipo de cliente

select numeroTJ,cupoDIspTJ,cl.rutCL,tipoCL
from cliente cl join tarjeta tj on cl.rutCL=tj.rutCL
where estadotj='A' and cupoDispTJ=0;




--mostrar para los clientes en un genero en particular : rut,tipo,numero de tarjeta, cupo disponible y estado

select cl.rutCl,tipoCL, numeroTJ, cupoDispTJ,estadoTJ
from cliente cl join tarjeta tj on cl.rutCL=tj.rutCL
where generoCl='&genero';
 