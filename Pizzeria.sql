DROP DATABASE IF EXISTS PIZZERIA;
CREATE DATABASE pizzeria;

use pizzeria;

CREATE TABLE localidades (
    codigo char (3) NOT NULL ,
    nombre char(50) NOT NULL,
    codigopostal char(5),	
    PRIMARY KEY (codigo)
);

create table Clientes (
    codigo integer NOT NULL ,
    nif char(12) NOT NULL,
    nombre char(50) not null,
    apellido1 char(50) not null,
    apellido2 char(50) ,
    telefono char(12) not null,
    calle char(100) not null,
    numero char(4) not null,
    letra char(1),
    piso char (3),
    puerta char (2),
    observaciones varchar(200),
    localidad char(3) not null,
    PRIMARY KEY (codigo),
    FOREIGN KEY (localidad) references Localidades (codigo) 
        ON UPDATE CASCADE 
        ON DELETE NO ACTION
);

create table Personal (
    codigo integer NOT NULL ,
    nif char(12) NOT NULL,
    nombre char(50) not null,
    apellido1 char(50) not null,
    apellido2 char(50) ,
    telefono char(12),
    email char(50) CHECK (email LIKE '%@%'),
    calle char(100) not null,
    numero char(4) not null,
    piso char (3),
    puerta char (2),
    localidad char(3) not null,
    fechaAlta date NOT NULL DEFAULT (CURRENT_DATE()), -- GETDATE() is not a mysql function
    fechaBaja date,
    PRIMARY KEY (codigo),
    FOREIGN KEY (localidad) references Localidades (codigo) 
        ON DELETE NO ACTION 
        ON UPDATE CASCADE,
    CHECK (fechaAlta<=fechaBaja) -- no need for "OR fechaBaja=null" because the CHECK constraint isn't violated if the expression evaluates to UNKNOWN.
);
create table Estados (
    codigo char (3) not null,
    descripcion char (20) not null,
    PRIMARY KEY (codigo)
);
create table MediosPago(
    codigo char (3) not null,
    descripcion char(20) not null,
    PRIMARY KEY (codigo)
);
create table Bases (
    codigo char (3) not null,
    descripcion char (20) not null,
    importe numeric (4,2) DEFAULT 0,
    PRIMARY KEY (codigo)
);
create table Ingredientes (
    codigo char (3) not null,
    descripcion char (20) not null,
    importe numeric(5,2) default 0,
    PRIMARY KEY (codigo)
);
create table Pedidos (
    codigo integer not null,
    iva integer not null CHECK (iva BETWEEN 0 AND 100),
    FechaHoraPedido datetime not null,
    FechaHoraServicio datetime null,
    importe numeric(6,2) not null, 
    observaciones varchar (100) null,
    estado char(3) not null,
    cliente integer not null,
    personal integer not null,
    pago char(3) not null,
    PRIMARY KEY (codigo),	
    foreign key (estado) references Estados (codigo),	
    foreign key (cliente) references Clientes (codigo),
    foreign key (personal) references Personal (codigo),
    foreign key (pago) references MediosPago (codigo)
);
create table Pizzas (
    codigo integer not null,
    pedido integer not null,
    base char (3) not null,
    importeBase numeric(5,2) not null,
    primary key(codigo),
    foreign key (base) references Bases (codigo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    foreign key (pedido) references Pedidos (codigo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
create table IngredienteDePizza (
    pizza integer not null,
    ingrediente char (3) not null,
    importe numeric(5,2) not null,
    foreign key (ingrediente) references Ingredientes (codigo),
    foreign key (pizza) references Pizzas (codigo)
);

insert into localidades (codigo,nombre,codigopostal) values ('CAM', 'Camargo','39609');
insert into localidades (codigo,nombre,codigopostal) values ('AST', 'Astillero', '39610');
insert into localidades (codigo,nombre,codigopostal) values ('MAL', 'Maliao','39600');
insert into localidades (codigo,nombre,codigopostal) values ('HEL', 'Helguera (Reocin)', '39538');
insert into localidades (codigo,nombre,codigopostal) values ('REO', 'Reocin', '39538');
insert into localidades (codigo,nombre,codigopostal) values ('PSM', 'Puente San Miguel', '39530');

insert into Clientes values('1','07659222R','Jaime', 'Muoz','Herrera','678342001', 'Avenida Mayor', '17','j', '6','a','', 'REO');
insert into Clientes values('2','07612231F','Juan', 'Del Castillo','Gonzalez','611342521', 'Plaza Castro', '21','i', '7','a','', 'REO');
insert into Clientes values('3','03459231O','Ramiro', 'Polo','Garcia','942735201', 'Calle Sardinero', '231', 'h', '2','b','', 'PSM');
insert into Clientes values('4','07659221P','Gema', 'Delgado','Tirado','678342209', 'Calle Romanones', '111', 'g', '2','d','', 'PSM');
insert into Clientes values('5','07655231I','Tomas', 'Fernandez','Cortes','600342521', 'Calle Castilla', '31', 'f', '5','b','', 'HEL');
insert into Clientes values('6','12359231U','Jose', 'Gonzalez','Claro','678725021', 'Avenida Remos', '9','e', '4','a','', 'HEL');
insert into Clientes values('7','08959231H','Carla', 'Rivera','Vera','658142521', 'Calle Goya', '8','d', '9','e','', 'AST');
insert into Clientes values('8','07459231R','Davinia', 'Castilla','Aguirre','678312521','Calle Lierganes', '1','c', '2','d','', 'AST');
insert into Clientes values('9','07652131D','Aurora', 'Molina','Moraga','678343821', 'Avenida Mercader', '2','b', '1','a','', 'MAL');
insert into Clientes values('10','07659211A','Macario', 'Polaino','Romero','678342521', 'Calle Galdos', '5','a', '5','c','', 'MAL');

insert into Personal VALUES ('1', '0891234554T','Juan' ,'Garcia', 'Prez', '678342233','jgp@hotmail.com',
'Calle Canarias','71','1','D','AST', '2010/01/01',null);
insert into Personal VALUES ('2', '08912345545','Pedro' ,'Lopez', 'AlonsoPrez', '678342244','pla@hotmail.com',
'Calle Sotelo','1','10','E','HEL', '2010/02/01',null);
insert into Personal VALUES ('3', '089123455345','Manuel' ,'Garcia', 'Fernandez', '678342256','mgf@hotmail.com',
'Calle La unin','31','2','A','MAL', '2010/08/01',null);

insert into Bases values ('NOR','Normal',3);
insert into Bases values ('FIN','Fina',3.5);
insert into Bases values ('QUE','Borde con queso',4);

insert into Ingredientes values ('JAM','Jamon',1.5);
insert into Ingredientes values('CHA','Championes',1);
insert into Ingredientes values('PIC','Queso Picon',1);
insert into Ingredientes values('ANC','Anchoas',1);
insert into Ingredientes values('ACE','Aceitunas',1);
insert into Ingredientes values('CHO','Chorizo',1);
insert into Ingredientes values('CEB','Cebolla',1);

insert into Estados values ('PEN','Pendiente');
insert into Estados values ('ENT','Entregada');
insert into Estados values ('CAN','Cancelado');

insert into MediosPago values ('EFE ', 'Efectivo');
insert into MediosPago values ('VIS', 'Visa');
insert into MediosPago values ('MAS', 'Mastercard');
insert into MediosPago values ('AME', 'American Express');

INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('1', '1', '2018-10-01 09:10:00', '2018-10-18 01:00:00', '5.00', NULL, 'CAN', '8', '1', 'AME');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('2', '70', '2018-10-26 05:00:00', NULL, '600', NULL, 'PEN', '1', '2', 'MAS');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('3', '50', '2018-10-30 07:00:00', NULL, '3000', NULL, 'PEN', '5', '1', 'VIS');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('4', '60', '2018-10-28 05:00:00', '2018-10-28 03:00:00', '700', NULL, 'CAN', '1', '1', 'VIS');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('5', '80', '2018-09-25 02:00:00', NULL, '6000', NULL, 'ENT', '3', '1', 'MAS');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('6', '4', '2018-11-23 08:00:00', NULL, '1000', 'Pizza baÃ±ada en oro comestible', 'ENT', '1', '3', 'EFE');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('7', '6', '2018-10-31 09:00:00', NULL, '500', 'Clasica', 'PEN', '3', '2', 'EFE');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('8', '10', '2018-10-15 00:00:00', NULL, '540', NULL, 'ENT', '10', '3', 'EFE');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('9', '40', '2018-10-17 00:00:00', NULL, '200', NULL, 'ENT', '5', '3', 'EFE');
INSERT INTO pedidos (codigo, iva, FechaHoraPedido, FechaHoraServicio, importe, observaciones, estado, cliente, personal, pago) VALUES ('10', '50', '2018-10-24 07:00:00', NULL, '700', NULL, 'PEN', '5', '1', 'AME');

insert into Pizzas (codigo, pedido, base, importeBase) values (1,1, 'NOR', 3);
insert into Pizzas (codigo, pedido, base, importeBase) values (2,1, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (3,2, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (4,3, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (5,4, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (6,5, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (7,6, 'NOR', 3);
insert into Pizzas (codigo, pedido, base, importeBase) values (8,7, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (9,7, 'FIN', 3.5);
insert into Pizzas (codigo, pedido, base, importeBase) values (10,7, 'FIN', 3.5);

insert into IngredienteDePizza values (1,'JAM',3);
insert into IngredienteDePizza values (1,'CHA', 2.5);
insert into IngredienteDePizza values (1,'ANC', 3.5);
insert into IngredienteDePizza values (2,'PIC', 1);
insert into IngredienteDePizza values (2,'CHA', 2.5);
insert into IngredienteDePizza values (2,'ANC', 3.5);
insert into IngredienteDePizza values (3,'JAM', 3);
insert into IngredienteDePizza values (3,'CHA', 2.5);
insert into IngredienteDePizza values (3,'CHO', 1);
insert into IngredienteDePizza values (4,'JAM', 3);
insert into IngredienteDePizza values (4,'CHA', 2.5);
insert into IngredienteDePizza values (4,'CEB', 1.5);
insert into IngredienteDePizza values (5,'JAM', 3);
insert into IngredienteDePizza values (5,'CHA', 2.5);
insert into IngredienteDePizza values (5,'ACE', 2);
insert into IngredienteDePizza values (6,'JAM', 3);
insert into IngredienteDePizza values (6,'CHA', 2.5);
insert into IngredienteDePizza values (7,'JAM', 3);
insert into IngredienteDePizza values (7,'CHA', 2.5);
insert into IngredienteDePizza values (8,'CHA', 2.5);
insert into IngredienteDePizza values (8,'ANC', 3.5);
insert into IngredienteDePizza values (9,'CHO', 1);
insert into IngredienteDePizza values (9,'CEB', 1.5);
insert into IngredienteDePizza values (10,'JAM', 3);
insert into IngredienteDePizza values (10,'ACE', 2);