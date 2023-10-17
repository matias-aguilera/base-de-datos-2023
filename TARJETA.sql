create table CLIENTE (
rutCL char(9) not null,
apellidoCL varchar2(20) not null,
apellido2CL varchar2(20) not null,
nombreCL varchar2(20) not null,
fechaNacimCL date not null,
generoCL char(1) not null,
codigoCM number (5,0) not null,
tipoCL char(2)  not null
);


create table TARJETA (
numeroTJ number(8,0) not null,
rutCL char(9) not null,
fechaApertTJ date not null,
cupoTJ number(7,0) not null,
cupoDispTJ number(7,0) not null,
tipoTJ char(10) not null,
fechaCierraTJ date  null,
estadoTJ char (1) not null
);

--integridad de identidad 

alter table TARJETA 
add constraint PK_TARJETA primary key (numeroTJ);

alter table CLIENTE 
add constraint PK_CLIENTE primary key (rutCL);

alter table TARJETA
add constraint FK_CLIENTE_TARJETA foreign key (rutCL)
references CLIENTE(rutCL);




----integridad de dominio

alter table CLIENTE 
add constraint CK_generoCL check (generoCL in ('F','M','O'));


alter table CLIENTE 
add constraint CK_tipoCL check (tipoCL in ('TD','TI','DC','PS','MT','ES'));


