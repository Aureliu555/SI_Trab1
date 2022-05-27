------------------------------------- count number of alarms ----------------------------------------------
start transaction;

create or replace procedure delete_Invalido_in_registoNProcessado()

language 'plpgsql' as $$ 

declare my_cursor cursor for select rnp.id, rnp.dat from invalido as i natural join registoNProcessado as rnp;
declare dat date;
declare rid integer;

begin

open my_cursor;
	loop
	fetch next from my_cursor into rid, dat;
	exit when not found;
		if dat is null or age(dat) > interval '15 days'
			then
				delete from invalido where invalido.id = rid;
				delete from registoNProcessado where registoNProcessado.id = rid;
		end if;
	end loop;
close my_cursor;

END; $$;

commit;

