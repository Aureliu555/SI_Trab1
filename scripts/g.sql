start transaction;
create or replace function zonaVerdeValida(zvlo real default null, zvla real default null, zvraio real default null, 
										   rlo real default null, rla real default null)
returns boolean 

language 'plpgsql' as $$

--declare rs boolean;

begin
	if(zvlo is null or zvla is null or zvraio is null or rlo is null or rla is null)
		then raise notice 'Não preencheu todos os parâmetros da função'; rollback;
	end if;

	if (power(zvlo-rlo,2) + power(zvla - rla, 2) < power(zvraio,2) )
		then return TRUE;
	else 
		return FALSE;
	end if;
end;
$$;
commit;

------------------------------------------ zonaVerdeValidaTest ----------------------------------------------------
start transaction;
create or replace function zonaVerdeValidaTest(registoLatitude real)
returns boolean 

language 'plpgsql' as $$

declare rs numeric;

begin
select round( CAST(registoLatitude as numeric), 1) into rs;

	if (mod(rs::integer,2) = 0)
		then return TRUE;
	else 
		return FALSE;
	end if;
end;
$$;
commit;


------------------------------------------ insert function ----------------------------------------------------
start transaction;

create or replace function generate_alarme()
returns trigger as $$


declare csr cursor for select zv.longitude, zv.latitude, zv.raio, gps.estado
            from ((processado as prc inner join gps on(prc.gps = gps.id)) inner join veiculo as v on(gps.matricula = v.matricula))
				inner join zonaVerde as zv on (v.matricula = zv.matricula)
            where prc.id = new.id;

declare zvlon real;
declare zvlat real;
declare zvr real;
declare isToInsert boolean default FALSE;
declare prc record;
declare gpsState varchar(20);

begin

select * into prc
from processado
where processado.id = new.id;



open csr;

loop
    fetch next from csr into zvlon, zvlat, zvr, gpsState;
    exit when not found;
        if (zonaVerdeValida(zvlon, zvlat, zvr, prc.longitude, prc.latitude) or gpsState = 'PausaDeAlarmes') then isToInsert:=TRUE;
        end if;
end loop;
close csr;
	if isToInsert = FALSE then insert into alarme(id,dataHora) values (new.id, CURRENT_TIMESTAMP);
	end if;
return new;
end;
$$
language 'plpgsql';

commit;
---------------------------------------- trigger ----------------------------------------
start transaction;

create or replace trigger trigger_processado_insertion
after insert on processado
for each row
execute procedure generate_alarme();
commit;


