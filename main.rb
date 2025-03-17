require_relative 'recurso'
require_relative 'reserva'
require_relative 'database'

# Inicializa o banco de dados
db = Database.new

# Função para validar se o email é válido
def email_valido?(email)
  email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
end

# Função para validar se a data/hora é futura
def data_futura?(data_hora)
  Time.now < Time.parse(data_hora)
rescue ArgumentError
  false
end

# Loop principal do programa
loop do
  puts "\n--- Sistema de Reservas ---"
  puts "1. Cadastrar Recurso"
  puts "2. Listar Recursos"
  puts "3. Fazer Reserva"
  puts "4. Listar Reservas"
  puts "5. Sair"
  print "Escolha uma opção: "
  opcao = gets.chomp.to_i

  case opcao
  when 1
    # Cadastrar Recurso
    print "Digite o nome do recurso: "
    nome = gets.chomp
    print "Digite a capacidade do recurso: "
    capacidade = gets.chomp.to_i
    id = db.recursos.size + 1
    recurso = Recurso.new(id, nome, capacidade)
    db.adicionar_recurso(recurso)
    puts "Recurso cadastrado com sucesso!"

  when 2
    # Listar Recursos
    puts "\n--- Recursos Disponíveis ---"
    db.listar_recursos.each do |recurso|
      puts "ID: #{recurso.id} | Nome: #{recurso.nome} | Capacidade: #{recurso.capacidade}"
    end

  when 3
    # Fazer Reserva
    puts "\n--- Fazer Reserva ---"
    print "Digite o ID do recurso: "
    recurso_id = gets.chomp.to_i

    # Verifica se o recurso existe
    recurso = db.buscar_recurso_por_id(recurso_id)
    if recurso.nil?
      puts "Erro: Recurso não encontrado."
    else
      print "Digite seu nome: "
      nome_cliente = gets.chomp

      # Validação do email
      print "Digite seu email: "
      email = gets.chomp
      unless email_valido?(email)
        puts "Erro: Email inválido."
        next
      end

      # Validação da data/hora
      print "Digite a data e hora (ex: 2023-10-10 14:00): "
      data_hora = gets.chomp
      unless data_futura?(data_hora)
        puts "Erro: A data/hora deve ser futura."
        next
      end

      # Verifica se já existe uma reserva para o mesmo recurso no mesmo horário
      if db.reserva_existe?(recurso_id, data_hora)
        puts "Erro: Já existe uma reserva para este recurso no mesmo horário."
      else
        # Cria a reserva
        id = db.reservas.size + 1
        reserva = Reserva.new(id, recurso_id, nome_cliente, email, data_hora)
        db.adicionar_reserva(reserva)
        puts "Reserva realizada com sucesso!"
      end
    end

  when 4
    # Listar Reservas
    puts "\n--- Reservas Realizadas ---"
    db.listar_reservas.each do |reserva|
      puts "ID: #{reserva.id} | Recurso ID: #{reserva.recurso_id} | Cliente: #{reserva.nome_cliente} | Data: #{reserva.data_hora}"
    end

  when 5
    # Sair
    puts "Saindo..."
    break

  else
    puts "Opção inválida. Tente novamente."
  end
end