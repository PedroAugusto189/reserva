require 'csv'

class Database
  attr_accessor :recursos, :reservas

  def initialize
    @recursos = []
    @reservas = []
    carregar_dados # Carrega os dados dos arquivos CSV ao inicializar
  end

  # Adiciona um recurso e salva no CSV
  def adicionar_recurso(recurso)
    @recursos << recurso
    salvar_recursos
  end

  # Adiciona uma reserva e salva no CSV
  def adicionar_reserva(reserva)
    @reservas << reserva
    salvar_reservas
  end

  # Lista todos os recursos
  def listar_recursos
    @recursos
  end

  # Lista todas as reservas
  def listar_reservas
    @reservas
  end

  # Verifica se já existe uma reserva para o mesmo recurso no mesmo horário
  def reserva_existe?(recurso_id, data_hora)
    @reservas.any? { |reserva| reserva.recurso_id == recurso_id && reserva.data_hora == data_hora }
  end

  # Busca um recurso pelo ID
  def buscar_recurso_por_id(id)
    @recursos.find { |recurso| recurso.id == id }
  end

  # Salva os recursos em um arquivo CSV
  def salvar_recursos
    CSV.open('recursos.csv', 'w') do |csv|
      csv << ['id', 'nome', 'capacidade'] # Cabeçalho
      @recursos.each do |recurso|
        csv << [recurso.id, recurso.nome, recurso.capacidade]
      end
    end
  end

  # Salva as reservas em um arquivo CSV
  def salvar_reservas
    CSV.open('reservas.csv', 'w') do |csv|
      csv << ['id', 'recurso_id', 'nome_cliente', 'email', 'data_hora'] # Cabeçalho
      @reservas.each do |reserva|
        csv << [reserva.id, reserva.recurso_id, reserva.nome_cliente, reserva.email, reserva.data_hora]
      end
    end
  end

  # Carrega os dados dos arquivos CSV
  def carregar_dados
    carregar_recursos
    carregar_reservas
  end

  # Carrega os recursos do arquivo CSV
  def carregar_recursos
    if File.exist?('recursos.csv')
      CSV.foreach('recursos.csv', headers: true) do |row|
        id = row['id'].to_i
        nome = row['nome']
        capacidade = row['capacidade'].to_i
        @recursos << Recurso.new(id, nome, capacidade)
      end
    end
  end

  # Carrega as reservas do arquivo CSV
  def carregar_reservas
    if File.exist?('reservas.csv')
      CSV.foreach('reservas.csv', headers: true) do |row|
        id = row['id'].to_i
        recurso_id = row['recurso_id'].to_i
        nome_cliente = row['nome_cliente']
        email = row['email']
        data_hora = row['data_hora']
        @reservas << Reserva.new(id, recurso_id, nome_cliente, email, data_hora)
      end
    end
  end
end