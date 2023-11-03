--guia 4
--agregar tabla comuna

--para una comuna en particular mostrar rut, apellidos y edad de los clientes adultos mayores

select rutCL, apellido1CL, apellido2CL, (extract (year from sysdate)- extract (year from fechaNacimCL)) as edad
from CLIENTE cl join COMUNA cm on cl.codigoCM=cm.codigoCM
where nombreCM='&nombre_comuna' and (extract (year from sysdate)- extract (year from fechaNacimCL)) >= 20 and generoCL='M';

--mostrar para cada comuna la cantidad de clientes


--mostrar para cada comuna lo/las clientes
select comuna.codigoCM, nombreCM, rutCL, tipoCL, apellido1CL
from comuna left join cliente on comuna.codigoCM=cliente.codigoCM;

--mostrar para cada comuna la cantidad de clientes

select comuna.codigoCM, nombreCM,count(rutCL) 
from comuna left join cliente on comuna.codigoCM=cliente.codigoCM
group by comuna.codigoCM, nombreCM;

--funciones de agregacion:
--count()
--sum()
--max()
--min()
--avg()


--mostrar por cada cliente la cantidad de tarjetas

select cliente.rutCL, nombreCL||' '||apellido1CL||' '||apellido2CL as nombre_completo, tipoCL, count(numeroTJ) as cantTJ
from cliente left join tarjeta on cliente.rutCL=tarjeta.rutCL
group by cliente.rutCL, nombreCL||' '||apellido1CL||' '||apellido2CL , tipoCL;


--mostrar para cada tipo de cliente , la cantidad de tarjeta cerrada

select tipoCL,count(estadoTJ)
from cliente cl left join tarjeta tj on cl.rutCL=tj.rutCL
where estadoTJ='C'
group by tipoCL;



--mostrar para cada genero de cliente , la cantidad de tarjeta abierta

select generoCL,count(estadoTJ)
from cliente cl left join tarjeta tj on cl.rutCL=tj.rutCL
where estadoTJ='C'
group by generoCL;


--guia 5


--1.5  mostrar, para cada cliente, el cupo promedio asignado.
--los datos de interes del cliente son rut, primer apellido, genero, tipo 

select cl.rutCL, apellido1CL, generoCL,tipoCL, avg(cupoTJ) as prom_asig
from cliente cl left join tarjeta tj on cl.rutCL=tj.rutCL
group by cl.rutCL, apellido1CL, generoCL,tipoCL;



--mostrar para cada cliente el monto total adeudado , los datos de interes son rut, fecha nacimiento, genero y el monto solicitado

select cl.rutCL, fechaNacimCL, generoCL, sum(cupoTJ-cupoDIspTJ) as monto_deuda
from cliente cl left join tarjeta tj on cl.rutCL=tj.rutCL
group by cl.rutCL, fechaNacimCL, generoCL;


--mostrar para cada cliente el mayor cupo otorgado

select cl.rutCL, apellido1CL,apellido2CL, nombreCL, fechaNacimCL,generoCL, codigoCM,tipoCL, max(cupotj) as max_cupo
from cliente cl  join tarjeta tj on cl.rutCL=tj.rutCL
group by cl.rutCL, apellido1CL,apellido2CL, nombreCL, fechaNacimCL,generoCL, codigoCM,tipoCL;

--mostrar la cantidad de cliente por genero
select generoCL, count(generoCL)
from cliente
group by generoCL;


--mostrar la cantidad de tarjeta por estado

select estadoTJ, count(estadoTJ) as cantTJ
from tarjeta
group by estadoTJ;

-- mostrar el numero,rut, fecha de otorgamiento y estado de la tarjeta mas antigua

--incorrecto debido al solicitar mostrar datos de la misma tabla de agrupamiento, se anula el agrupamiento
select numeroTJ,rutCL, fechaApertTJ, estadoTJ, min(fechaApertTJ)
from tarjeta
group by numeroTJ,rutCL, fechaApertTJ, estadoTJ

--select aninado
select numeroTJ,rutCL, fechaApertTJ, estadoTJ
from tarjeta
where fechaApertTJ = (select min(fechaApertTJ) from tarjeta);


select numeroTJ,rutCL, fechaApertTJ, estadoTJ
from tarjeta
where numeroTJ = (select min(numeroTJ) from tarjeta);



--mostrar :el numero, rut, fecha de otorgamiento y eatdo de la tarjeta mas reciente

select numeroTJ,rutCL, fechaApertTJ, estadoTJ
from tarjeta
where numeroTJ = (select max(numeroTJ) from tarjeta);