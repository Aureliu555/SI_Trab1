start transaction;

create or replace procedure create_and_associate_Veiculo(
	matr varchar(10),
	cliente_nif integer,
	nome  varchar(150),
	tel varchar(10),
	alarmes integer,
	gps integer,
	lgtd real default null,
	lttd real default null,
	radius real default null
)
language plpgsql as $$
--begin atomic
--reads sql data
declare n integer;

declare variavelInutil varchar(10); -- não altera em nada o código, será afetada por um valor qualquer

begin

	if ((lgtd is null and lttd is null and radius is null) or 
	   (lgtd is not null and lttd is not null and radius is not null)
	   )
		then variavelInutil := 'abc';
		else raise notice 'Faltam argumentos para a criação de uma zona verde'; rollback;
	end if;

select count(cliente.nif) into n from cliente where cliente.nif = cliente_nif;
	if (n = 0)
		then
			raise notice 'O nif que inseriu não pertence a nenhum cliente'; rollback;
	end if;

select count(cliente.nif) into n from cliente natural join clienteParticular 
	where cliente.nif = cliente_nif;

	if(n = 1) 
		then 
			select count(veiculo.nif) into n from veiculo where veiculo.nif = cliente_nif;
			if (n < 3)
				then 
					insert into veiculo(matricula, nif, nomeCondutor, telefone, numAlarmes, gps)
					values(matr, cliente_nif, nome, tel, alarmes, gps);
				else raise notice 'Não é possível associar mais veículos a este cliente'; rollback;
			end if;
		else 
			insert into veiculo(matricula, nif, nomeCondutor, telefone, numAlarmes, gps)
					values(matr, cliente_nif, nome, tel, alarmes, gps);		
	end if;

	if (lgtd is not null and lttd is not null and radius is not null)
		then
			insert into zonaVerde(longitude,latitude,raio,matricula)
			values (lgtd, lttd, radius, matr);
	end if;

end;$$;
--language 'plpgsql';
commit;




