CREATE OR REPLACE PROCEDURE crearApuesta(codTJ in APUESTA.codigoTJ%type, 
                                        nroST in APUESTA.numeroST%type,
                                        codAG in APUESTA.codigoAG%type)
as

codAP apuesta.codigoAP%type;

begin 

select nvl(max(codigoAP),0)+1 into codAP from apuesta;

insert into apuesta values (codAP, to_date(sysdate),codTJ, nroST,null,null,null,null,codAG,0);

end;
-----------------------------------------------------------------------

set serveroutput on 

declare

codTJ sorteo.codigoTJ%type;
existe number(1,0);
nroST sorteo.numeroST%type;
codAG apuesta.codigoAG%type; 
fecST date;

error_tipo_juego exception;
error_sorteo exception;
error_agencia exception;
sorteo_efectuado exception;

begin 

codTJ:=&codigoTipoJuego;

select count(codigoTJ) into existe from sorteo where codigoTJ = codTJ;
if(existe=0)then
    raise error_tipo_juego;
end if;

nroST :=&numero_sorteo;

select count(numeroST) into existe from sorteo where numeroST = nroST and  codigoTJ = codTJ;
if(existe=0)then
    raise error_sorteo;
end if;

codAG:=&codigo_agencia;

select count(codigoAG) into existe from agencia where codigoAG = codAG;
if(existe=0)then
    raise error_agencia;
else    
    select fechaST into fecST from sorteo where   numeroST = nroST and  codigoTJ = codTJ;  
    if(fecST < to_date(sysdate))then
        raise sorteo_efectuado;
    end if;    
end if;

crearApuesta (codTJ, nroST, codAG);

exception

when error_tipo_juego then dbms_output.put_line('codigo de tipo de juego incorrecto');
when error_sorteo then dbms_output.put_line('numero sorteo incorrecto');
when error_agencia then dbms_output.put_line('codigo de agencia incorrecto');
when sorteo_efectuado then dbms_output.put_line('sorteo ralizado, no acepta apuestas');
end;








--implementar un procedimiento almacenado denominado consultaPremio que permita consultar el premio de una apuesta


create or replace procedure consultaPremio (codAP in apuesta.codigoAP%type,
                                            montoPre out apuesta.montoPremioAP%type)
as

begin

select montoPremioAP into montoPre from apuesta where codigoAP= codAP;

end;

-------------------------------------------------------------------->

set serveroutput on

declare

codAP apuesta.codigoAP%type;
existe number (1,0);
fecST date;
error_apuesta exception;
sorteo_no_efectuado exception;
montoPre apuesta.montoPremioAP%type;
begin

codAP:=&codigo_apuesta;

select count(codigoAP) into existe from apuesta where codigoAP=codAP;
if(existe=0)then
    raise error_apuesta;
else
    select fechaST into fecST 
    from apuesta join sorteo on apuesta.codigoTJ=sorteo.codigoTJ and apuesta.numeroST=sorteo.numeroST
    where codigoAP=codAP;
    
    if(fecST>=to_date(sysdate))then
        raise sorteo_no_efectuado;
    end if;    
end if;    
 
 consultaPremio(codAP,montoPre);
 dbms_output.put_line('el premio de la apuesta  '||codAP||'es: '||montoPre);
 
exception
when error_apuesta then dbms_output.put_line('codigo de apuesta incorrecto');
when sorteo_no_efectuado then dbms_output.put_line('sorteo no efectuado, no puede consultar premio de la apuesta');


end;























