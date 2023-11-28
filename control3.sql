--control 1

insert into cotizante values(2,'192055180','tapia', 'cortes','luis tapia','23-01-1996','M', 1003, 150000000,0,'I','SR',5101);

set serveroutput on

declare 
rut cotizante.rutCT%type;
existe number(1,0);
nro cotizante.numeroCT%type;
ahorro cotizante.ahorroObligCT%type;
cod inversion.codigoIN%type;
fondo inversion.tipoFondoIN%type;
ejecutor inversion.ejecutorIN%type;

error_rut exception;
existe_inversion_activa exception;
error_tipo_fondo exception;
error_ejecutor exception;
begin
rut:='&rut_cot';


select count(rutCT) into existe from cotizante where rutCT=rut;

if(existe=0) then
    raise error_rut;
else
    select numeroCT,ahorroObligCT into nro, ahorro from cotizante where rutCT=rut;
    
    select count(codigoIN) into existe from inversion where numeroCT=nro and estadoIN=1;
    if(existe<>0) then
        raise existe_inversion_activa;
    else
        select nvl(max(codigoIN),0)+1 into cod from inversion;
        
        fondo:='&tipo_fondo';
        if(fondo not in ('A','B','C','D','E')) then
            raise error_tipo_fondo;
        else
            ejecutor:='&ejecutor';
            if(ejecutor not in ('AF','EJ','RA'))then
                raise error_ejecutor;
            else
                insert into inversion values(cod,1,nro,to_date(sysdate),fondo,100,ahorro,ejecutor,1);
            end if;   
        end if;
    end if;   
end if;

exception
when error_rut then dbms_output.put_line ('rut no encontrado');
when existe_inversion_activa then dbms_output.put_line (' ya hay inversion activa');
when error_tipo_fondo then dbms_output.put_line('tipo de fondo ingresado incorrecto');
when error_ejecutor then dbms_output.put_line('error ejecutor ingresado incorrecto');
end;
