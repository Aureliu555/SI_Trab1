--isolation level repeatable read;

create or replace view list_Alarme
as select alarme, v.matricula, v.nomeCondutor, pr.longitude, pr.latitude
from ((alarme inner join processado as pr on (alarme.id = pr.id)) inner join gps on (pr.gps = gps.id)) inner join veiculo as v
		on (gps.matricula = v.matricula);
