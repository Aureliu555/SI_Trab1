------------------------------------- count number of alarms ----------------------------------------------
--create or replace function create_view_row(id_prc integer)

create or replace function insert_into_Alarme_and_Processado()
returns void as $$
--returns trigger as $alarme_insertion$

declare rnp record;
declare id_a integer;
declare matricula integer;
declare condutorNome integer;
declare newRow record;
begin
select * into rnp from registoNProcessado where id = id_rnp;

insert into processado(longitude, latitude, dat, gps, rnp)
		values(rnp.longitude, rnp.latitude, rnp.dat, rnp.gps, rnp.id);

select processado.id into id_a from processado where processado.rnp = rnp.id; 

insert into alarme(id, dataHora)
			values (id_a, CURRENT_TIMESTAMP);

select alarme, v.matricula, v.nomeCondutor, pr.longitude, pr.latitude into newRow
from ((alarme inner join processado as pr on (alarme.id = pr.id)) inner join gps on (pr.gps = gps.id)) inner join veiculo as v
		on (gps.matricula = v.matricula);
		
insert into list_Alarme
	values (newRow.alarme);
	
insert into list_Alarme
	values (newRow.matricula, newRow.nomeCondutor);

insert into list_Alarme
	values (newRow.longitude, newRow.latitude);

END;$$
language 'plpgsql' ;
--$alarme_insertion$;





-- Function call without parameter 'matricula'
begin transaction;

select insert_into_Alarme_and_Processado(2);

commit;
