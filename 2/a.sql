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
