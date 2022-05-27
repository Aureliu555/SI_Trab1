begin transaction;

DROP TABLE IF EXISTS 
	cliente, clienteInstitucional, clienteParticular, veiculo,
	gps, zonaVerde, registoNProcessado, invalido, processado,
	alarme
	cascade;
	
commit transaction;