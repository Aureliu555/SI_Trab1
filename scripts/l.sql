------------------------------------- count number of alarms ----------------------------------------------
create or replace procedure disable_Cliente_on_deletion(cond boolean)
language plpgsql as $$

begin

delete if exists from clienteParticular
	where cond;

delete if exists from clienteInstitucional
	where cond;
	
update cliente
	where cond;

end;

$$;

