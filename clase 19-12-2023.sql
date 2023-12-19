--procesar las apuestas de los sorteos realizados


create or replace procedure procesarApuesta
as
codTJ sorteo.codigoTJ%type;
nroST sorteo.numeroST%type;
pozo sorteo.pozoST%type;
cantAP number(7,0);
comAG apuesta.comisionAG%type;


cursor sorteosR is select codigoTJ, numeroST,pozoST from sorteo where fechaST < to_date(sysdate) ;
begin

open sorteosR;
fetch sorteosR into codTJ,nroST,pozo;
if(sorteosR%rowcount > 0)then
    while(sorteosR%found)loop
    
        select count(codigoAP) into cantAP 
        --falta tratar comison
        from apuesta
        where  apuesta.codigoTJ = codTJ and apuesta.numeroST=nroST;
      
        comAG:=0;
        if((pozo/cantAP)>=100000)then
        comAG:=(pozo/cantAP)*0.02;
        end if;
    
        update apuesta set ganadorAP=1, montoPremioAP = pozo/cantAP , cobradoAP=0 , comisionAG=comAG
        where  apuesta.codigoTJ = codTJ and apuesta.numeroST=nroST;
    
        fetch sorteosR into codTJ,nroST,pozo;    
    end loop;
end if;
close sorteosR;
end;


begin
procesarApuesta;
end;

