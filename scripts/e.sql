------------------------------------- count number of alarms ----------------------------------------------
start transaction;

create or replace function count_num_of_alarms(ano integer, info_matricula varchar(10) default null)
returns integer as $$

declare num_alarms integer; 

declare counter integer default 0;

begin

select count(*) into counter from alarme as al where date_part('year', al.dataHora::date) = ano;

if counter < 1
	then raise notice 'Não existe nenhum alarme para o ano que escreveu'; rollback;
end if;

select count(*) into counter 
from ((alarme as al inner join processado as prc on (al.id = prc.id)) inner join gps on (prc.gps=gps.id)) 
	inner join veiculo as v on (gps.matricula=v.matricula) 
where v.matricula = info_matricula;

if info_matricula is not null and counter < 1
	then raise notice 'A matricula que inseriu não existe'; rollback;
end if;

if info_matricula is null
	then
	select count(*) into num_alarms
			from alarme where date_part('year', alarme.dataHora::date) = ano;
	return num_alarms;
else
	select count(*) into num_alarms
			from ((alarme as al join processado as pr on (al.id = pr.id)) join gps on (pr.gps = gps.id)) 
					join veiculo as v on (gps.matricula = v.matricula)
			where date_part('year', al.dataHora::date) = ano and v.matricula = info_matricula;
			return num_alarms;
end if;
--return num_alarms;

END;
$$
LANGUAGE 'plpgsql';

commit;


