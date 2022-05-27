------------------------------------- add to cliente_particular ----------------------------------------------
start transaction;
create or replace function add_to_clienteParticular(new_cc integer, new_nif integer,new_nome varchar(150),
    new_telefone varchar(10), new_morada varchar(150), new_cp_nif integer default null)

returns void as $$

begin
	if (new_cp_nif is null)
		then
			insert into cliente(nif,nome,telefone,morada)
			values(new_nif, new_nome, new_telefone, new_morada);
	else
		insert into cliente(nif,nome,telefone,morada, cpNif)
		values(new_nif, new_nome, new_telefone, new_morada, new_cp_nif);
	end if;
	
	insert into clienteParticular(cc,nif)
	values(new_cc, new_nif);

end;
$$
language 'plpgsql';
commit;

------------------------------------- remove from clienteParticular ----------------------------------------------
start transaction;
create or replace function remove_from_clienteParticular(cc_to_remove integer)

returns void as $$

declare counter integer default 0;

begin

	select count(*) into counter
	from clienteParticular as cp
	where cp.cc = cc_to_remove;

	if (counter > 0)
		then
			delete from clienteParticular
				where cc = cc_to_remove;
	else 
		raise notice 'Não existe nenhum cliente com o cc indicado'; rollback;
	end if;
end;
$$
language 'plpgsql';
commit;


------------------------------------- update from cliente_particular ----------------------------------------------
start transaction;
create or replace function update_from_clienteParticular(new_cc integer, new_nif integer, new_nome varchar(150), new_tel varchar(10), 
					new_morada varchar(150), ref_nif integer, new_cp integer default null)
returns void as $$

declare counter integer default 0;
begin

	select count(*) into counter from clienteParticular as cp where cp.nif = ref_nif; 
	if(counter < 1)
		then raise notice 'Não existe um cliente com o nif passado como referência'; rollback;
	end if;

	if (new_cp is not null)
		then
			insert into cliente(nif,nome,telefone, morada, cpNif)
				values(new_nif, new_nome, new_tel, new_morada, new_cp);
	else
		insert into cliente(nif, nome, telefone, morada)
			values(new_nif, new_nome, new_tel, new_morada);
	end if;

	update clienteParticular
		set cc = new_cc, nif = new_nif
		where nif = ref_nif;

	update veiculo
		set nif = new_nif
		where nif = ref_nif;

	delete from cliente
		where nif = ref_nif;

end;
$$
language 'plpgsql';
commit;


