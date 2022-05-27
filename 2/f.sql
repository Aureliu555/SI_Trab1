------------------------------------- registo_nprocessado procedure ----------------------------------------------

--set isolation level repeatable read

create or replace procedure process_registoNprocessado ()
language plpgsql as $$
--begin atomic
--reads sql data

declare my_cursor cursor for select * from registoNProcessado for share;
declare rnp_id integer;
declare rnp_lotd real;
declare rnp_latd real;
declare rnp_dtReg date;
declare rnp_gps integer;

begin

open my_cursor;
	loop
	fetch next from my_cursor into rnp_id, rnp_lotd, rnp_latd, rnp_dtReg, rnp_gps;
	exit when not found;
		if rnp_lotd is null or rnp_latd is null or rnp_dtReg is null or rnp_gps is null
			then
				insert into invalido (id) values (rnp_id);
		else
			if (select exists(select 1 from processado as pr where pr.longitude = rnp_lotd and pr.latitude=rnp_latd and pr.dat=rnp_dtReg and pr.gps=rnp_gps))
				then 
					delete from registoNProcessado where id = rnp_id;
			else 
				insert into processado(longitude, latitude, dat, gps) 
					values (rnp_lotd, rnp_latd, rnp_dtReg, rnp_gps);
			end if;
			
			delete from registoNProcessado where id = rnp_id;
			
		end if;
	end loop;
close my_cursor;

end;

$$;
--language 'plpgsql';
