begin transaction;

DROP TABLE IF EXISTS 
	cliente, clienteInstitucional, clienteParticular, veiculo,
	gps, zonaVerde, registoNProcessado, invalido, processado,
	alarme
	cascade;
	
commit transaction;
--rollback;
-----------------------------------------------------------------------------------------------------------------------------
begin transaction;

create table if not exists cliente(
    nif integer primary key check ((length(nif::text) = 9) and nif > 0),
    nome varchar(150) not null,
    telefone varchar(10) check (left(telefone,1) = ('9') and length(telefone) = 9) not null,
    morada varchar(150) not null,
    cpNif integer
);

create table if not exists clienteParticular(
	nif integer primary key,
	cc integer unique check ((length(cc::text) = 8) and cc > 0) not null,
	foreign key (nif) references cliente (nif) 
);

alter table cliente
	add foreign key (cpNif) references clienteParticular (nif);

create table if not exists clienteInstitucional(
	nif integer primary key,
	nomeContato varchar(150) not null,
	foreign key (nif) references cliente (nif) 
);

create table if not exists veiculo(
	matricula varchar(10) primary key,
	nif integer not null,
	nomeCondutor  varchar(150) not null,
	telefone varchar(10) check (left(telefone,1) = ('9') and length(telefone) = 9),
	numAlarmes int default 0 check (numAlarmes >= 0),
	gps integer,
	foreign key (nif) references cliente (nif)
);

create table if not exists gps(
	id serial primary key,
	marcaTemporal timestamp check(marcaTemporal <= CURRENT_TIMESTAMP) not null,
	longitude float check(longitude between 0.0 and 180.0),
	latitude float check(latitude between 0.0 and 90.0),
	estado varchar(20) check (estado in ('Activo','PausaDeAlarmes', 'Inactivo')) not null,
	matricula varchar(10),
	foreign key (matricula) references veiculo (matricula)
);

alter table veiculo
	add foreign key (gps) references gps (id);

create table if not exists zonaVerde(
	longitude real check(longitude between 0.0 and 180.0),
	latitude real check(latitude between 0.0 and 90.0),
	primary key(latitude, longitude),
	raio real check (raio > 0.0) not null,
	matricula varchar(10),
	foreign key(matricula) references veiculo (matricula)
);

create table if not exists registoNProcessado(
	id serial primary key,
	longitude real check(longitude between 0.0 and 180.0),
	latitude real check(latitude between 0.0 and 90.0),
	dat date check (dat <= CURRENT_DATE),
	gps integer
);

create table if not exists invalido(
	id integer primary key,
	foreign key (id) references registoNProcessado(id) 
);

create table if not exists processado(
	id serial primary key,
	longitude real check(longitude between 0.0 and 180.0),
	latitude real check(latitude between 0.0 and 90.0),
	dat date check(dat <= CURRENT_DATE),
	gps integer not null,
	rnp integer,
	foreign key (gps) references gps(id),
	foreign key (rnp) references registoNProcessado(id) 
);

create table if not exists alarme(
	id integer primary key,
	dataHora timestamp check(dataHora <= CURRENT_TIMESTAMP ) not null,
	foreign key (id) references processado(id) 
);
commit;

--rollback;
------------------------------------------------------------------------------------
begin transaction;


-- 1
INSERT INTO public.cliente(
	nif, nome, telefone, morada)
	VALUES 
	(659486259, 'João Baião', 965843129, 'Rua D. João I N4'),
	(689425389, 'Guilhereme Santos', 984629857, 'Rua das Laranjeiras N17'),
	(123456789, 'Edgar Batista', 912346508, 'Rua Macieira Da Vovó N20'),
	(234567890, 'Matilde Correia', 933023578, 'Rua das Amoras Azuis N3'),
	(486455345, 'Joel de Almeida', 978967543, 'Rua dos Mirtilos Raros N6'),
	(123395354, 'Tito Felipe', 945543567, 'Rua Anona Fresca N1'),
	(765865645, 'Mónica Sebastião', 965843129, 'Rua D. João I N4'),
	(435344578, 'Gonçalo Pasmatti', 984629857, 'Rua das Laranjeiras N16'),
	(175495354, 'Sofia Brandão', 975867547, 'Rua Moranguinho Verde N7'),
	(764953465, 'Sandra Gomes', 922224543, 'Rua D. João I N4'),
	(854645646, 'Bruna Carvalho', 901343454, 'Rua das Laranjeiras N16'),
	(247554854, 'Beatriz Clemente', 914768921, 'Rua Anona Fresca N1'),
	(383454584, 'Amanda de Sousa', 925843129, 'Rua D. João I N4'),
	(388065105, 'Rafaela Martins', 994629857, 'Rua das Laranjeiras N16')
;

-- 2
INSERT INTO public.clienteParticular(
	nif, cc)
	VALUES 
	(659486259, 49862128),
	(123456789, 75485454),
	(486455345, 68457545),
	(765865645, 17437543),
	(175495354, 57203809),
	(854645646, 48347543),
	(383454584, 53129345)
;

--Falta update da tabela cliente coluna cp_nif

-- 3
INSERT INTO public.clienteInstitucional(
	nif, nomeContato)
	VALUES 
	(689425389, 'Guilhereme Santos'),
	(234567890, 'Vera Cisne'),
	(123395354, 'Tiago Patrício'),
	(435344578, 'Elena Borges'),
	(764953465, 'Alberto Caeiro'),
	(247554854, 'Ricardo Reis'),
	(388065105, 'Álvaro Campos')
;

-- 4
INSERT INTO public.veiculo(
	matricula, nif, nomeCondutor, telefone, gps)
	VALUES 
	('20-VT-65', 659486259, 'Fábio Fernandes', null, null),
	('40-AB-15', 689425389, 'Rúben Castro', 975463454, null),
	('89-GG-25', 689425389, 'Pedro Guimarães', 985628349, null),
	('AG-58-65', 486455345, 'Antonieta Delgado', null, null),
	('08-CB-66', 175495354, 'Larissa Reis', 963454342, null),
	('43-FH-10', 383454584, 'Cristiano Oliveira', 944475340, null),
	('AB-01-20', 123395354, 'Marcela Silva', null, null),
	('BC-BB-21', 764953465, 'Domingos Cardoso', 960454842, null),
	('CD-TH-10', 388065105, 'Nádia Susana', 915626349, null)
	;

-- 5
insert into public.zonaverde(longitude, latitude, raio, matricula)
	values
	(4.5, 3.0, 8.3, '40-AB-15'),
	(2.8, 2.8, 20.3, 'AG-58-65'),
	(2.9, 2.3, 6.4, '43-FH-10'),
	(5.1, 1.2, 4.0, 'BC-BB-21'),
	(3.7, 3.6, 2.0, 'CD-TH-10'),
	(1.6, 9.2, 2.5, 'AB-01-20'),
	(5.9, 3.7, 1.5, '08-CB-66')
;


-- 6
INSERT INTO public.gps(
	marcaTemporal, longitude, latitude, estado, matricula)
	VALUES 
	('2022-03-17 10:01:47', 2.3, 3.34, 'Activo', '20-VT-65'),
	('2022-04-07 04:14:47', 3.04, 7.21, 'Activo', '89-GG-25'),
	('2022-03-08 16:32:47', 4.12, 3.33, 'PausaDeAlarmes', '40-AB-15'),
	('2022-02-07 11:17:09', 1.23, 5.08, 'Inactivo', '89-GG-25'),
	('2022-03-17 10:06:47', 2.14, 2.34, 'Activo', 'AG-58-65'),
	('2022-04-01 18:32:47', 3.42, 8.69, 'Activo', '08-CB-66'),
	('2022-01-09 15:23:47', 5.65, 4.42, 'PausaDeAlarmes', '43-FH-10'),
	('2022-02-07 11:47:09', 3.87, 6.19, 'Inactivo', 'AB-01-20'),
	('2022-01-16 16:55:47', 2.54, 1.12, 'PausaDeAlarmes', 'BC-BB-21'),
	('2022-02-20 11:40:09', 4.06, 2.06, 'Inactivo', 'CD-TH-10')
;
	
--Falta update da tabela veiculo coluna id_equip

-- 7
INSERT INTO public.registoNProcessado(
	longitude, latitude, dat, gps)
	VALUES 
	(3.0, 9.5, null, 1),				-- inválido, devido a data
	(6.8, 4.2, '2022-01-02', 1),		-- válido
	(5.3, 1.0, '2020-02-13', null),	-- inválido pelo identificador de gps
	(1.9, 6.0, '2022-04-20', 2),
	(4.0, 3.5, '2021-03-05', 1),
	(3.6, 4.7, null, 4),				-- inválido, devido a data
	(2.8, 2.2, '2022-03-02', 5),		
	(5.3, 6.0, null, null),	
	(1.9, 6.0, '2021-01-20', 7),
	(4.0, 6.9, '2022-01-05', 1),
	(2.3, 3.3, '2022-02-06', 6),	
	(2.9, 6.5, null, 9),
	(5.0, 4.9, '2020-01-30', 10),
	(4.0, 6.9, '2021-01-31', 5),
	(5.3, 7.3, '2022-02-06', 7),
	(1.9, 6.5, null, 6),
	(3.0, 8.9, '2022-01-07', 9)
	;	

-- 8
insert into public.processado(longitude, latitude, dat, gps)
	values
	(6.8, 4.2, '2022-01-02', 1),
	(4.0, 3.5, '2021-03-05', 1),
	(4.0, 6.9, '2022-01-05', 1),
	(1.9, 6.0, '2021-01-20', 7),
	(5.3, 7.3, '2022-02-06', 7)
	;

-- 9	
insert into public.alarme(id, dataHora)
	values
	(1, '2022-01-02 13:00:00'),
	(2, '2021-03-05 09:06:03'),
	(3, '2022-01-05 22:55:54'),
	(4, '2021-01-20 16:37:11'),
	(5, '2022-02-06 05:44:13')
	;
	
commit;
	

	