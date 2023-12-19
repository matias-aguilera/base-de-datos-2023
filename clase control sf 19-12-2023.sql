--  CONTROL RECUPERATIVO (18.12)

--  NOMBRE ESTUDIANTE:

--  OBSERVACIONES:
--  Aplica de la mejor forma los recursos de los lenguajes SQL y PL/SQL

--  Crear la tabla ESTADO_CUENTA

CREATE TABLE ESTADO_CUENTA
(numeroEC       NUMBER(8,0)     NOT NULL,   -- Valor correlativo que inicia en 10000
 numeroTJ       NUMBER(12,0)    NOT NULL,   -- Número de tarjeta
 estadoTJ	CHAR(1)		NOT NULL,   -- Estado de la tarjeta al momento de emitir el estado de cuenta
 fechaEmisEC    DATE            NOT NULL,   -- Fecha de emisión del Estado de Cuenta. Corresponde a la fecha cuando se ejecuta el procedimiento
 montoFactEC    NUMBER(7,0)     NOT NULL,   -- Monto facturado. Corresponde al monto utilizado de la tarjeta
 pagoMinEC      NUMBER(6,0)     NOT NULL,   -- Monto mínimo establecido a pagar. Corresponde al 10% del monto facturado
 fechaVencEC    DATE            NOT NULL,   -- Fecha de vencimiento para efectuar el pago. Son 15 días después de la fecha de emisión
 fechaPagoEC    DATE            NULL,	    -- Fecha en que se cancela el estado de cuenta
 montoCancEC    NUMBER(7,0)     NULL,	    -- Monto cancelado. Puede ser distinto al monto facturado
 estadoEC       NUMBER(1,0)     NOT NULL    -- Dominio: {0 (emitida), 1 (cancelada), 2 (mora)}. Por defecto: emitida
);

alter table ESTADO_CUENTA
add constraint pk_ESTADO_CUENTA primary key(numeroEC);


alter table ESTADO_CUENTA
add constraint fk_tarjeta_ESTADO_CUENTA foreign key (numeroTJ)
references tarjeta(numeroTJ);
 
--  1. (20 puntos)  Implementa un procedimiento almacenado, denominado emitirEstadoCuenta que, para las tarjetas activas,
--		    emita (genere) el estado de cuenta respectivo en base a las indicaciones dadas.
--		    Incluir el bloque anónimo que llame al procedimiento.


create or replace procedure emitirEstadoCuenta
as

nroTJ tarjeta.numeroTJ%type;
deuda tarjeta.cupoDispTJ%type;
estTJ tarjeta.estadoTJ%type;
nroEC ESTADO_CUENTA.numeroEC%type;

cursor tarjetasACT is select numeroTJ,(cupoTJ-cupoDispTJ),estadoTJ
                      from tarjeta where estadoTJ='A';  


begin
open tarjetasACT;
fetch tarjetasACT into nroTJ,deuda,estTJ;
if(tarjetasACT%rowcount>0)then

    select nvl(max(numeroEC),0)+1 into nroEC from estado_cuenta;
        while(tarjetasACT%found)loop
        if(deuda<>0)then
       insert into ESTADO_CUENTA 
       values (nroEC,nroTJ,estTJ,to_date(sysdate),deuda,deuda*0.1,to_date(sysdate)+15, null,null,0);
       
        nroEC:=nroEC+1;
       end if;
        fetch tarjetasACT into nroTJ,deuda,estTJ;
    end loop;
  
end if;
close tarjetasACT;

end;

begin
emitirEstadoCuenta;
end;




--  2. (10 puntos)  Implementa un bloque anónimo que procese los estados de cuenta emitidos e informe lo siguiente:
--		    Cantidad de estados de cuenta emitidos
--		    Monto total facturado
--		    Porcentaje de tarjetas por estado



set serverout on 

declare 

cantEC ESTADO_CUENTA.numeroEC%type;
totFcat number(9,0);


begin 

select count (numeroEC) into cantEC from estado_cuenta where estadoEC=0;
    dbma_output.put_line('cantidad de estado de cuenta emitidos: '||cantEC);    

select nvl(sum (montofectEC),0) into totFact from estado_cuenta where estadoEC=0;
    dbma_output.put_line('monto total facturado '||totFact);
if (cantEC<>0)then
    dbma_output.put_line('potcentaje de tarjetas activas emitidas:100%');
    else
    dbma_output.put_line('potcentaje de tarjetas activas emitidas:0%');
end if;    

end;















