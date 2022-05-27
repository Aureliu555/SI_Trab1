------------------------------------------ insert function ----------------------------------------------------
--set isolation level read committed

create or replace function update_vehicleAlarms()
returns trigger as $$

declare matr varchar(10);

begin 
	select v.matricula into matr
	from (((alarme as al inner join processado as prc on (al.id = prc.id))
		inner join gps on (prc.gps = gps.id)) inner join veiculo as v on (gps.matricula=v.matricula))
	where al.id = new.id for update;

	update veiculo
	set numAlarmes = numAlarmes + 1
	where matricula = matr;

	return new;
end;
$$
language 'plpgsql';

---------------------------------------- trigger ----------------------------------------

create or replace trigger trigger_update_vehicle_alarms
after insert on alarme
for each row
execute procedure update_vehicleAlarms();
