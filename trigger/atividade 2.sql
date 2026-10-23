create table contas(
id serial primary key,
cliente varchar(100) not null,
saldo numeric(10, 2) not null default 0.00	
);

--

create table movimentacoes(
id serial primary key,
conta_id int references conta(id),
tipo varchar(1) check (tipo in ('C', 'D')),
valor numeric(10, 2) not null,
  data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--
CREATE OR REPLACE FUNCTION fn_atualiza_saldo_conta()
RETURNS TRIGGER AS $$
BEGIN

  IF NEW.tipo = 'C' THEN
        UPDATE contas SET saldo = saldo + NEW.valor WHERE id = NEW.conta_id;
    ELSIF NEW.tipo = 'D' THEN
        UPDATE contas SET saldo = saldo - NEW.valor WHERE id = NEW.conta_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--

CREATE TRIGGER trg_atualiza_saldo
AFTER INSERT ON movimentacoes
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_saldo_conta();