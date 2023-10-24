select sysdate + 2 from dual; --sumar dias

select * from AFP where comisionAFP > 1.4;

--obtener el promedio de edad de los clientes

select avg( extract(year from sysdate) - extract (year from fechaNacimCL)) as promedioEdad
from cliente
where generoCL='M';

--mostrar clientes nacidos entre el 01-01-1995 y el 31-12-1998

select * from cliente where fechaNacimCL between '01-01-1995' and '31-12-1998';

--mostrar el rut, fechade nacimiento y genero de los /las clientes que no figuran con genero masculino

select rutCL, fechaNacimCL, generoCL from cliente where generoCL <>'M';

select rutCL, fechaNacimCL, generoCL from cliente where generoCL not in ('M');

select rutCL, fechaNacimCL, generoCL from cliente where not generoCL 'M';


--mostrar los/las clientes que comienzan con 20

select * from cliente where rutCL like '20%';

--mostrar los/las clientes que contienen  con 22

select * from cliente where rutCL like '%22%';


--mostrar las tarjetas que no figuran con fecha de cierre

select * from tarjeta where fechaCierreTJ is null;

--mostrar tarjetas cuyo cupo disponible noes mayor al 50% del cupo asignado


select * from tarjeta where not cupoDispTJ > cupoTJ*0.5;


create table comuna(
codigoCM number (5,0) not null,
nombreCM varchar2 (30)  not null,
codigoRG number(2,0) not null
);

alter table comuna
add constraint PK_comuna primary key (codigoCM);

alter table cliente
add constraint FK_comuna_cliente foreign key (codigoCM)
references comuna (codigoCM);


---guia 3


--1 mostar las comunas que comiensen con las letras s

select * from comuna where nombreCM like 'Q%';


--mostrar las comunas que contienen la letra n

select * from comuna where nombreCM like '%N%';

--mostar los clientes cuyo tipo corresponda a trabajador dependiente

select * from cliente where tipoCL ='TD' and generoCL='M';

--mostrar los clientes de un tipo en particular
--uso de varibles de sustitucion

select * from cliente where tipoCL ='&tipo';

--mostrar los clientes que no son estudiantes ni pensionados

select * from cliente where tipoCL not in ('ES','PS');


--mostrar los clientes que pertenecen a una comuna determinada


select * from cliente where codigoCM = &codigo_comuna;


--mostrar las tarjetas que fueron abiertas en un cierto rango de fechas

select * from tarjeta where fechaApertTJ between '&fechaini' and '&fechafin';

--mostrar las tarjetas que se encuentran cerradas o bloqueadas

select * from tarjeta where estadoTJ = 'C' or estadoTJ = 'B';

--de las tarjetas activas mostrar el numero tj, fecha de apertura, monto utilizado

select numeroTJ, fechaApertTJ, cupoTJ-cupoDispTJ as monto_utilizado from tarjeta 
where estadoTJ='A';

--para las tarjetas visa sin cupo disponible mostrar el numero, cupo asignadoy estado

select numeroTJ,cupoTJ, estadoTJ from tarjeta where tipoTJ='VISA' and cupoDispTJ=0 ;

--para las tarjetas activas con un cupo superiro a millon  mostar numero tarjeta, antiguedad y cupo asignado

select numeroTJ, extract(year from sysdate) - extract (year from fechaApertTJ) as antiguedad, cupoTJ from tarjeta
where estadoTJ='C' and cupoTJ>1000000;


--para las tarjetas bloqueadas mostrar el nro tarjeta, fecha de cierre  y causa

no puede ser implementada,la causa de cierre no existe en la bd
ademas si la tarjeta se encuentra bloqueada no existe no existe fecha de cierre









