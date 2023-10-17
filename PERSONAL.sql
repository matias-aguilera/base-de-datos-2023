create table PERSONA (
rutPR   char (9) not null,
fechaNacimPR  date not null,
generoPR   char(1) not null,
codigoCMResid  number(5,0) not null,
codigoNC number (3,0) not null
);


alter table PERSONA
add detencion char(1) null;  -- se tuvo que considerar null debido a que la tabla tenia valores

alter table PERSONA
modify detencion not null;

alter table PERSONA
drop column detencion;

drop table PERSONA;
