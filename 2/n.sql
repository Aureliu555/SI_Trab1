-- @Author Grupo8


--!! Em caso de qualquer um dos testes não corresponder ao resultado apresentado é necessário correr os scripts(deleteTable, createTable and insertTable) pois
--os testes de cada alínea foram pensados para a alínea em causa apenas !!

------------------************* testes *************----------------------
---------------***** 2d *****---------------

-- teste 1: Inserir Cliente Particular com dados bem passados (incluindo o cpNif): Resultado OK
-- parâmetros: novoCC, novoNif, novoNome, nomeTelefone, novaMorada, nifDeReferenciaClienteParticular
set transaction isolation level repeatable read;
start transaction;
select add_to_clienteParticular(44112233, 103103103,'Gustavo Lima','922887700', 'Rua Castanheira do Sul N11', 659486259) for share;
commit;


-- teste 2: Inserir Cliente Particular com dados bem passados (sem o cpNif): Resultado OK
-- parâmetros: novoCC, novoNif, novoNome, nomeTelefone, novaMorada, nifDeReferenciaClienteParticular
set transaction isolation level repeatable read;
start transaction;
select add_to_clienteParticular(33112233, 123123123,'Raquel Lima','933887700', 'Rua Castanheira do Sul N11') for share;
commit;


-- test 3: Inserir Cliente Particular com dados mau passados (com um cc já existente): Resultado NOK
-- parâmetros: novoCC, novoNif, novoNome, nomeTelefone, novaMorada, nifDeReferenciaClienteParticular
set transaction isolation level repeatable read;
start transaction;
select add_to_clienteParticular(33112233, 599667334,'Lurdes Campos','955443322', 'Rua Amendoeira do Norte N1') for share;
commit;

rollback;


-- test 4: Inserir Cliente Particular com dados mau passados (com um nif já existente): Resultado NOK
-- parâmetros: novoCC, novoNif, novoNome, nomeTelefone, novaMorada, nifDeReferenciaClienteParticular
set transaction isolation level read committed;
start transaction;
select add_to_clienteParticular(33223311, 123123123,'Lurdes Campos','955443322', 'Rua Amendoeira do Norte N1') for share;
commit;

rollback;


-- test 5: Atualizar Cliente Particular com dados bem passados (incluindo cpNif): Resultado OK
-- parâmetros: novoCC, novoNif, novoNome, novoTelefone, novaMorada, nifDeReferencia, nifDeReferenciaClinteParticular
set transaction isolation level repeatable read;
start transaction;
select update_from_clienteParticular(88224466, 456456456, 'Núria Barros', '911223344','Rua Cajueiro Seco N30', 103103103, 854645646) for share;
commit;


-- test 6: Atualizar Cliente Particular com dados bem passados (sem cpNif): Resultado OK
-- parâmetros: novoCC, novoNif, novoNome, novoTelefone, novaMorada, nifDeReferencia, nifDeReferenciaClinteParticular 
set transaction isolation level repeatable read;
start transaction;
select update_from_clienteParticular(66224466, 567567567, 'Samanta Alfredo', '933223344','Rua Avelã Damascena N10', 123123123) for share;
commit;


-- test 7: Atualizar Cliente Particular com dados mau passados (cc já usado): Resultado NOK
-- parâmetros: novoCC, novoNif, novoNome, novoTelefone, novaMorada, nifDeReferencia, nifDeReferenciaClinteParticular 
set transaction isolation level repeatable read;
start transaction;
select update_from_clienteParticular(57203809, 135135135, 'Rita Duarte', '910000123','Rua das Nozes Douradas N14', 456456456) for share; 
commit;

rollback;


-- test 8: Atualizar Cliente Particular com dados mau passados (nif the referencia inexistente): Resultado NOK
-- parâmetros: novoCC, novoNif, novoNome, novoTelefone, novaMorada, nifDeReferencia, nifDeReferenciaClinteParticular 
set transaction isolation level repeatable read;
start transaction;
select update_from_clienteParticular(11001100, 100220011, 'Joana Paulo', '933003300' ,'Rua dos Figos Secos N7', 999999999) for share; 
commit;

rollback;


-- test 9: Remover Cliente Particular com dados bem passados: Resultado OK
-- parâmetro: cc
set transaction isolation level repeatable read;
start transaction;
select remove_from_clienteParticular(66224466) for share;
commit;


-- test 10: Remover Cliente Particular com dados maus passados (cc não existente) : Resultado NOK
-- parâmetro: cc
set transaction isolation level repeatable read;
start transaction;
select remove_from_clienteParticular(00000000) for share;
commit;

rollback;




---------------***** 2e *****---------------

-- test 11: Calcular o total de alarmes para um determinado veículo com dados bem passados (incluindo a informação para a matricula): Resultado OK
-- parâmetros: ano, matricula
set transaction isolation level repeatable read;
select count_num_of_alarms(2022,'20-VT-65') for share;
commit;

-- test 12: Calcular o total de alarmes para um determinado veículo com dados bem passados (sem a informação para a matricula): Resultado OK
-- parâmetros: ano, matricula
set transaction isolation level repeatable read;
select count_num_of_alarms(2022) for share;
commit;


-- test 13: Calcular o total de alarmes para um determinado veículo com dados mau passados (um ano em que há alarmes): Resultado NOK
-- parâmetros: ano, matricula
set transaction isolation level repeatable read;
select count_num_of_alarms(2020) for share;
commit;

rollback;


-- test 14: Calcular o total de alarmes para um determinado veículo com dados mau passados (uma matricula inexistente): Resultado NOK
-- parâmetros: ano, matricula
set transaction isolation level repeatable read;
select count_num_of_alarms(2022, 'ZZ-33-ZZ') for share;
commit;

rollback;


---------------***** 2f *****---------------

-- test 15: Processar os registos não processados e dividir em processados e inválidos: Resultado OK
start transaction isolation level read committed;
call process_registoNProcessado();
commit;



---------------***** 2g *****---------------

-- test 16: Verificar se as coordenadas do registo a ser processado se encontrarem dentro da zona verde: Resultado OK (TRUE)
-- parâmetros: zonaVerdeLongitude, zonaVerdeLatitude, zonaVerdeRaio, processadoLongitude, processadoLatitude
start transaction isolation level read committed;
select zonaVerdeValida(2.0, 1.8, 6.0, 1.5, 1.3) for share;
commit;

rollback;

-- test 17: Verificar se as coordenadas do registo a ser processado se encontrarem dentro da zona verde: Resultado NOK (FALSE)
-- parâmetros: zonaVerdeLongitude, zonaVerdeLatitude, zonaVerdeRaio, processadoLongitude, processadoLatitude
start transaction isolation level read committed;
select zonaVerdeValida(3.4, 2.9, 1.2, 2.0, 3.5) for share;
commit;



-- test 18: Verificar se as coordenadas do registo a ser processado se encontrarem dentro da zona verde (parâmetros em falta): Resultado NOK
-- parâmetros: zonaVerdeLongitude, zonaVerdeLatitude, zonaVerdeRaio, processadoLongitude, processadoLatitude
start transaction isolation level read committed;
select zonaVerdeValida(3.4, 2.9, 1.2, 2.0) for share;
commit;

rollback;



-- test 19: Verificar se o arredondamento da latitude do registo processado resulta num número par: Resultado OK
-- parâmetros: processadoLatitude
start transaction isolation level read committed;
select zonaVerdeValidaTest(10.4) for share;
commit;


-- test 20: Verificar se o arredondamento da latitude do registo processado resulta num número par: Resultado NOK
-- parâmetros: processadoLatitude
start transaction isolation level read committed;
select zonaVerdeValidaTest(10.7) for share;
commit;

rollback;


-- test 21: Analisar o registo processado aquando da sua criação e gerar o respetivo alarme (fora de qualquer zona verde): Resultado OK
start transaction isolation level read committed;
insert into processado(longitude, latitude, dat, gps)
		values(5.8, 2.2, '2022-05-02', 1);
commit;


-- test 22: Analisar o registo processado aquando da sua criação e gerar o respetivo alarme (dentro uma zona verde): Resultado NOK
start transaction isolation level read committed;
insert into processado(longitude, latitude, dat, gps)
		values(0.5, 0.1, '2022-02-02', 5);
commit;


---------------***** 2h *****---------------

-- test 23: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona (sem longitude, latitude e raio): Resultado OK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('10-PG-20',689425389,'Pedro Miguel', '912345678',0,2);
commit;


-- test 24: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona: Resultado NOK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('10-PG-20',680000100,'Cesário Soares', '922345678',0,4);
commit;

rollback;

-- test 25: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona: Resultado OK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('16-TD-22',388065105,'Rogério Dias', '933345678',0,5, 3.6, 5.7, 5.8);
commit;


-- test 26: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona: Resultado OK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('20-PC-21',659486259,'Maria Mendes', '916785678',0,2);
commit;

-- test 26: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona: Resultado NOK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('30-LS-20',659486259,'André Pogba', '912345678',0,2);
commit;

-- test 26: Criar um veículo com a respectiva informação do equipamento associado e que o associe a um cliente.
-- Caso sejam passados dados para a criação de uma zona verde, deve criar e associar o veículo a essa zona: Resultado NOK
-- parâmetro: novaMatricula, nifDoCliente, nomeCondutor,telefoneContato, numAlarmes,idGps, longitude, latitude, raio
start transaction isolation level repeatable read;
call create_and_associate_Veiculo('40-CD-22',659486259,'Cristiano Lourenço', '912345678',0,2);
commit;

rollback;


---------------***** 2i *****---------------

-- test 27: Criar uma vista que liste todos os alarmes e deverá apresentar a matrícula do veículo, o nome do condutor, 
-- as coordenadas e a data/hora do alarme: Resultado OK
start transaction isolation level repeatable read;
create or replace view list_Alarme
as select alarme, v.matricula, v.nomeCondutor, pr.longitude, pr.latitude
from ((alarme inner join processado as pr on (alarme.id = pr.id)) inner join gps on (pr.gps = gps.id)) inner join veiculo as v
		on (gps.matricula = v.matricula);
commit;




---------------***** 2j *****---------------
-- implementação sem sucesso

-- Function call without parameter 'matricula'
start transaction isolation level read committed;

select insert_into_Alarme_and_Processado();

commit;

---------------***** 2k *****---------------

-- test 28: Apagar os registos inválidos existentes com duração superior a 15 dias: Resultado OK
start transaction isolation level read committed;

call delete_Invalido_in_registoNProcessado();

commit;



---------------***** 2l *****---------------
-- implementação sem sucesso



---------------***** 2m *****---------------

-- test 29: Criar um alarme e actualizar o número de alarmes do veículo: Resultado OK


start transaction isolation level read committed;
insert into processado(longitude, latitude, dat, gps, rnp)
		values(90.8, 2.2, '2022-03-10', 1, 2);
commit;

